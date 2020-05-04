+++
title = "Prod++[1]: Master Git"
description = "."
tags = [
    "Productivity",
    "Git",
    "Unix",
    "Windows"
]
date = "2020-04-30"
categories = [
    "Productivity",
    "Technology"
]

+++

In this mini-series I will walk you through some habits I replaced in recent times, which have shown to pay off and make me a more productive programmer/power-user of my computer. All these changes should be easy to gradually adopt, so I would highly recommend checking them out. If you’ve any suggestions ☝️ or improvements ✍️, then email me at hi@aknapen.nl or reach out using any of the social media listed [here](https://aknapen.nl).

---

# Prod++[1]: Master Git

Yes, this assumes you’re using Git, which might be everyone’s version control system (VCS) of choice. However, this does not change any of the underlying reasons why you should spend time on becoming effective at using your VCS. So whenever I say Git, please replace it with whichever VCS you are using.

## The Why

Many developers I get to work with are not too comfortable around Git. This is definitely more noticeable with more junior and less “hardskills” focused engineers. The latter referencing to for example UI or UX designers. This makes them more reluctant to using Git for their own personal projects and makes them less effective when needing to combine work.

Using Git for your own projects might seem like an unnecessary overhead to many. However once you get more proficient at it both reduces the time spend on setting everything up and at the same time better at leveraging its strengths. Some reasons on how you can benefit from using Git in your own projects:

- **Time-machine** If you commit frequently you can easily go back to previous versions as to find older implementations, trace bugs to their root and show how your project evolved over time.
- **Self-review** Using Git for your personal projects is a great enabler to become more aware of the changes you are making. Remember those `console.logs` you added all over your code while trying to get this new feature to work? Well, `git diff` does.
- **Backup** Ever had a friend who lost a few weeks of work when their laptop suddenly gave up? If you regularly push your changes to an external Git repository, then you won’t suffer the same loss.
- **Ease isolated development environment setup** Having the source-code checked into Git allows you to easily setup a new development environment if one is broken or delete everything which is not checked in to clean up.
- **Automation** There are many tools out there to aid your development by hooking into Git. Whether it’s [Prettier](https://prettier.io/) automatically formatting your code locally or [Github Actions](https://github.com/features/actions) to automatically deploy your website.
- **Sharing Code** Having your code base stored in Git makes it easier to share your code, if you ever manage to get someone interested in giving it a look.

## The How

### Use Aliases

There are some great collections of Git aliases available to significantly shorten your commands and easy using back practices (e.g. making `git push --force-with-lease` the default rather than `git push --force`). I personally use the [`git`](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/git) plugin from [Oh My ZSH](https://ohmyz.sh/), although [`gitalias/gitalias`](https://github.com/gitalias/gitalias) also offers a great collection. Don’t be afraid to look them regularly look them up, either online or using the `which` command to expand the alias. Also, adding your own aliases is always an option if you still find that you’re repeating yourself.

As to give an example:
![Example on how short Git aliases speed up work](/img/blog/git-aliases.png)

### Fix Your Own Mess

When starting with Git it can be tempting to just delete the entire repository when there didn't seem to be an easy way out, for example when merge-conflicts arose or your have commits you want to get rid of. Short term this might very well be the quickest solution, however these issues often stem from a lack of understanding how Git works. Spending a bit of time researching to understand how you got into this situation is a great way of getting to know Git and the principles behind it. Without properly grasping the fundamentals of Git, it is impossible to ever reach a more advanced level.

### Inspect the Log

Git can visualise history in a great way. This allows you to easily see what changed between versions, what commits are shared between your feature and master branch and which commits are not yet pushed to the remote. I will leave you with the following screenshot, there's already a lot going on and it might take some time to get comfortable reading it. But it's a great tool to have in your toolbox, as it allows you to quickly figure out what the current state of your repository is.

![Screenshot of a Git commit log graph](/img/blog/git-graph-log.png)

There are many ways on how to render the graph, for this I would refer back to the aliases mentioned earlier. Although you can quickly get started with a basic command such as `git log --graph --all`.

### Read the Changelog

Okay, this might sound very boring at start. Luckily Github has really nice way of covering Git's changelog. As of writing, version [2.26](https://github.blog/2020-03-22-highlights-from-git-2-26/) is the latest release. When I first ran into these posts, I found it easiest to read the log of the current version and navigate to the previous one by following the link at the top. What I especially like about Github's changelog is that there's a strong focus on how it benefits you, rather than merely covering what changed as the [official](https://github.com/git/git/tree/master/Documentation/RelNotes) Git changelog does.

Even small changes of for example new flags or under the hood performance improvements show you what is actively worked on, which parts are getting deprecated and how Git is being used. Slowly your Git knowledge will get stale, so keeping up with the changes allows you to stay ahead of the curve.

### Don't be Scared to (Rewrite) History

At first, rebasing, soft/hard resetting, amending and force-pushing might sound scary, because these tools are just a subsection of the tools available to rewrite or delete history. When getting started, be cautious and make sure that until you properly understand what you're doing before you try it in an environment where you can cause serious harm. It's not rocket science, but a mistake is easily made.

If you're comfortable to remove, reorder and overwrite commits, you can more freely add commits when you're working. Leaving cleaning up to something only done last before you push to master or you create a pull request. Frequently adding commits while you're working allows you to understand what you tried and more easily revert part of your changes. But maybe the most important benefit is that it makes it significantly harder to lose progress once it's committed.
