---
title: 01 Setup LAN Network
type: docs
---

## Create LAN Network in libvirt
Create isolated virtual network `LAN` using this in `LAN.xml`:
```xml
<network>
    <name>LAN</name>
    <ip address="192.168.1.0" netmask="255.255.255.0" />
</network>
```

Use the XML to define, start, and set autostart:
```
sudo virsh net-define LAN.xml
sudo virsh net-start LAN
sudo virsh net-autostart LAN
```

Now, I can see the `default` and `LAN` virtual networks when I run `sudo virsh net-list --all`:
```
Name      State    Autostart   Persistent
--------------------------------------------
default   active   yes         yes
LAN       active   yes         yes
```

And this is the LAN setting when I run `sudo virsh net-dumpxml LAN`:
```xml
<network>
  <name>LAN</name>
  <uuid>116cd191-8163-4b0c-99d6-5c24f8e80eeb</uuid>
  <bridge name='virbr1' stp='on' delay='0'/>
  <mac address='52:54:00:3c:af:93'/>
  <ip address='192.168.1.0' netmask='255.255.255.0'>
  </ip>
</network>
```

I'm going to use the firewall for DHCP and DNS services, and the firewall will use the domain controller for DNS.