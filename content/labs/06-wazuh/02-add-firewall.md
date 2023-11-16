---
title: 02 Add Firewall
type: docs
---

similar to the lab 02 Firewall, I'll create a pfsense firewall VM
![](../20231114192106.png)

Adding NICs for LAN and SOC
![](../20231114192135.png)
![](../20231114192150.png)

start installation
![](../20231114192224.png)
![](../20231114192258.png)

choose default options
![](../20231114192334.png)

setup interfaces WAN, LAN, OPT1
![](../20231114192500.png)

WAN has DHCP IP 192.168.122.242/24
LAN has static IP 192.168.1.1/24 configured
![](../20231114192607.png)

Set OPT1 (later named SOC) IP to 192.168.2.1/24
![](../20231114192735.png)
![](../20231114192848.png)

Next, I'll add the Windows Server domain controller VM abc-dc, and create the abc.local domain

