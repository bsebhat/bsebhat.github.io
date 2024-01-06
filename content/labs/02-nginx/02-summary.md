---
title: 02 Summary
type: docs
---

The network topology hasn't changed much in this lab. I didn't add VMs or networks. I installed a reverse proxy on the `juicero` VM, so that users can access the Juice Shop web application via the HTTP port 80.

Here's a rough diagram of network traffic going from the `customer` VM to the `default` virtual bridge, to the `juicero` at port 80. Then, the `nginx` service on `juicero` sends that to the port 3000, which the Juice Shop web application is listening to.
![libvirt diagram](../../diagrams/lab-02-nginx.drawio.png)

This reverse proxy adds an additional layer of protection between the user on `juicero` and the web application running on `juicero`. In the next lab, I'll add a seperate VM and install the pfSense firewall on it. This software has a lot of service and features that allow you to manage network traffic between networks. I'll use the libvirt library to create another virtual network, and create another layer of protection between the `juicero` server and it's users.