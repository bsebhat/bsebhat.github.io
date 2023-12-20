---
title: 05 Add customer VM
type: docs
---

Now that the `juiceshop` VM is acting as a web server, providing access to the Juice Shop web app, I'll create another CentOS workstation VM to represent a customer or user who uses the website to order juice products.

## Create customer VM
To create the customer VM, I clone the `sysadmin` VM I created. Then, I change the hostname to `customer`.

When I clone the `sysadmin` VM to create the `customer` VM, the files are all copied to a new virtual hard drive. Virtual devices, like the virtual NIC device, gets new randomly generated identification strings. The NIC gets a new MAC address, so when it requests an IP address from the same DHCP service as the `sysadmin` VM it was cloned from, it will be seen as a brand new NIC device and be leased a new IP address.

I'll use this to create an account called `customer1@example.com`, and order some apple juice.

