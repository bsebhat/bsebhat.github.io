---
title: 01 Create LAN Network
type: docs
---

I'm going to create a an isolated network that the `juicero` and `sysadmin` VMs can use to communicate. The `customer` and `hacker` VMs won't have direct access to them, so they won't be able to access the web application running on `juicero` by putting `http://juicero` in their web browsers.

So I will need to also configure the pfSense firewall server to forward traffic to its "WAN" (the IP address of its NIC connected to the `default` network) to the `juicero`. This will be using the `pfsense` firewall software's network address translation (NAT) service.

I'll create the `pfsense` VM that runs the firewall, with 2 NICs: one connected to the `default` virtual network I've been using in the previous labs, and one connected to a new virtual network. I'll call that new network `LAN`. It's common practice to name it something like "vtnet1" or "vmnet2", but I'll just name it `LAN` so it's easier to tell what it is.

## Define LAN Network
I'm going to use the `libvirt` library to define and start a new virtual network called `LAN`. Unlike the `default` virtual network, which is in ["NAT" mode](https://libvirt.org/formatnetwork.html#nat-based-network), this will be in ["isolated" mode](https://libvirt.org/formatnetwork.html#isolated-network-config) network. The VMs will be able to communicate with each other on the `LAN`, but not outside the `LAN` network. Not without the new `pfsense` VM connected to the `LAN` network acting as a router/gateway. All traffic in and out of the `LAN` will be through the `pfsense` interface connected to it.

I'm going to use the [virsh](https://www.libvirt.org/manpages/virsh.html) tool to define and create the `LAN` virtual network using the libvirt library. The `virsh` interface tool can also be used to manage VMs too, but I've just been using the command line `virsh` for managing virtual networks, and the `virt-manager` GUI application for creating and managing the VMs.

Here are the steps I take took to create the `LAN` isolated virtual network:

#### Create LAN.xml file
I create a new XML file called `LAN.xml`, and add these lines:
```xml
 <network>
     <name>LAN</name>
     <ip address="192.168.1.0" netmask="255.255.255.0" />
 </network>
```

This doesn't define `LAN` as providing DNS or DHCP services, unlike the `default` network created by libvirt. If `default` acts like a switch/router, this `LAN` is more like a simple switch. VMs can communicate with each other on it.

You can see from the XML definition that I just gave it a name, IP address, and netmask. The IP address and netmask configure the network switch so that VMs using the IPv4 addresses ranging from `192.168.1.1` to `192.168.1.254` will be able to communicate with each other on this network. After I define it with the `virsh net-define` command, it will be given a randomly generated UUID and MAC address, and a new virtual bridge will be created.

I'll have the `pfsense` server connected to this `LAN` isolated network, providing the DHCP, DNS, and gateway services. It will manage what comes in and out of this isolated network. 

#### virsh net-define LAN.xml
I list of current virtual networks:
```
virsh net-list --all
```

The output:
```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```

Define a LAN network using the LAN.xml file:
```
virsh net-define LAN.xml
```

I list the virtual networks again with `virsh net-list --all`, and the output is:
```
 Name      State      Autostart   Persistent
----------------------------------------------
 default   active     yes         yes
 LAN       inactive   no          yes
```

#### virsh net-start LAN
I start the virtual network:
```
virsh net-start LAN
``` 

I list the virtual networks again, and the output is:
```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
 LAN       active   no          yes
```

#### virsh net-autostart LAN
I want the LAN to autostart, so I won't have to run the `virsh net-start` command again.

I run:
```
virsh net-autostart LAN
```

And then list the networks again, to get:
```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
 LAN       active   yes         yes
```

#### virsh net-dumpxml LAN
I can see the definition of the `LAN` virtual network, and see the other attributes it was given by libvirt:
```
virsh net-dumpxml LAN
```

Here is the output:
TODO: add the xml definition for LAN
```xml
<network connections='1'>
  <name>LAN</name>
  <uuid>dd319edd-ef03-4e6d-815e-d446ca42b79c</uuid>
  <bridge name='virbr1' stp='on' delay='0'/>
  <mac address='52:54:00:06:f2:8c'/>
  <ip address='192.168.1.0' netmask='255.255.255.0'>
  </ip>
</network>
```

Next, I'm going to add the `pfsense` VM to the lab, connect it to the `LAN` and `default` virtual networks, install the FreeBSD operating system and pfSense firewall software on it, and have it be a gateway/router between the VMs on the `LAN` network and the customer's `juicero` VM on the `default` network.

## Network Topology
This is what the network looked like before adding the `LAN` network:
![diagram](../../diagrams/lab-03-ssh-brute-force.drawio.png)

This is what the network topology will look like with the `LAN` network and the `sysadmin` and `juicero` VMs moved:
![diagram](../../diagrams/lab-05-pfsense-LAN.drawio.png)