+++
title = "Containerizing Secret Hitler.io"
description = ""
tags = [
    "Containers",
    "Docker",
    "docker-compose",
    "Automation",
			    "Open Source",
]
date = "2020-04-28"
categories = [
    "Development",
    "Deployment",
    "DevOps",
]
highlight = "false"
+++

## Game Night
Some weeks ago I found myself wanting to play the social deduction game [Secret Hitler](https://www.secrethitler.com). There’s an excellent online version [Secret Hitler.io](https://secrethitler.io), which during the ongoing Corona related lock-down is a great find. There was one issue: Sign-ups were disabled that night because of excessive demand. So instead of a game night we went on to see if we could deploy our own version, as the website is open source anyway.

I have never ran into an open source project which has as it’s “How to run in production” the simple message “Don’t”. But what’s a better motivator to do something than someone telling you not too? In their defense: I understand that they merely open-sourced it to make sure that the license of the assets of the original game (CC Attribution-NonCommercial-ShareAlike 4.0) are not violated, without them having any intention of supporting other deployments than their own. But being able to have a small instance just to play with friends is a requested feature not only by me, so we walked past the warning signs and started our adventures.

## Black or White Box?
So by now it was already quite clear that the original project was not going to supply any help deploying the application. There’s some very basic guidance on configuring a local development instance, but that was about it. At this point, we were not interested in modifying their code base in any way, so the plan was to black-box their Node application, put it in a container and ship it off. Soon enough we realized that this was not going to cut it, first of all because it was completely unclear what the entrypoint of the application was 🧐. Secondly, all Postgres and Redis hostnames were hardcoded to `localhost` all over the code base 😭. 

## Containers Here We Come!

Without further ado:
 * [Docker Hub hosted image `addono/secret-hitler`](https://hub.docker.com/r/addono/secret-hitler)
 * [`docker-compose.yaml`](https://raw.githubusercontent.com/Addono/secret-hitler/master/docker-compose.yaml)
 * [`Dockerfile` ](https://raw.githubusercontent.com/Addono/secret-hitler/master/Dockerfile)
 * [Github Repository `addono/secret-hitler`](https://github.com/Addono/secret-hitler)

The simplest way to get started is to run:
```bash
# Download the docker-compose.yaml
wget https://raw.githubusercontent.com/Addono/secret-hitler/master/docker-compose.yaml

# Start secret-hitler with all required services
docker-compose up 
```

When everything is booted up you can access the application at [http://localhost:8080](http://localhost:8080).

If you did this on a VM running in the cloud or your own server, then opening up port 8080 should be enough to be able to play now with friends. At this point, you might want to setup a reverse proxy - e.g. NGINX - with Let’s Encrypt to enable HTTPS and expose the application on a different port. However, assuming you’re only using it to play a game or two with friends this shouldn’t be too much on an issue. 

*Sidenote: I haven’t looked into configuring email, by default it will not have specify any, which causes the register form to fail when an email adres is entered. So, instruct everyone who’se joining that they shouldn’t. PRs fixing this - or any other issues for that matter - are welcome!*