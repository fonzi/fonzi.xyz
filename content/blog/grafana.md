---
title: "Grafana"
date: 2024-12-30T10:22:41-06:00
draft: false
---

Sometimes, there's a need for QA to monitor data. This has been an interesting challenge in recent years, where entire ETL pipeline monitoring tools have emerged. We recently had an incident at work where some of our users were dropping properties (most likely due to human error). We still wanted to catch and alert on significant deviations.

The Problem: No way to monitor significant deviations.

Initially, I figured it'd be cool to read directly from our data source. In this case, MongoDB. We had a simple limitation: not being in the enterprise Grafana tier nor MongoDB Enterprise, which meant we did not have a direct connection to MongoDB as a data source.

The first obstacle was figuring out how to read directly from the database in hopes of identifying some cool historical trends. No biggie. I was sure someone had already solved this issue, and I was mostly right. Someone had created a plugin that was easy to install:[MongoDB Datasource Plugin](https://github.com/haohanyang/mongodb-datasource). Coincidentally, there was a bug fix our team needed, and the author of the plugin was already working on it. You can see me testing this here: [Issue #15](https://github.com/haohanyang/mongodb-datasource/issues/15). Pretty sweet to be able to collaborate with Open Source for a day job, all because of a quick need.

At first, this solution seemed like all we needed. However, I quickly realized we were missing something critical: historical data. To detect deviations, we needed a historical record of the user's data before any changes occurred. Since this was not implemented in MongoDB, I had to find another way.

You can see that I had a cool Login Failure Rate. Since that does have historical data in its collection. However, I still needed properties.

![Grafana](https://i.ibb.co/vQQn8MM/grafana-first.png)

The middleware I created was a quick tool that scraped the MongoDB collection, pushed the data to Pushgateway and Prometheus, and then allowed Prometheus/InfluxDB to retain the historical data. We run this tool every two hours, which gives us solid historical insights.

This is pretty cool, actually. We already had a case where we needed some data to be stored, and the way it works is as follows:

```Script Runs in Bibtucket ----> Bitucket Restuls get pushed to PushGateway ----> PushGateway is scraped by Prometheus ----> Prometheus stores in InfluxDB```

This is the general pipeline of data flow. From MongoDB with no historical data to keeping historical data on a pinch. The ideal solution would be to update the MongoDB collection to keep the data as well.

Once we had this setup, we could calculate deviations by percentage. Now, we get Slack alerts if a user experiences a significant drop in properties. This allows us to monitor all our users simultaneously without fear of missing critical changes.

![Monitor](https://i.ibb.co/tq8Yh95/percentage-monitor.png)

We use this type of monitor now, with an environment variable for each of our users, to avoid being overwhelmed with lines and to narrow down to the problem user.

Some of the math involved behind the scenes includes:

`sum by (email) (user_hotel_info{environment="prod"} offset 15m)` (historical data)

`sum by (email) (user_hotel_info{environment="prod"})` (current data now)

Then, in the match function and a reduce function, we use the following:
`(($A - $B) / ($A + 1e-10)) * ($A > $B)` 
This checks for sudden drops in properties.

Finally, we set this as an alert:
`abs(($A - $B) / ($A + 1e-10)) > 0.1`
Here, 0.1 represents 10%, but it can be adjusted as needed.

Even QA has a use for Grafana, and more QA engineers should explore the DevOps world to solve internal issues like this one, beyond just UI/API automation. I've noticed a trend where QA engineers thrive as solution engineers, with QA being their primary role.


2024-12-30T10:22:41-06:00