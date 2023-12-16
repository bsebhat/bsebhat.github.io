---
title: Lab 01 - juice-shop
type: docs
next: 01-use-badjuicer-to-exploit
---

## Intro
In this lab, I'm going to install the OWASP vulnerable web application Juice Shop on a [CentOS Linux](https://centos.org/) VM. I'll also use a CentOS workstation as a desktop computer for a systems administrator. I'll use that to manage the Juice Shop web application server. I'm going to configure the juiceshop VM to run like a server, so that the web application automatically runs when the server turns on.

I'll be using this VM in other cybersecurity labs.

## Why install this vulnerable web application?
I want to use this in later cybersecurity labs. There is [official documentation detailing the many built-in vulnerabilities](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html), giving instructions on how to exploit them with tools like Burp Suite. There's also this [YouTube playlist by Hacksplained](https://youtu.be/0YSNRz0NRt8?si=gwEorYl-xo6-CBe0) showing how to exploit the various built-in vulnerability "challenges".

## VM Lab Environment

### 1. juiceshop - CentOS server
The `juiceshop` VM will be running the vulnerable juice-shop web application..
- I'll use the server's SSH service to remotely manage it from the sysadmin VM.
- I'll install NodeJS, and install the juice-shop web application from its GitHub repository.
- I'l create a systemd service to run the juice-shop web application.

### 2. sysadmin - CentOS Linux workstation
The `sysadmin` VM will be a Linux desktop I use to manage the `juiceshop` web server via SSH. I'll be acting like the administrator, using their workstation to manage a server.

### 3. juicefan - CentOS Linux workstation
The `juicefan` VM will be another CentOS workstation that acts like a user/customer for the `juiceshop` web server VM. 


### Virtual Networks
I'm going to mostly use the libvirt default virtual network again. It has an IP address of `192.168.122.1`, with a DHCP range of `192.168.122.100` to `192.168.122.254`.

In this lab, I'll consider the default virtual network as a WAN network with various other devices connected and communicating. But I won't have other LAN networks connected to it like with the internet. It will just have VMs like workstations and servers. So that when a VM is connected to the default network, it's like being connected to the internet.

### Host Machine
I'm using the [virt-manager](https://virt-manager.org/) for managing VMs. My host computer is Arch Linux, with the KDE Plasma windows manager. I also use the [libvirt](https://libvirt.org/) API to manage virtual networks.