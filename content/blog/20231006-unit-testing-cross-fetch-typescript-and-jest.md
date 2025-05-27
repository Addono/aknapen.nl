+++
title = "Unit Testing Cross-Fetch, TypeScript and Jest"
description = "A brief post on how to start writing unit tests for cross-fetch in TypeScript using Jest."
tags = [
    "Node.js",
    "TypeScript",
    "Development"
]
date = "2023-10-06"
categories = [
    "Development",
    "Technology"
]

+++

Writing unit-tests for a library which overwrites the global `fetch` function can be a bit tricky. This post will show you how to do it.

## The Problem

When using `cross-fetch` in TypeScript, you will most likely import it like this:

```typescript
import crossFetch from "cross-fetch"
```

This is because the `cross-fetch` package is not the default export, but rather a named export. However, when you want to mock the `cross-fetch`, you can't use the `jest.mock("cross-fetch")` syntax. This is because the `cross-fetch` package is not the default export, but rather a named export. 

To fix this, you can use the `jest.mock("cross-fetch", () => {})` syntax. This will allow you to mock the `cross-fetch` package.

## The Solution

To mock the `cross-fetch` package, you can use the following code:

```typescript
import crossFetch from "cross-fetch"

jest.mock("cross-fetch", () => {
  // Mock the default export
  return {
    __esModule: true,
    default: jest.fn(),
  }
})

test("should do a mock fetch", () => {
  // Arrange
  jest.mocked(crossFetch).mockResolvedValue({
    status: 201,
    json: async () => {
      return {
        user: null,
      }
    },
  } as Response) // Type-casting as we only want to define a partial response object

  // Act
  const result = crossFetch("http://foo.com")

  // Assert
  expect(result.then(r => r.status)).resolves.toEqual(201)
})
```

## The Explanation

First, we globally mock `cross-fetch` module, such that all calls by default use a mocked version of `fetch`. This prevents us from making any actual network calls.

Then, inside the test itself, we provide yet another mock, this time only for the default import we named `crossFetch`. This default method is called in the source-code, so by mocking it we now have control over the actual return values.

This allows us to define inside the tests what values we would like to return. TypeScript will complain if the return type doesn't match the implementation of the module we're mocking. However, we can use type-casting to tell TypeScript that we're only interested in a partial implementation of the `Response` object. Alternatively, you can also define a full implementation of the `Response` object.
