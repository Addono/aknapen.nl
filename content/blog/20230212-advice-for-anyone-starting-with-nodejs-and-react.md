+++
title = "Advice for starting with Node.js and React"
description = ""
tags = [
    "React",
    "Node.js",
    "TypeScript",
    "Development"
]
date = "2023-02-12"
categories = [
    "Development",
    "Technology"
]

+++

# Advice for starting with Node.js and React

TL;DR:
 - Dos
   - Write TypeScript from day 1
   - Start with a slightly opiniated tech-stack
 - Don'ts
   - Avoid tech-stacks completely bloated with tools
   - Avoid resources using class-based React notation
   - Avoid npm-libraries without types
   - Avoid state-management libraries like Redux, MobX


## Do: Use TypeScript

> TL;DR: TypeScript gives you guard-rails while developing. It forces you to think about how your code works before running it, which shortens the feedback loop gives you better understanding on why your code works.

This by far is the advice which by far gets ignored the most. But before saying that TypeScript is too complex to _also_ learn while diving deep into your first JavaScript project, please hear me out. 

TypeScript is not trivial to learn, especially if you have never worked with typed languages. So yes, you're right, it will take time and effort. However, I'm entirely convinced it will bear its fruits. And those fruits normally start to pay of very early on already.

With TypeScript, your IDE suddenly understands your code. It will tell you when you're trying to do something which is highly unlikely to work (e.g. reading a property from a variable which is potentially `null`), without you having to run it. 

By the time you start to call dependencies, you have the added benefit that the types will define how you can use those dependencies.