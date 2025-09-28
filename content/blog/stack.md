---
title: "Running Two Sites, Analytics, and a Search Engine on a $5 VPS"
date: 2025-09-28
draft: false
---

There’s a myth you need heavy infrastructure to run real projects online. Kubernetes clusters, managed cloud services, and expensive bills often get presented as the “default” for hosting anything serious.  

The truth is simpler: I run **two websites**, **analytics**, and even **a full search engine** on a single **$5/month Vultr VPS**. And it works just fine.  

---

## The VPS

My entire setup lives on a $5/month Vultr instance with:  

- 1 vCPU  
- 1 GB RAM  
- 25 GB SSD  

That’s all I need. No autoscaling groups, no sprawling services, just one small virtual machine.

---

## Domains

I split my domains between two registrars:  

- **Epik** for `fonzi.xyz`  
- **Namecheap** for `bison.software`  

Both point to the same VPS, where Nginx handles SSL with Let’s Encrypt and routes requests to the right service.

---

## What Runs Inside

Here’s the breakdown of what actually lives on this box:

- **Static websites**  
  - `fonzi.xyz`: generated with Hugo.  
  - `bison.software`: plain HTML, with a static contact form that posts to [staticforms.xyz](https://www.staticforms.xyz).  

- **Analytics**  
  - [GoatCounter](https://www.goatcounter.com/), running in Docker.  
  - A lightweight, privacy-friendly alternative to Google Analytics.  

- **Search engine**  
  - [SearXNG](https://searxng.org/), also in Docker.  
  - This isn’t just a search box — it’s a full metasearch engine that queries dozens of sources.  
  - Served at `searx.fonzi.xyz`.  

At idle, the whole system sits around ~500 MB RAM. That leaves breathing room even on this tiny instance.

---

## Architecture

Here’s how everything connects:

![Architecture diagram](/diagram.svg)

---

## Monitoring Without Bloat

Monitoring is simple:  

- **htop** for live CPU/memory/disk checks.  
- **sysstat (sar)** for historical CPU and memory logs.  

No dashboards, no bloated agents, no extra services consuming resources. Just the basics.

---

## Why Minimal Works

This approach works because it focuses on what matters:  

- **Cost** all of this runs for less than $6/month.  
- **Control** Vultr doesn’t decide what’s acceptable content; they only enforce legality.  
- **Simplicity** static sites and Dockerized apps mean fewer moving parts.  
- **Rebuildability** I can redeploy from scratch in under an hour if needed.  

Minimal doesn’t mean fragile. It means focused, efficient, and easy to maintain.

---

## Closing

You don’t need a complex cluster or a big monthly cloud bill to put real projects online. With a small VPS, some static sites, and a couple of containers, you can host everything you need and keep full control of it.  

This setup runs two domains, analytics, and a search engine — all on a $5 Vultr server. Nothing more required.
