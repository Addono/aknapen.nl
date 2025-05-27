---
title: "Lines of Code is a Bad Productivity Metric, also for AI"
date: 2025-05-27
draft: false
tags: ["AI", "Software Development", "Productivity", "Engineering Metrics"]
description: "Exploring why measuring developer productivity by lines of code is a flawed metric, especially with the rise of AI in software engineering."
---

> *“One Amazon engineer said his team was roughly half the size it had been last year, but it was expected to produce roughly the same amount of code by using A.I.”*
> — [New York Times, May 25, 2025](https://www.nytimes.com/2025/05/25/business/amazon-ai-coders.html)

Generative AI is transforming software engineering. Used well, it can boost productivity, uncover solutions faster, and streamline development workflows. I’m all for that.

But in the rush to adopt AI, we’re also seeing the resurgence of a long-debunked idea: that developer productivity can be measured by the *amount* of code written.

This was never a good metric. It’s tempting because it’s easy to track. But it says very little about the value or quality of the work being done. And now, with AI in the mix, it’s not just misleading—it’s actively harmful.

## AI Can Write More Code—That’s the Problem

Modern AI can generate huge volumes of code in seconds. At a glance, this code may even appear solid. If you're lucky—and as models continue to improve, you might increasingly be—some of it will work right out of the box.

But if anything, I want AI to write *less* code. Or more precisely: *more concise*, *more thoughtful* code.

I still want it to solve problems, implement features, and fix bugs. But I don’t want a flood of boilerplate or surface-level fixes that mask deeper issues.


## AI’s Shortcuts Come at a Cost

AI has learned how to write “working” code using what I’d call cheap tricks. These solutions are technically functional, but often lack the design thinking or domain awareness that an experienced developer brings.

Take a common bug: an unhandled exception. Many AI models “fix” this by catching all exceptions and suppressing them. Sometimes they’ll log it, but often they don’t. The error disappears, and with it, any chance to understand the root cause.

Before, you might’ve seen a specific `FileNotFoundException` pointing to a missing dependency or a misconfigured path. Now, that critical breadcrumb is lost—silently swallowed by a generic try-catch.

Multiply this over dozens of "fixes," and you end up with a codebase that’s brittle, verbose, and difficult to reason about. These are “bubblegum and duct tape” solutions. They hold for now, but break under pressure.

And measuring developer output by lines of code? That just incentivizes more of them.

## Volume Metrics Lead to Technical Debt

If your project can afford mountains of technical debt, then by all means—tell your team to crank out as much code as they can, aided by AI. Measure them on how many lines they wrote last week.

But most real-world projects aren’t like that.

They demand maintainability. Reliability. Clarity. And those things require time—especially when using AI. Developers need space to curate its output, guide it toward solutions that match their standards, and ensure they fully understand the result.

Yes, that’s slower. But it’s better in every way that matters.

## Simplicity Isn’t Accuracy

It would be incredibly convenient if, in the age of AI, we could finally use a simple metric like lines of code to measure productivity. In today’s economic climate, where efficiency is under the microscope, a clear-cut number feels reassuring.

But code volume was never an accurate proxy for value. And in the age of AI, it’s even less so.

### Let your developers do what they’ve always done best: Think

Give them the time and trust to use AI well—not to produce *more* code, but *better* solutions.

---

*This post is a longer form of [my LinkedIn post](https://www.linkedin.com/feed/update/urn:li:activity:7333021968914341888/).*
