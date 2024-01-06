---
title: 05 Add customer VM
type: docs
---

Now that the `juiceshop` VM is acting as a web server, providing access to the Juice Shop web app, I'll create another CentOS workstation VM to represent a customer or user who uses the website to order juice products.

## Create customer VM
To create the `customer` VM, I clone the `sysadmin` VM I created. Then, I change the hostname to `customer`.

When I clone the `sysadmin` VM to create the `customer` VM, the files are all copied to a new virtual hard drive. Virtual devices, like the virtual network interface card (NIC) device, gets new randomly generated identification strings.

So the new `customer` VM's NIC won't have the same MAC address as the `sysadmin` VM it was cloned from. So when the `customer` VM starts up, and it's connected to the same `default` virtual network as `sysadmin` that has a DHCP service leasing IP addresses, it will be seen as a brand new NIC device and be leased a new IP address from the DHCP range.

After starting up the `customer` VM, and opening a web browser, I clear all the history data. I don't want to use the saved history cloned from the `sysadmin` VM. Then, I go to `http://juiceshop:3000` and create a new account called `customer@example.com`, and order some apple juice.

I'll use this `customer` VM as a regular user, using Juice Shop to buy juice and juice-related products.
