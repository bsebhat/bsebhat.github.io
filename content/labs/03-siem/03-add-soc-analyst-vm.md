---
title: 03 Add soc-analyst VM
type: docs
---

The `soc-analyst` is the first VM I add to the `SOC` network. It will lease an IP address for the pfSense firewall's DHCP service.

## Create soc-analyst VM
I will create the `soc-analyst` VM by cloning the `template-archlinux` VM again. And I'll modify its NIC to connect to the `SOC` network.

![add soc-analyst](../add-soc-analyst.png)

## Configure soc-analyst Network Interface
For the `soc-analyst` VM, I configure its network interface to use the `pfsense` SOC interface at `192.168.3.1/24` as its DNS server.

With the `pfsense` firewall rules, the `soc-analyst` can contact the `DMZ` and `WAN` networks, but not the `LAN`. I'm thinking that, following the "least privilege principle", the `soc-analyst` doesn't need to access machines in the `LAN`. For communication between the `soc-analyst` in the `LAN` network and the `sysadmin` in the `LAN` network, a ticketing or email system should be added.
