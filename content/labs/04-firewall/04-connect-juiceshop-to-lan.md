---
title: 04 Connect juiceshop to LAN
prev: 03 Connect sysadmin to LAN
next: 05 pfsense Port Forwarding
type: docs
---

## Connect juiceshop NIC to LAN
I use the same method of changing the network source for the NIC on the `juiceshop` VM.

## Change juiceshop NetworkManager settings
The `juiceshop` VM  uses a static IP address, because it's a server and I want to use that IP in other VMs. So to allow communication between the `jucieshop` NIC and the other VMs on the `LAN` network, I need to change its static IP address from `192.168.122.21` to `192.168.1.21`. It could be anything between `192.168.1.2` dnd `192.168.1.254`, but I want the static IPs using the addresses not in the DHCP range, and to keep the 21 in the last octet.

I'll also set its gateway and DNS to the `pfsense` LAN interface IP address `192.168.1.1`.
![juiceshop change ip](../juiceshop-change-ip.png)

## Test Network Connection
I am able to ping the `juiceshop` from the `sysadmin` VM, and I can visit that Juice Shop web application running on it.

![sysadmin connect juiceshop](../sysadmin-connect-juiceshop.png)

But I need to allow the customer on the `juicefan` VM to access the `juiceshop` VM. The `juicefan` isn't connected to the `LAN` isolated network I created. I only want the VMs running the Juice Shop web application on that internal network.

So I'll need to configure the `pfsense` firewall server to act like a gateway between the customer and the website, forwarding web requests from the "WAN" interface to the `juicefan` VM.