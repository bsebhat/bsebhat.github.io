---
title: Lab 01 - Web Server
type: docs
---

## Intro
In this lab, I'm going to install the OWASP vulnerable web application Juice Shop on an Arch Linux VM. I'm going to configure the VM to run like a server, so that the web application runs when I turn on the VM.

I'll be using this VM in other cybersecurity labs.

## Why install this vulnerable web application?
I want to use this in later cybersecurity labs. There is [official documentation detailing the many built-in vulnerabilities](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html), giving instructions on how to exploit them with tools like Burp Suite. There's also this [YouTube playlist by Hacksplained](https://youtu.be/0YSNRz0NRt8?si=gwEorYl-xo6-CBe0) showing how to exploit it using Kali Linux.

## VM Lab Environment

### 1. juiceshop - Arch Linux desktop
The `juiceshop` VM will be running the vulnerable juice-shop web application. I'll create it by cloning the `template-archlinux` VM I created. Because it's just running a web server, I won't need to run the KDE Plasma windows manager.
- I'll disable SDDM, so it starts in command line mode.
- I'll setup OpenSSH server so that it can be managed by other VMs.
- I'll install NodeJS, and install the juice-shop web application from its GitHub repository.
- I'l create a systemd service to run the juice-shop web application, and modify the web application configuration to run on port 80 (HTTP).

### 2. sysadmin - Arch Linux desktop
The `sysadmin` VM will be a Linux desktop I use to manage the `juiceshop` web server via SSH. I'll be acting like the administrator, using their personal computer to manage the web server.

### 3. juicefan - Windows 11 desktop
The `juicefan` VM will be a Windows desktop that acts like a user/customer for the `juiceshop` web server VM. 


### Virtual Networks
I'm going to mostly use the libvirt default virtual network again. It has an IP address of `192.168.122.1`, with a DHCP range of `192.168.122.100` to `192.168.122.254`.

In this lab, I'll pretend like the default virtual network is like the internet, connecting the machines that would be in different parts of the world on different networks. I think this is an inaccurate representation of users and web servers. For now, I'm not going to add the complexity of separate networks and routers. 

### Host Machine
I'm using the [virt-manager](https://virt-manager.org/) for managing VMs. My host computer is Arch Linux, with the KDE Plasma windows manager. I also use the [libvirt](https://libvirt.org/) API to manage virtual networks.