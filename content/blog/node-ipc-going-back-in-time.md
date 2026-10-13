---
title: "Node IPC. Going back in time."
date: Sat, 26 Mar 2022 18:35:15 -0500
draft: false
description: "Trust in open source shattered."
---

# Node IPC Going Back in Time

Well I'm sure if you follow this blog (if anyone), you most likely heard of node-ipc. This reminds me a lot of when people did not know how malware worked, and the famous worm that self-duplicated by looking up everyone in the email contacts and sending itself out. What does this recent event say about the projects it affected? It means that they had little concern about security. They just trusted their projects to one point of failure. An upstream library gone rogue. How could this have been prevented? I think this goes back to the first things that I hinted at: central technologies are a bad idea. Let this be a warning to always audit some code before you let a critical machine do an update. This is why the most important part of open source code is the ability to audit the code. This has been called a new type of malware, "protestware", and I disagree with the name. Deleting data from machines based on their IP address doesn't protest anything. It destroys the work of people who had nothing to do with the decision, and it hurts the trust that all of open source runs on. The lesson for everyone: pin your dependencies, read the release notes, and audit before you merge an update.

*Sat, 26 Mar 2022 18:35:15 -0500*
