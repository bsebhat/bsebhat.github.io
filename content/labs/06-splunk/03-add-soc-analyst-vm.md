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

With the `pfsense` firewall rules, the `soc-analyst` can contact the `DMZ` and `WAN` networks, but not the `LAN`. And I add a rule that blocks them from accessing the firewall server, so they can't use the webConfigurator tool.

I'm thinking that, following the "least privilege principle", the `soc-analyst` doesn't need to access machines in the `LAN`, or modify the pfSense firewall. If changes need to be made, they can request the `sysadmin` to make them.

For communication between the `soc-analyst` in the `LAN` network and the `sysadmin` in the `LAN` network, a ticketing or email system should be added.

## Create soc-analyst Account On juiceshop
I want to allow the user on the `soc-analyst` desktop to investigate incidents, so I want them to have access to the `juiceshop` web server's `/opt/juice-shop` directory. I don't want to give them the password for the sudo user vmadmin, or the root account. So, from the `sysadmin` machine, I'll SSH into `juiceshop` and create a non-sudo user called "soc-analyst":
```
sudo useradd soc-analyst
```

I'll give it an initial password, but require that they change it next login:
```
sudo passwd soc-analyst
sudo chage -d 0 soc-analyst
```

I add it to the juiceshop group, so it can access the `/opt/juice-shop` directory to investigate incidents:
```
sudo groupadd juiceshop soc-analyst
```

## Current Network Topology
I've added the `soc-analyst` desktop to the `SOC` network. It has access to the `DMZ` and `WAN` networks, so it can access the web server to investigate security incidents, and the internet to do research. But it doesn't have access to the `LAN` network.

This is what it previously looked like:
![firewall soc](../../../labs/diagrams/firewall-soc.drawio.png)

And now, with the `soc-analyst` added:
![firewall soc-analyst](../../../labs/diagrams/firewall-soc-analyst.drawio.png)

Next, I'll add the `splunk` server.
