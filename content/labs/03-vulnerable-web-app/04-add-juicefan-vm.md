---
title: 04 Add juicefan VM
type: docs
prev: 03 Add sysadmin VM
---

## Create juicefan VM
To create the juicefan VM, I clone the `template-win11` VM I created. Then, I rename it to `juicefan`, and change its Preferred DNS to the default virtual network IP of `192.168.122.1`.
![juicefan win11](../juicefan-win11.png)

## Visit Juice Shop web application from juicefan
I was able to visit the Juice Shop web application from the Windows 11 `juicefan` VM. I created an account, and ordered some fruit juice.
![using juiceshop](../using-juiceshop.png)

The VMs are all connected to the same virtual network switch, so it's not like how different networks communicate on the internet. But it's just a small representation of a web application running on a server, being managed by an administrator on another machine, and being viewed by a customer's machine.

## Conclusion
Again, this isn't a very good representation of how users interact with web servers on the internet. I just wanted to start adding some VMs for future labs.

It's also a very insecure way of allowing users to access the Juice Shop web application. Any user can access the `juiceshop` web server, and it's running SSH so the `sysadmin` can manage it.

Here is a diagram I made using [draw.io](https://www.drawio.com/) showing how the VMs are currently setup:
![vulnerable web app](../../diagrams/vulnerable-web-app.drawio.png)

In the next lab, I'll add a firewall server VM called `pfsense` that should be a gateway between the `sysadmin` and `juiceshop` VMs and the users. This adds a layer of protection, and can be configured to restrict the types of network traffic that reaches the `juiceshop` VM.