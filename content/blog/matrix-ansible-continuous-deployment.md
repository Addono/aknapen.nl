+++
title = "Continuous Deploy your own Matrix instance"
description = ""
tags = [
    "Gitlab",
    "Ansible",
    "Continuous Integration",
    "Automation",
    "Privacy",
		"Open Source",
]
date = "2019-07-23"
categories = [
    "Development",
    "Deployment",
    "DevOps",
    "Technology",
]
+++
# Bye Whatsapp
A while ago I decided to move away from Whatsapp and Telegram in favor of [Matrix](https://matrix.org/), mostly to improve my privacy and get more control over my own data - yes Whatsapp, I'm looking at your limited backup options. But enough about the idealistic tech vision and more about tech itself.

To get the most out of Matrix it is best to deploy an instance for yourself. It's quite an involved process, however luckily [there's an Ansible playbook](https://github.com/spantaleev/matrix-docker-ansible-deploy) which does most of the heavy lifting for you. However, it is still frequently updated, hence I was executing the playbook quite often.

## Iteration #1: Cron to the Rescue
My first step of automating this process was by wrapping the playbook update commands in a short shell script, which then was executed every night by a cron job. It worked, but was far from ideal, for starters:

* __Ease of use__: The Ansible playbook was executed from a VM - to make matters worse, the same machine as where Matrix was deployed on. Hence, in order to manually invoke the playbook or access the logs one had to SSH into the machine. So, fixing anything without a computer at hand was quite painful.
* __Reliability__: If the entire VM would for whatever reason disappear from the face of the earth, then nothing could be retrieved or recovered. As everything, including data, config and logs, where merely present on this single instance.

## Iteration #2: CI/CD Pipelines
The second solution for automating the updating process was to start using pipelines, the ones you normally use for CI/CD. Why CI/CD pipelines? Because calling Ansible from code is nearly trivial, hence they easily integrate with these pipelines. Now, we will get an email when the update fails and have our logs stored safely on a different machine. 

_For everyone who rather plays with the code than to continuo reading, you can find it [here](https://gitlab.com/Addono/matrix-ansible-cd) and it should be rather easy to set it up yourself._

In short, I decided to use Gitlab CI pipelines, which gets and runs the latest version of the playbook to deploy the application. You can either use it for manually initiated update, or use the scheduled pipelines functionality to get the same behavior as we had with the cron job solution. The best thing is, Gitlab offers quite a bit of execution time for free for your pipelines, so there's no need to pay anything.
