---
title: 05 Connect juiceshop to LAN
type: docs
---

## Connect juiceshop NIC to LAN
I use the same method of changing the network source for the NIC on the `juiceshop` VM.

## Change juiceshop NetworkManager settings
The `juiceshop` VM  uses a static IP address, because it's a server and I want to use that IP in other VMs. So to allow communication between the `jucieshop` NIC and the other VMs on the `LAN` network, I need to change its static IP address from `192.168.122.21` to `192.168.1.21`. It could be anything between `192.168.1.2` dnd `192.168.1.254`, but I want the static IPs using the addresses not in the DHCP range, and to keep the 21 in the last octet.

I'll use the NetworkManager cli tool `nmcli` on `juiceshop` to change the static IP, gateway and and DNS settings for the "Wired Connection 1" connection:
```
nmcli connection modify enp1s0 ipv4.address 192.168.1.10/24
nmcli connection modify enp1s0 ipv4.gateway 192.168.1.1
nmcli connection modify enp1s0 ipv4.dns 192.168.1.1
nmcli connection up enp1s0
```

## Test Network Connection
I am able to ping the `juiceshop` from the `sysadmin` VM, and I can visit that Juice Shop web application running on it.


But I need to allow the customer on the `customer` VM to access the `juiceshop` VM. The `customer` isn't connected to the `LAN` isolated network I created. I only want the VMs running the Juice Shop web application on that internal network.

So I'll need to configure the `pfsense` firewall server to act like a gateway between the customer and the website, forwarding web requests from the "WAN" interface to the `customer` VM.