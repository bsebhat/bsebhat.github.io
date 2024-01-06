---
title: 07 Create DMZ Network
type: docs
---

At this point, the `pfsense` server is acting as a gateway between the `default` network and the isolated `LAN` network, and the `juiceshop` and `sysadmin` are on the same `LAN` network.

Right now, there's just two internal machines: `juiceshop` and `sysadmin`. But let's say we need to add an FTP file server or database server to the internal `LAN` that contains important employee data or juice recipes. 

If we want to quarantine the `juiceshop` web server used by the public from internal-only desktops and servers, we can add another isolated network for the `juiceshop` web server. This seperates it from other internal machines, with the `pfsense` firewall server acting as a gateway between the two networks. 


## Define DMZ Network
Like with the `LAN` network, I use the `virsh` command line tool to create an isolated virtual network. I'll call it `DMZ`, because that's a [common name](https://www.okta.com/identity-101/dmz/) for a network segment containing servers used by the internet.

I'll write the definition of the `DMZ` network in a `DMZ.xml` file:
```xml
<network>
    <name>DMZ</name>
    <ip address="192.168.2.0" netmask="255.255.255.0" />
</network>
```

This `DMZ` network will have the IP address `192.168.2.0`, while the `LAN` network has `192.168.1.0`.

Then, I'll create a new virtual network with that file, start it, and set it to autostart:
```
virsh net-define DMZ.xml
virsh net-start DMZ
virsh net-autostart DMZ
```

## Add DMZ Interface To pfsense
To allow access to this new isolated `DMZ` network, I'll have to add a new network interface to the `pfsense` server. This involves adding a virtual NIC device, and configuring the pfSense firewall server software to manage access to that interface.

### Add New DMZ Connected NIC to pfsense
I need to add another NIC to the `pfsense` VM. Just like I did with the `LAN` network interface when I installed the VM, I click the "Add Hardware" button on the VM details view. But this time, I'm selecting the `DMZ` isolated network.

I then start the `pfsense` VM. The new NIC hardware is called `vtnet2`, but it needs to be configured with a label and IP address.

### Configure DMZ Interface in pfSense Firewall 
This will be like when I added the `LAN` interface. That was configured using the `pfsense` console.

Now, I have the `sysadmin` connected to the `LAN` network, giving me access to the pfSense webConfigurator web admin tool. I'll use this to configure the `DMZ` interface instead of using the console. It's easier.

I open the `sysadmin` VM, go to the `pfsense` gateway for the `LAN` network at `https://192.168.1.1`, and go to the Interfaces / Assignments page. 

On the "Interface Assignments" page, I see the MAC address for the NIC I just added asn an available network port. I click the green "Add" button. 

Now, the interface has been added, with the default "OPT1" name. I then click the "OPT1" link to configure the interface.

I change the name of the interface from "OPT1" to "DMZ", and enable it.

I also assign it the static IPv4 address `192.168.2.1/24`.

Next, I need to configure the `juiceshop` network interface to use the `DMZ` network instead of the `LAN`.