---
title: "UI Automation Root Issues"
date: Sun, 04 Sep 2022 23:55:43 -0500
draft: false
description: "What really causes flaky tests?"
---

# UI Automation Root Issues

Ever since the inception of webapps, there has been issues with UI automation. Teams tend to overlook the automation phase and ignore it. Mostly because it's time consuming and it's really hard to have a decent framework. Test are also brittle. However, I peronslly think the brittle-ness is not Automation specific but usually and underlaying issue in the web app. It usually ends up showing up as bad code. Bad implementations, and bad architecture. Since automation is usually created after the webapp, it usually follows those same bad practices as the webapp. Now I'm NOT saying that these are the only issues. But from my experience these are usually the true root issues.

So how do we solve for this. Usually there seems to be three main problems to solve.

1. Bad Architecture
2. Bad Implementation
3. Bad Infrastructure


## Bad Architecture

Usually this is the first issue. When a webapp has no cohesion around UI and functionality, each page will be it's own small domain. This will make it very hard to abstract tests in order to re-use automation methods. The fix here is to get early into the development cycle and try to drive the model that will be used. However, this is easier said that done. Best approach is to point it out to developers in a nice way. However, good architecs are hard to find, so webapps end up displaying very odd functionality.

Modals with functionality - This is the terrbile espeially with smooth appearing
Dropdows with a single button inside - Why is there even a dropdown button for a single button
Async calls - This is usually where the bad architecture shows itself and it's hardest to debug. Having all the network calls in async, and not understanding how and why they load in certain orders can cause havoc.

## Bad Implementation

This is usually done when there is some new cool hip JS library (another reason why I hate JS) and it's the modern thing. Developers use the new library. And it's not implemented correctly. Things are getting forced to the way of the webapp instead of the philosophy of the framework. This is usually and issue with developers not giving back to the Opensource Community. They want to take these establish frameworks. Make them work with some very specific need, and instead of making a PR for the framework to support the case, they'll just hack around it. Usually by mixing another framework or another library making another half-assed implementation.



## Bad Infrastructure

Now this one is a bit harder to track down, but usually it's obvious once you know what too look for. Usually, bad infrastructure shows as the webapp gets really slow when automation is running. This is usually observable by looking at a Monitoring Tool. Another easy spot is to look at the DB calls that it makes and see if something is locking the db. The final and hardest thing to track down with Infrastructure is the complextity around WAFs. If automation is distributed it might be that the WAF is blocking calls.

*Sun, 04 Sep 2022 23:55:43 -0500*
