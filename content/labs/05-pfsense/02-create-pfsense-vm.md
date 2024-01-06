---
title: 02 Create pfSense VM
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

### WAN=vtnet0=default, LAN=vtnet1=LAN
When I'm configuring these interfaces in the pfSense software, I'll have the NIC connected to the `default` as the "WAN" interface, and the NIC connected to the `LAN` network is the "LAN" interface.

In the pfSense software, that first NIC is the `vtnet0` device, and the NIC I added for the `LAN` network is the `vtnet1` device. The MAC addresses match up.

#### WAN Interface 192.168.122.10
When I assign the interfaces, I set the `vtnet0` interface device be the "WAN", and the `vtnet1` interface be the "LAN". The "WAN" interface (connected to the `default` network) will be given the static IP address `192.168.122.10/24`. And its default gateway will be that `default` network gateway provided by `libvirt`: `192.168.122.1`. Whenever `pfsense` or VMs on the isolated networks that `pfsense` is the gateway for need to acces the internet, they will use this `default` network gateway.

#### LAN Interface 192.168.1.1
I don't need to set the IP address for the "LAN" interface. The `pfsense` firwall server assigned it the `192.168.1.1` address. This is a common IP address numbering convention for gateways to use the first available IP address. This will be the gateway for the VMs on the `LAN` network. When I defined the `LAN` virtual network, I gave it the IP address `192.168.1.0` with a netmask `255.255.255.0`. I'll use this `pfsense` VM as a gateway for the `LAN` network, so I'll assign it the static IP address `192.168.1.1` with a CIDR of 24. 

I also enable DHCP on `LAN`. It will have a DHCP range of `192.168.1.100` to `192.168.1.254`. When a VM gets leased an IP address from this DHCP service, it will be in that range.

## Map pfsense Hostname In default DNS
Because I'm giving the `pfsense` interface connected to the `default` virtual network the static IP address `192.168.122.20`, I should update the `default` network's definition with the `virsh net-edit` command:
```
virsh net-edit default
```

Because I will be moving the `juicero` off the `default` network, while I'm adding the new `pfsense` as a gateway, I'll remove this `<host>` entry for `juicero` and add a new `<host>` for `pfsense` and its IP address.

Which, as far as editing goes, just means I'm changing the existing entry to map the `pfsense` IP address `192.168.122.10` to be the hostname for the `pfsense` VM.

This change will require me to close the other VMs and close `virt-manager`, and destroy the `default` network:
```
virsh net-destroy default
```
And start it up again:
```
virsh net-start default
```

## Next, Move VMs to LAN
Next, I'll connect the `sysadmin` VM to the `LAN` network, configure it to use this `pfsense` server as a gateway and DNS server, and use the pfSense webConfigurator admin tool. I'll use that static IP address I gave the `pfsense` interface connected to the `LAN` network, `192.168.1.1`, as the gateway and DNS ip address when updating the `sysadmin` and `juicero` network settings.