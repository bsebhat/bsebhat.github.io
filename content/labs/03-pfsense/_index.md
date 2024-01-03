---
title: Lab 03 - pfSense
type: docs
next: 01-add-hacker-vm
---

In a previous lab I create three VMs: `juiceshop`, `sysadmin`, and `customer`. The `juiceshop` VM is a Linux server running the vulnerable web application by OWASP called [Juice Shop](https://owasp.org/www-project-juice-shop/).

The `sysadmin` is a Linux workstation that manages the `juiceshop` server via SSH.

And the `customer` is a Linux workstation used by a customer of Juice Shop, using the Juice Shop web application running on the `juiceshop` VM.

The VMs all had virtual network interface cards (NICs) connected to the `default` virtual network. Here's a diagram of that setup at the end of the lab:
![diagram](../diagrams/lab-01-juice-shop.drawio.png)

In this lab, I'll start by adding a VM running [Kali Linux](https://www.kali.org/), a Linux distrobution that has a lot of penetration tools installed, to demonstrate how vulnerabilities in a server and web application can be exploited.

I'll also demonstrate how adding another layer of defense, a firewall server running [pfSense](https://www.pfsense.org/), between the users and the web application server `juiceshop` make it harder for the `hacker` VM to attack it.