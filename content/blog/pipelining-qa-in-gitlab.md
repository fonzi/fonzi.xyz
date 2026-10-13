---
title: "Pipelining Qa in Gitlab"
date: 2023-03-06T19:22:56-06:00
draft: false
---

It's been about 3 months that I switched from Github over to Gitlab. At my previous job. I had to use github actions for pipeline. Now I use Gitlab. 
I can honestly say that Github is 100 times better and more intuative on how it works. As well as the market place is a great resource. I'm not sure 
if Gitlab has something like that built into their roadmap. However, I keep writing code that I know other people have solved, because I find it in gitlab threads. So why would Gitlab continue to propagate the re-invention of the wheel? Ideally CICD makes you more productive. But if you have to keep
writing custom code that other people have solved. Even if it just takes 30 minutes to look up, copy, paste and run, it would still be faster to have a 
market place with small pieces of code that solve a very specific issue. 

Another one of my gripes with Gitlab is the fact that you cannot have multiple actions. But rather you must either use templates and pull into a single file, which I understand the concept, but ideally I should be able to seperate files per functionality completly different behavior from one another. 

Here's the example of the issue above. 

1. I want to run X amount of pipeliens at night 
2. I want to run X amount of pipelines that are differnt manually. 

I must place both of those rules in the same file, instead of having two well defined files that reduce the scope of each pipeline. 

One project can have multiple pipelines especially in QA depending on the bussiness need. QA Could want to run Smoke or Regression without having to share the file just to make it easier. 

Gitlab also forces you to do things by pipeline. However, in a QA world, sometimes you have data generation scripts that you might want to run at any given time that do not fit on a pipeline and you want to outsource that run to less experienced peeps that might not know how to run scripts locally. Github Actions allows you to give them a link and tell them just click run. Vs Gitlab forces you to have a pipeline setup. Makes no sense. I understand the concept of jobs inside pipelines, but not everything is always a pipeline. 

So if you are looking to go with Github or Gitlab. Choose Github. It's the clear winner from a QA perspective.

*2023-03-06T19:22:56-06:00
