+++
title = "Continuous Deploy your own Matrix instance"
description = ""
tags = [
    "gitlab",
    "ansible",
    "continuous-integration",
    "automation",
]
date = "2019-07-23"
categories = [
    "Development",
    "DevOps",
]
highlight = "true"
+++
## Bye Whatsapp
A while ago I decided to move away from Whatsapp and Telegram in favor of [Matrix](https://matrix.org/), mostly to imporve my privacy and get more control over my own data - yes Whatsapp, I'm looking at your limited backup options. But enough about the idealistic tech vision and more about tech itself.

To get the most out of Matrix it is best to deploy an instance for yourself. It's quite an involved process, however luckily [there's an Ansible playbook](https://github.com/spantaleev/matrix-docker-ansible-deploy) which does most of the heavy lifting for you. However, it is still frequently updated, hence I was executing the playbook quite often.

## Cron to the Rescue
My first step of automating this process was by wrapping the playbook update commands in a short shell script, which then was executed every night by a cron job. It worked, but was far from ideal, for starters:
* __Ease of use__: The Ansible playbook was executed from a VM - to make matters worse, the same machine as where Matrix was deployed on. Hence, in order to manually invoke the playbook or access the logs one had to SSH into the machine. So, fixing anything without a computer at hand was quite painfull.
* __Reliability__: If the entire VM would, for whatever reason, disappear from the face of the earth, then nothing could be retrieved or recovered. As everything, including data, config and logs, where merely present on this single instance.

## Pipelines for the rescue
In order to tackle the problem I decided to check the configuration into version control and use a CI/CD pipeline to automatically deploy. For everyone who rather plays with the code than to continuou reading, you can find it [here](https://gitlab.com/Addono/matrix-ansible-cd) and it should be rather easy to set it up yourself.

In short, it uses a Gitlab CI pipeline which uses the latest version of the playbook to deploy the application. You can either use it for merely initiated manually update, or use the scheduled pipelines functionality to get similar behaviour to cron jobs. The best thing is, Gitlab offers quite a bit of execution time for free for your pipelines, so there's no need to pay anything.