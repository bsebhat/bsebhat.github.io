---
title: 02 Edit default Network
type: docs
---

I've installed `libvirt` and it created a `default` virtual network. libvirt provides a command line tool called `virsh` that can manage virtual machines and virtual networks.

The `virsh net-edit` command can can a virtual network's "definition". This lets you change DHCP seettings. The "definition" is basically like the settings or configuration for the network. 

## View default Network Definition
To get the settings for the default virtual network, I can use the `virsh` command `virsh net-dumpxml`:
```
virsh net-dumpxml default
```

This outputs the settings in an XML format. This is what it may look like (the uuid and mac address will be randomly generated):
```xml
<network>
  <name>default</name>
  <uuid>8dc19f4a-87d8-45ea-b8cb-ceaeeb19dc61</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:36:d3:73'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

## Edit default Network Definition using virsh
I'm going to modify the `default` network DHCP range (inside the `<network><ip><dhcp>` tags), so that IP addresses leased to VMs will be seperate from the static IP addresses that I assign to server VMs. It's not necessary, but it helps make network management a little easier.

First, I'll add set the `EDITOR` to `vim` setting in `/etc/environment`:
```
EDITOR=vim
```

Edit `default` virtual network to change DHCP range to 192.168.122.100 to 192.168.122.254

```
virsh net-edit default
```

This will open the `default` virtual network's settings XML file in `vim`. I then edit the `<range>` tag to have the `start` attribute of `192.168.122.100` instead of `192.168.122.2`:
```xml
<network>
  <name>default</name>
  <uuid>8dc19f4a-87d8-45ea-b8cb-ceaeeb19dc61</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:36:d3:73'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.100' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

To have the `default` network use this new definition, I need to "net-destroy" it (basically stop it), then "net-start":
```
virsh net-destroy default
virsh net-start default
```
