---
title: Lab 03 - pfSense
type: docs
next: 01-add-hacker-vm
---

## Intro
In a previous lab I create three VMs: `juiceshop`, `sysadmin`, and `customer`. The `juiceshop` VM is a Linux server running the vulnerable web application by OWASP called [Juice Shop](https://owasp.org/www-project-juice-shop/).

The `sysadmin` is a Linux workstation that manages the `juiceshop` server via SSH.

And the `customer` is a Linux workstation used by a customer of Juice Shop, using the Juice Shop web application running on the `juiceshop` VM.

The VMs all had virtual network interface cards (NICs) connected to the `default` virtual network. Here's a diagram of that setup at the end of the lab:
![diagram](../diagrams/lab-01-systemd.drawio.png)

Then, I installed [the NGINX server to run as a reverse proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/) that takes HTTP traffic on port 80 and forwards it to the web application running on port 3000.

In this lab, I want to add a firewall server VM called `pfsense` that will be a gateway between the Juice Shop customer on `customer` and the VMs used to manage the Juice Shop web application: `sysadmin` and `juiceshop`.

I'll use the libvirt library to create an isolated virtual network called `LAN`. Here's what the lab will look like:
![firewall](../diagrams/firewall.drawio.png)

TODO: finish documentation
## Why install a firewall?

## VM Lab Environment