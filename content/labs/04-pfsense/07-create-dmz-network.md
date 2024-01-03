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
sudo virsh net-define DMZ.xml
sudo virsh net-start DMZ
sudo virsh net-autostart DMZ
```