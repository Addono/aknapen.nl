+++
title = "Optimizing Docker container image size when using Yarn"
description = "This post covers how installing dependencies in your Docker image using `yarn install` can cause unnecessary bloat, why it happens, and the simple steps to take on how to fix it."
tags = [
    "Node.js",
    "TypeScript",
    "Yarn",
    "Docker",
    "Development"
]
date = "2022-10-23"
categories = [
    "Development",
    "Technology"
]

+++

# Optimizing Docker container image size when using Yarn

In this post, I'm briefly going over how installing dependencies in your Docker image using `yarn install` can cause unnecessary bloat, why it happens, and the simple steps to take on how to fix it.

## Backstory time

The other day, I was [containerizing](https://github.com/Addono/docker-bull-monitor/) a simple Node.js project. The MVP Dockerfile was as simple as it gets:

```Dockerfile
FROM node:16.18.0-alpine

COPY ./package.json ./yarn.lock ./

RUN yarn install --immutable --production
```

Yet, after adding a development dependency the resulting image size bloated from 57.5 MB to 70.36 MB ([v1.0.0](https://hub.docker.com/layers/addono/bull-monitor/1.0.0/images/sha256-6a386c7c02c3836ca04c791eed1fb91e2d7edd4c4e73209f75968c3653020109?context=explore) vs. [v1.0.1](https://hub.docker.com/layers/addono/bull-monitor/1.0.1/images/sha256-2c34083754dde90bbfac427b4348b2427875b54c3047830693fe86849e547393?context=explore)).

So, even though we didn't add anything extra to the resulting image, we still ended up with a **22% increase in image size** 🤔. Not nice.

## What's going on?

There's this handy tool [`dive`](https://github.com/wagoodman/dive) which makes it easy to figure out how each layer changed the file system of the resulting image. Let's open up that new version and see what's going on:

```command
dive addono/bull-monitor:1.0.1
```

In this case, the only action in the Dockerfile which can cause this substantial change is in the `yarn install`-step. So that's the first place we will look:

![Dive CLI interface showing the decomposed layers](/img/blog/20221023-dive-image-analysis.jpg)

Unexpectedly, the dependency installation step added a lot of files in the `node_modules`-directory, as that's where Node.js dependencies are usually stored.

But, what's interesting is this `.cache` directory Yarn created for itself. We don't need this cache, since we don't intend to install more dependencies in this image. Thus, it's useless to ship this as part of our image.

## The fix

Simply deleting the files in a subsequent step in the Dockerfile won't work. The initial layer already contains the cache-files, so a later layer deleting the file wouldn't remove those files from the preceding layer.

Luckily we do have the power of multi-stage builds. In this way, we can first create an image which pulls in all dependencies, then copy only the files we really need over to the production image.

It's only a [small change](https://github.com/Addono/docker-bull-monitor/commit/1de899b5216d00d7efcf4822ddd5f2593384b324), but now we're sure that only the dependency files and the original `package.json` will land in our final image. This last bit is now application specific, since the image we're building needs to understand exactly which files are needed in the final image.

```Dockerfile
###################################################
# Builder stage which pulls in all dependencies   #
###################################################
FROM node:16.18.0-alpine as builder

COPY ./package.json ./yarn.lock ./

RUN yarn install --immutable --production

###################################################
# Create the stage which will run the application #
###################################################
FROM node:16.18.0-alpine as runner

# Copy in all the dependencies we need, by avoiding
# installing them in this stage, we prevent Yarn
# from including additional cache files, which
# yields a slimmer image.
COPY                ./package.json  ./
COPY --from=builder ./node_modules/ ./node_modules/
```

## We did it! 🎉

Immediately we see that our Docker image **reduced in size by over 35%** 😮‍💨 . Pure profit.

![Screenshot of Docker Hub showing the sizes of the various versions we published](/img/blog/20221023-docker-hub.jpg)