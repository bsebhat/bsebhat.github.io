---
title: 02 Summary
type: docs
---

The network topology hasn't changed much in this lab. I didn't add VMs or networks. I installed a reverse proxy on the `juiceshop` VM, so that users can access the Juice Shop web application via the HTTP port 80.

Here's a rough diagram of network traffic going from the `customer` VM to the `default` virtual bridge, to the `juiceshop` at port 80. Then, the `nginx` service on `juiceshop` sends that to the port 3000, which the Juice Shop web application is listening to.
![libvirt diagram](../../diagrams/lab-02-nginx.drawio.png)

This reverse proxy adds an additional layer of protection between the user on `juiceshop` and the web application running on `juiceshop`. In the next lab, I'll add a seperate VM and install the pfSense firewall on it. This software has a lot of service and features that allow you to manage network traffic between networks. I'll use the libvirt library to create another virtual network, and create another layer of protection between the `juiceshop` server and it's users.