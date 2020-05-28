+++
title = "Prod++[2]: Managing Kubernetes Context Files"
description = "On how to effectively store and manage your Kubernetes context files."
tags = [
    "Productivity",
    "Kubernetes",
    "Shell",
    "Bash",
    "Linux",
    "MacOS"
]
date = "2020-05-28"
categories = [
    "Productivity",
    "Technology",
    "Kubernetes",
    "Development"
]

+++

In this mini-series I will walk you through some habits I replaced in recent times, which have shown to pay off and make me a more productive programmer/power-user of my computer. All these changes should be easy to gradually adopt, so I would highly recommend checking them out. If you’ve any suggestions ☝️ or improvements ✍️, then email me at hi@aknapen.nl or reach out using any of the social media listed [here](https://aknapen.nl).

---

# Prod++[2]: Managing Kubernetes Context Files

For anyone who ever worked a bit with Kubernetes, `kubectx` is probably quite familiar. Nothing painfull there when you're just running a local [Minikube](https://minikube.sigs.k8s.io/) cluster, which auto-magically seems to add and update it's configuration. In practice it's updating the `~/.kube/config` file every time you create or remove a cluster. 

This kind of magic is all fine when you're getting started, but soon enough you will find that Minikube is merely one of the sources of Kubernetes contexts. You might also be running [kind](https://kind.sigs.k8s.io/), spin up some clusters in the cloud, or have your collegue share some with you. Soon the amount of different context credentials starts ramping up. `kubectl` doesn't come with an elegant solution out of the box. 

You might end up trying [this](https://stackoverflow.com/a/46184649/7500339) config flattening solution suggested at StackOverflow. Great, now whenever you want to remove a context from your configuration you have to manually siv through this configuration file and delete all references - spoiler alert: this requires editing the space in two or more places. Also, assuming you were successful and didn't overwrite the previous config, you now duplicated your configuration file. 

So what are you going to do with this old configuration file? If you let it hang around, then you will slowly start collecting all these files, soon enough you will lose track which files are already merged and which are not. A mess is imminent if you do not delete them, but the flipside is that removing these files could be irrecoverable.

### The Official Way

Luckily the official documentation has a [suggestion](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#set-the-kubeconfig-environment-variable) on how to solve this issue: Append the new configuration file to the list of configuration files stored in the `KUBECONFIG`environment variable. Manually adding and removing paths to this environment variable remembered me of all the fun times with managing the `PATH` in Windows, which would never get even close to fit on my screen, let alone the small text field they reserved for it. 

Don't dispair, here's the real solution. Add it to your `~/.bashrc` or `~/.zshrc` and no need to ever touch `KUBECONFIG` manually again:

```bash
# Set the location of the Kubernetes configs
export KUBECONFIG=$(find ~/.kube/config ~/.kube/configs -type f 2>/dev/null | paste -s -d : -)
```

Now, every time you start your shell it will join all paths to `~/.kube/config` or `~/.kube/configs` and set them as your `KUBECONFIG`. Both can be either files or directories. I kept `config` as the default file, which Minikube and kind can use for their auto-magic. `configs` is a directory which contains all the context files. Now, adding or removing a file is as easy as respectively copying and deleting a file in `~/.kube/configs` - don't forget to restart the shell to take effect - which made managing all my configs so much easier.

To briefly touch upon how this piece of Bash works, `find` is used to list all file paths. Then `paste` merely joins all these file paths with a colon and violà, we got our `KUBECONFIG`.