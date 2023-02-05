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

There are a couple of ways on how to schedule repeatable jobs in Nest.js. `@nestjs/schedule` is what the [official documentation](https://docs.nestjs.com/techniques/task-scheduling) guides you towards. It's an elegant CRON-based API, which should be familiar to most developers.

Look at how elegant this declarative API is:

```ts
@Injectable()
export class MyService {
  @Cron("* * * * * *")
  handleCron() {
    console.log("CRON is triggered");
  }
}
```

With one line, we now have a method which will trigger whenever our heart desired. Pretty neat.

However, one downside of `@nestjs/schedule` is that it creates one Cronjob for every instance of your application you're running. This is fine if your entire app runs only once, however for scaling and redundancy reasons you probably want to start horizontally scaling your application. Now, the same task will run multiple times.

At best, this is just wasteful, e.g. cleaning multiple processes to try to clean something up in your database at the same time. Other times, it will actually cause problems, e.g. it would be bad to send a daily digest email to all your users multiple times.

## Global jobs

[Bull](https://github.com/OptimalBits/bull) is a [job queue with direct support by Nest.js](https://docs.nestjs.com/techniques/queues). Besides queuing jobs, you can also use it to schedule repeatable jobs. Those jobs are then persisted in Redis as its data store.

This Redis data store is then shared by all the instances of your application. Now, whenever a repeatable job is ready to be scheduled, one of your instances will pick it up. Now Bull is responsible for tracking whether the job is successfully completed, and we can configure it to retry jobs. Bonus points for resiliency.

Using Bull for repeatable jobs has one downside though: There's no declarative API available to automatically create these jobs. So, either you need to do it manually - 🤮 - or have your application manage it.

Luckily, it turns out to be quite easy to let your application manage it. Take a look at the following example. It consists of one service and a job processor class. The interesting bit here is that the service has a `onModuleInit`-method, which is responsible for scheduling our static jobs. 

{{< gist Addono d99884b20f935fc420ad39b528f93e5a >}}

Now, every time our application starts, it will delete all existing scheduled jobs and schedule the jobs we need. This way, if we release a newer version of our app with jobs with a different configuration, the application will reconfigure the jobs.
