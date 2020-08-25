+++
title = "Always-Free Managed PostgreSQL Databases Reviewed"
description = "Not all free tiers are equal, here I cover the pros and cons of various free managed Postgres database offerings."
tags = [
    "Postgres",
    "PostgreSQL",
    "Database",
    "DBaaS",
    "Serverless",
    "Development",
    "Cloud"
]
date = "2020-08-25"
categories = [
    "Development",
    "Technology"
]

+++

# Always Free Managed Postgres Databases Reviewed

I'm a big proponent for serverless, especially for small but long-running projects. Such project needs to be as simple as possible to get started and require no maintenance. Many of the serverless providers offer a generous free-tier, which often suffices until the project gains traction.

Serverless compute resources are quite easy to come by, for example [Vercel](https://vercel.com/), [Netlify](https://www.netlify.com/) or [AWS Lambda](https://aws.amazon.com/lambda/) allow for a vast amount of serverless function executions in their free-tier. If you don't like serverless functions and rather go for containers, then there's [Heroku](https://heroku.com/) or [Fly](https://fly.io). Free databases are on the other hand harder to come by and often a lot more constrained in their free tier.

When building one of my simple and personal projects on top of Postgres I switched a couple of times between several free tiers. As it happens, the performance of these databases vary greatly, which is something they do not advertise on their signup page.

Next I will cover Heroku Postgres, ElephantSQL and AlwaysData. These services all have an always free tier on their managed Postgres. All major cloud providers also have free tiers or free trial credits for their managed Postgres services, however here they will be omitted as this won't be a solution for a project which you want to keep running for more than a year without pulling out your wallet or migrating the database.

For each of the database offerings I cover there's also a demo deployment of a simple web-app. Feel free to play around with it and judge the performance of each of the providers by yourself. You can use your browser inspection mode to get better insight in the timing or cause of errors. Note that all deployments might need some warm up time, as resources will get unprovisioned when they are not accessed for a while.

## Heroku Postgres

If you're able to host your project on Heroku, then I would recommend them wholeheartedly. They have amazing performance, are easy to integrate with into your project and have a pleasant UI.

✅ Automatically exposes the database connection string as an environment variable to your application

✅ Intuitive UI which clearly shows how much of the resources in your tier you are consuming

✅ Daily backups for the last 7 days

✅ Superb performance (<100ms for complete requests, both read and write)

✅ Recent version of Postgres (12.3 whilst latest as of writing is 12.4)

❌ Requires hosting your application on a Heroku Dyno, as they regularly automatically the database password

❌ Automated backup can only be configured using their CLI 

Limits: 10,000 rows; 20 concurrent database connections; 1 GB database.

Demo: https://heroku-postgres-addon.herokuapp.com

![Heroku Postgres Database Details](/img/blog/heroku-postgres-addon-database-view.png)

## ElephantSQL

Searching for free a free managed Postgres database probably lets you end up at [ElephantSQL](https://www.elephantsql.com/). Won't recommend them at all, the performance is terrible, they run an outdated version of Postgres and have a very limited free tier.

✅ Static database connection url allows hosting your application on a different application provider

✅ Allows you to choose the underlying cloud-provider

❌ Simple queries taking 2 seconds is quite common

❌ Runs an outdated version of Postgres (11.5)

❌ 5 concurrent connections easily exhausted when old deployments keep connections open (regularly newly deployed serverless functions were unavailable, as older deployments exhausted the connection pool)

Limits: 5 concurrent database connections; 20 MB database

Demo: https://elephantsql.vercel.app

![ElephantSQL Database Portal](/img/blog/elephantsql-portal.png)

## AlwaysData

If Heroku isn't an option and you still want to have slightly better performance than ElephantSQL, then [AlwaysData](https://www.alwaysdata.com/) could be an option. Their UI is decent looking and powerful, however getting simple things done takes some exploring before you get what you were looking for.

✅ Powerful role-based access control to limit access rights for each user by database

✅ Insight and possibility to terminate individual connections

❌ Simple read queries take around 500ms whilst write can go up to 2 seconds

❌ UI takes some getting used to

❌ Only using databases whilst on their free tier is against their ToS

❌ Their deployment model dates from before containers (think along the lines of assuming your deployment process consists of uploading PHP files over FTP), so you're out of luck if your Node application requires `npm install` or is container based

Limits: 50 concurrent database connections; 100 MB database (both shared globally on your account)

Demo: https://alwaysdata.vercel.app

![AlwaysData Postgres Active Connections Overview](/img/blog/alwaysdata-postgres-active-connections.png)

## Conclusion

None of these options are perfect and what you get seems a lot more restrictive and limited compared to serverless compute options. ElephantSQL and AlwaysData seem like relics from the PHP days whose DBaaS service might still be  useful in the cloud era. However, both services seem heavily under provisioned, hence performance wise they seem unsuitable for applications where the user needs to wait for database queries. Heroku on the other hand offers a crisp UI and their deployment models is truly cloud native.