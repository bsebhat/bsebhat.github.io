---
title: 05 Create pfSense VM
type: docs
---

After I've added the `LAN` isolated virtual network, I'm going to create a new VM: `pfsense`

I'll need to give the `pfsense` VM two network interface cards (NICs): one connected to the `default` virtual network, and one connected to the isolated `LAN` network. Then, I'll setup the `pfsense` VM to act as a firewall gateway between the two virtual networks.

## Create VM
I download the ISO for the [pfSense 2.7.0 Community Edition](https://www.pfsense.org/download/).

I'll choose "FreeBSD 13.1" as the operating system, because it wasn't automatically detected.

I give it 4 GB memory, 2 CPUs, and 30 GB storage. I name it `pfsense`.

Before I begin installation, I want to add a second NIC for the `LAN` virtual network I created. So, I check the "Customize configuration" box and click "Finish". The next step will be the 

## Add NIC for LAN Network

I click on the "Add Hardware" button, and select "Network". Then, for "Network source", I select the `LAN` isolated network. I note that the MAC address for this NIC will be `52:54:00:90:1f:57`.

Now, I click "Begin Installation"

## pfSense Installation
I go through the pfSense installation choosing the default options.

## Configure Network Interfaces
I configured the `pfsense` VM with two NICs: one connected to the `LAN` network and one connected to the `default` network. The `default` network is in NAT mode giving access to the internet, and the `LAN` network is in isolated mode.

When I'm configuring these interfaces in the pfSense software, I'll have the NIC connected to the `default` as the "WAN" interface, and the NIC connected to the `LAN` network is the "LAN" interface.

In the pfSense software, that first NIC is the `vtnet0` device, and the NIC I added for the `LAN` network is the `vtnet1` device. The MAC addresses match up.

When I assign the interfaces, I set the `vtnet0` interface device be the "WAN", and the `vtnet1` interface be the "LAN". The "WAN" interface got the IP address `192.168.122.178/24` address from the `default` network DHCP. But I haven't set the IP address for the "LAN" interface.

When I defined the `LAN` virtual network, I gave it the IP address `192.168.1.0` with a netmask `255.255.255.0`. I'll use this `pfsense` VM as a gateway for the `LAN` network, so I'll assign it the static IP address `192.168.1.1` with a CIDR of 24. 

I also enable DHCP on `LAN`, with a range of `192.168.1.100` to `192.168.1.254`.

Next, I'll connect the `sysadmin` VM to the `LAN` network, configure it to use this `pfsense` server as a gateway and DNS server, and use the pfSense webConfigurator admin tool.