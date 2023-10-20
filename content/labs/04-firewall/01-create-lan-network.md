---
title: 01 Create LAN Network
prev: 04-firewall
next: 02 Create pfSense VM
type: docs
---
**TODO: finish documentation, describe libvirt and networks**

I'm going to create a an isolated network that the `juiceshop` and `sysadmin` VMs can use to communicate. The customer's machine, `juicefan`, won't have access to it. And the `juiceshop` and `sysadmin` won't be connected to the default virtual network either.

Here's a diagram of the `LAN` network and the VMs:
![firewall](../../diagrams/firewall.drawio.png)

I'll create the `pfsense` VM that runs the firewall and connect the three non-customer VMs to the `LAN` network, but first I want to create that `LAN` internal network.

## Define LAN Network
This will require adding a virtual switch in isolated mode. I'm going to use the [virsh](https://www.libvirt.org/manpages/virsh.html) tool to define and create the `LAN` virtual network using the libvirt library. The `virsh` interface tool can also be used to manage VMs and QEMU hypervisor, but I've just been using the `virt-manager` UI tools for creating and managing the VMs. 

Here are the steps I take took to create the `LAN` network:

#### Create LAN.xml file
I create a file called `LAN.xml` in a in my home directory and add this:
```xml
 <network>
     <name>LAN</name>
     <ip address="192.168.1.0" netmask="255.255.255.0" />
 </network>
```

#### virsh net-define LAN.xml
I list of current virtual networks:
```
sudo virsh net-list --all
```

The output:
```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```

Define a LAN network using the LAN.xml file:
```
sudo virsh net-define LAN.xml
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
sudo virsh net-start LAN
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
sudo virsh net-autostart LAN
```

And then list the networks again, to get:
```
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
 LAN       active   yes         yes
```

Next, I'm going to add the `pfsense` VM to the lab, connect it to the `LAN` and `default` virtual networks, install the FreeBSD operating system and pfSense firewall software on it, and have it be a gateway/router between the VMs on the `LAN` network and the customer's `juiceshop` VM on the `default` network.
