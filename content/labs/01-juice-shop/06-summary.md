---
title: 06 Summary
type: docs
---

In this lab, I installed the the OWASP Juice Shop web application on the `juicero` VM, and added a service called `juice-shop` to run that web application when the VM starts.

I added another VM called `customer` by clonging the `sysadmin` workstation VM and changing the hostname.

I also created a new user called `juicero` to run the service, instead of using the superuser `root`.

Right now, this is what the lab looks like:
![juice-shop diagram](../../diagrams/lab-01-juice-shop.drawio.png)