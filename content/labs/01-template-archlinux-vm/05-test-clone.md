---
title: 05 Test Clone
type: docs
prev: 04 Use networkd
---

To test out the template, I'll clone it using the `virt-manager` program to create a new VM.
![Clone Template](../Screenshot_20231015_115814.png)

## Clone VM
The clone VM initially has the same hostname but a different IP address. The `template-archlinux` VM had the IP address `192.168.122.121`, but the new `archlinux-clone` VM has an IP address of `192.168.122.136`.

It has the same hostname because the clone is a copy of the template, but the network interface device has a new MAC address. The interface was configured to use a DHCP service provided by the default network to get an IP address. So `archlinux-clone`'s new MAC address will give it a new DHCP leased from the default virtual network. 
![Clone VM](../Screenshot_20231015_120125.png)

## Change Clone Hostname
To change the hostname to match the clone VM, I run this command:
```
sudo hostnamectl set-hostname archlinux-clone
```

If the original VM had a network interface configured with a static IP address, I would need to manually change it. 

## Conclusion
That's all I can think of for now. I'm going to use this as a "dynamic template", so if I think of other things I want to have when I clone this, I'll modify this `template-linux` VM. I'll also come back and update the packages. That way, I won't have to download and update new clone VMs in the future.