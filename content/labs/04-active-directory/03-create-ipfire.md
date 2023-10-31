---
title: 03 Create ipfire
type: docs
---


## Create ipfire VM
I download the IPFire ISO on its download page [https://www.ipfire.org/download/ipfire-2.27-core180](https://www.ipfire.org/download/ipfire-2.27-core180).

I create a new `ipfire` VM with 4GB RAM, 2 CPUs, and 25 GB storage. I check customize configuration to add another NIC before installing.

![](20231029133339.png)
![](20231029133403.png)
![](20231029133437.png)

WAN/RED = `52:54:00:c5:23:0c`
LAN/GREEN = `52:54:00:b2:a2:b5`


![](20231029133607.png)
![](20231029133636.png)
![](20231029133658.png)
![](20231029133708.png)
![](20231029133718.png)

Install complete, reset.
![](20231029133735.png)
![](20231029133808.png)
![](20231029133827.png)
Asks for root password and admin (web admin) passwords.

Using GREEN + RED
![](20231029133953.png)

Configure GREEN (LAN)
![](20231029134002.png)
![](20231029134031.png)

Configure RED (WAN)
![](20231029134051.png)
![](20231029134203.png)

Both set
![](20231029134302.png)

set addresses
![](20231029134314.png)

Configure GREEN
![](20231029134348.png)
![](20231029134403.png)
![](20231029134418.png)

Configure RED
![](20231029134435.png)
![](20231029134509.png)

Done
![](20231029134602.png)
![](20231029134613.png)

DHCP Server, ranges, using acme-dc IP as primary DNS
![](20231029134656.png)

![](20231029134749.png)

Starting firewall server
![](20231029134801.png)

login
![](20231029134830.png)

ip addresses, red and green
![](20231029134852.png)

LAN interface 192.168.1.1 can be pinged from acme-dc
![](20231029135013.png)





