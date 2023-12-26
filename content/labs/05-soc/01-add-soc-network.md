---
title: 01 Add SOC Network
type: docs
---

I'm going to add a separate `SOC` network for the `splunk` and `soc-analyst` VMs.

It will be an isolated network, like the `DMZ`. But because there won't be any publicly accessible machines, I will add firewall rules allowing limited access to the rest of the network.

The `SOC` network will have the IP address `192.168.3.0/24`. And, like the `DMZ` and `LAN` networks, connected to the `pfsense` server. The `pfsense` server will need a new network interface, with an IP address of `192.168.3.1/24`, with DHCP Service enabled.

I will also allow the `SOC` network to access the `WAN` network (the `default` network in libvirt) and the `DMZ` network, but I won't give it access to the `LAN` networks.

I think that most SOC teams would have some restrictions on their access to a larger network, but they would need to be able to access the internet to do research on threats and the `DMZ` network to access the `juiceshop` web server.

I think that, if there were other servers in the `DMZ` network that the SOC wasn't monitoring, then the firewall rules would need to be restricted to the servers being monitored by the SOC.

## Create SOC Network
Similar to other virtual networks, I'll create the network definition using the `virsh` tool on my host machine.

I create the `SOC.xml` network definition:
```xml
 <network>
     <name>SOC</name>
     <ip address="192.168.3.0" netmask="255.255.255.0" />
 </network>
```

And I use that to define the network in libvirt, then start and autostart it:
```
sudo virsh net-define SOC.xml
sudo virsh net-start SOC
sudo virsh net-autostart SOC
```

These are all of the virtual networks now:
```
Name      State    Autostart   Persistent
--------------------------------------------
default   active   yes         yes
DMZ       active   yes         yes
LAN       active   yes         yes
SOC       active   yes         yes
```

## Add SOC-Connected NIC to pfsense
Similar to the NIC I added for the `DMZ` network, I'll add one for this new `SOC` network. And I give it the description "SOC", with the static IPv4 address `192.168.3.1/24`
![add soc to pfsense](../add-soc-to-pfsense.png)

### DHCP
I will enable DHCP server for the `SOC` interface, and have the DNS Resolver register DHCP leases. So when I add the `soc-analyst` desktop VM to the `SOC` network, it will get a DHCP leases IP address, and its domain name will be registered with the DNS Resolver. However, I will give the `splunk` server a static IP of `192.168.3.10`, and add ad its hostname mapping to the "Host Override" section of the DNS Resolver.

## Current Network Topology
Right now, we've just added an isolated network, and connected it to the `pfsense` server.

This is what it previously looked like:
![firewall dmz](../../../labs/diagrams/firewall-dmz.drawio.png)

And now, the `SOC` isolated network was added:
![firewall soc](../../../labs/diagrams/firewall-soc.drawio.png)

Next, I'll add the `soc-analyst` desktop and `splunk` server to this network.

