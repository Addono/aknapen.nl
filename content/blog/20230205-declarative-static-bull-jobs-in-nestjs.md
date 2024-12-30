+++
title = "Global declarative Cronjobs in Nest.js with Bull"
description = ""
tags = [
    "Nest.js",
    "Node.js",
    "TypeScript",
    "Development"
]
date = "2023-02-05"
categories = [
    "Development",
    "Technology"
]

+++

# Global declarative Cronjobs in Nest.js with Bull

There are several ways on how to schedule repeatable jobs in Nest.js. The [official documentation](https://docs.nestjs.com/techniques/task-scheduling) suggests using `@nestjs/schedule`. This library offers an elegant CRON-based API, which should be familiar to most Nest.js developers.

Look at how neat and simple this declarative API is:

```ts
@Injectable()
export class MyService {
  @Cron("* * * * * *")
  handleCron() {
    console.log("CRON is triggered");
  }
}
```

With one line, we now have a method which will trigger whenever our heart desires. Pretty neat.

**However**, there is a glaring issue with `@nestjs/schedule`, it **creates one Cronjob for every instance of your application you're running**. This could be fine for some use-cases, for example if you run only once of your application, however most larger production-grade applications at some point will adopt horizontal scaling.

Even if your application tolerates running the same job multiple times, it can range from merely wasteful (e.g. doing the same database cleanup multiple times) to problematic (e.g. sending duplicate daily digest email to all your users).

## Global jobs

[Bull](https://github.com/OptimalBits/bull) is a [job queue with direct support by Nest.js](https://docs.nestjs.com/techniques/queues). Besides queuing jobs, you can also use it to schedule repeatable jobs. Those jobs are then persisted in Redis as its data store.

All instances of your application now connect to one Redis datastore. Now, whenever a repeatable job is ready to be executed, only one of your instances will pick it up. Bull is responsible for tracking whether the job is successfully completed, and we can configure it to retry jobs. Bonus points for resiliency.

Using Bull for repeatable jobs has one downside though: There's no declarative API available to automatically create these jobs. So, either you need to do it manually - 🤮 - or have your application manage it.

Luckily, it turns out to be quite easy to let your application manage it. Take a look at the following example. It consists of one service and a job processor class. The interesting bit here is that the service has a `onModuleInit`-method, which is responsible for scheduling our static jobs. 

{{< gist Addono d99884b20f935fc420ad39b528f93e5a >}}

Now, every time our application starts, it will delete all existing scheduled jobs and schedule the jobs we need. This way, if we release a newer version of our app with jobs with a different configuration, the application will reconfigure the jobs.
