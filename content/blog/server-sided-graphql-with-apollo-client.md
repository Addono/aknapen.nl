+++
title = "Server Sided GraphQL with Apollo Client"
description = "The hows and pitfalls of using Apollo Client server sided."
tags = [
    "GraphQL",
    "Apollo Client",
    "NodeJS",
    "Serverless",
    "Development"
]
date = "2020-06-30"
categories = [
    "Development",
    "Technology"
]

+++

# Server Sided GraphQL with Apollo Client

During development of the [ClaimR Dashboard](https://dashboard.claimr.tools) I found myself in the position where I wanted to query a GraphQL endpoint from my backend. It's a NextJS powered project, hence the server sided logic is written in Node. So I started looking around for GraphQL clients but with little success. 

[graphql-request](https://github.com/prisma-labs/graphql-request) seemed like a match, with what looked like a recent release. However, on closer inspection it's pretty clear that it's abandoned, hence not a proper foundation to build a new product upon. I came close to resort to making plain HTTP requests myself, until I stumbled upon Apollo Client feature to make queries yourself.

Apollo Client advocates in their documentation that it's mainly for React, strongly pushing everyone to use their hook based architecture. I have used it a lot and it has recently become my default choice when doing client side GraphQL consumption. However, the server I was building is a GraphQL endpoint itself, hence it involves no React at all.

Behold we can actually use the Apollo Client on server side. I couldn't find a single mention of it in the documentation, and the client is actually branded as "Client (React)". However, on the [Getting Started](https://www.apollographql.com/docs/react/get-started/) page of the documentation they start with using `client.query(...)` before they introduce hook and component based requests.

The options from `client.query(...)` and `client.mutate(...)` are very similar to the `useQuery` and `useMutation` we know from React. Both return a promise, which include the response, error and the like. Here's a little example to show how this approximately looks like.

```typescript
import { ApolloClient, HttpLink, InMemoryCache } from '@apollo/client'

// Create GraphQL Client for FaunaDB
const client = new ApolloClient({
  cache: new InMemoryCache(),
  link: new HttpLink({
    uri: 'https://graphql.fauna.com/graphql',
    headers: {
      "Authorization": `Bearer ${process.env.FAUNADB_SECRET}`,
    },
  }),
  defaultOptions: {
    query: {
      fetchPolicy: 'no-cache',
    },
  }
})

// ...

// Use the client to query our GraphQL endpoint
const { data } = await client.query({
  query: gql`
    query GET_USERS {
      users {
        email
        name
      }
    }
	`,
})
```

Note that in the snippet the `defaultOptions` of the client is configured to disable the cache. This is completely optional, however the default caching policy is reasonable for usage on the frontend. It results in multiple issues:

Having your backend cache everything by default will cause **stale data to be returned**. Here and there I overwrite the `fetchPolicy` for some queries to include caching if I am certain that the response won't change. However, when in doubt don't. Instead, try to go for client-side caching wherever possible. 

I burned my fingers by having (unintentionally) client side and server side caching - both were using Apollo Client. Figuring out where the stale data originated from was tedious, as you need to manually inspect the query responses. Also, it's very easy for another developer to not be aware of this server side caching behavior, which will surely drive them mad when they are debugging.

Another issue which emerged is data **inconsistency**, as I deployed my backend as a serverless function. Each instance deployed by my serverless provider had its own cache, hence different instances would cache different data for the same query. To the user this caused the data to flicker, as requests were routed to an instance at random, causing responses from different instances to contain different results.

Also expect **increased memory usage**, as all responses are stored in the cache by default. This could quickly become an issue if you deploy your backend onto many small instances, as this cache will start to take up quite a bit of memory fast.

Lastly, it should be noted that this form of local caching will see **degraded effectiveness** when a lot of instances are used or instances are purged often - as would be the case in serverless environments. More instances mean having more individual caches, hence the chance of having a cache miss increases with more instances. In the end, the same data needs to be cached multiple times in order to implement effective caching.

To conclude, be mindful about caching. It can help a bit, but the default Apollo Client caching implementation is in memory and hence not as effective as it is on the client side. Maybe in the future we will see a Redis client, as [exists](https://www.npmjs.com/package/apollo-server-cache-redis) for Apollo Server, but until then we will need to make due with what we have.