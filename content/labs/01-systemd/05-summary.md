---
title: 05 Summary
type: docs
---

In this lab, I installed the the OWASP Juice Shop web application on the `juiceshop` VM, and added a service called `juice-shop` to run that web application when the VM starts.

I added another VM called `customer` by clonging the `sysadmin` workstation VM and changing the hostname.

I also created a new user called `juiceshop` to run the service, instead of using the superuser `root`.

Right now, this is what the lab looks like:
![libvirt diagram](../../diagrams/lab-01-systemd.drawio.png)