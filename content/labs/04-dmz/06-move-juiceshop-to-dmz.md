---
title: 06 Move juiceshop to DMZ
type: docs
---

## Add DMZ Interface To pfsense
To allow access to this new isolated `DMZ` network, I'll have to add a new network interface to the `pfsense` server. This involves adding a virtual NIC device, and configuring the pfSense firewall server software to manage access to that interface.

### Add New DMZ Connected NIC to pfsense
I need to add another NIC to the `pfsense` VM. Just like I did with the `LAN` network interface when I installed the VM, I click the "Add Hardware" button on the VM details view. But this time, I'm selecting the `DMZ` isolated network.

I then start the `pfsense` VM. The new NIC hardware is called `vtnet2`, but it needs to be configured with a label and IP address.

### Configure DMZ Interface in pfSense Firewall 
This will be like when I added the `LAN` interface as installation But since I have the `sysadmin` connected to the `LAN` network, I'll use the pfSense webConfigurator web interface admin tool to configure the `DMZ` interface instead of using the console.

I open the `sysadmin` VM, go to the `pfsense` gateway for the `LAN` network at `https://192.168.1.1`, and go to the Interfaces / Assignments page. 

On the "Interface Assignments" page, I see the MAC address for the NIC I just added asn an available network port. I click the green "Add" button. 

Now, the interface has been added, with the default "OPT1" name. I then click the "OPT1" link to configure the interface.

I change the name of the interface from "OPT1" to "DMZ", and enable it.

I also assign it the static IPv4 address `192.168.2.1/24`.

Next, I need to configure the `juiceshop` network interface to use the `DMZ` network instead of the `LAN`.

## Move juiceshop to DMZ network
I'll move the `juiceshop` web server to the `DMZ` network by changing the network settings for its NIC. I'll do it by directly using the `juiceshop` VM, because can't SSH from the `sysadmin` while I change the network connection used by SSH.

I'll use the NetworkManager cli tool `nmcli` on `juiceshop` to change the static IP, gateway and and DNS settings for the "Wired Connection 1" connection:
```
nmcli connection modify enp1s0 ipv4.address 192.168.2.10/24
nmcli connection modify enp1s0 ipv4.gateway 192.168.2.1
nmcli connection modify enp1s0 ipv4.dns 192.168.2.1
nmcli connection up enp1s0
```

Then, I'll restart the `NetworkManager` service:
```
sudo systemctl restart NetworkManager
```

## Test Ping to juiceshop from sysadmin
To test the move, I try pinging the `juiceshop` server's new IP address at 192.168.2.21 from the `sysadmin` machine, and I'm able to reach it.

However, I'm not able to ping the IP address of `sysadmin` from `juiceshop`. That's because the pfSense firewall software doesn't give the new "DMZ" interface the same default "Allow" firewall rules like it did with the "LAN" network.

Here are the default rules that the pfSense software gave the "LAN" interface, allowing anything from the "LAN" interface:

But those weren't added for this new "DMZ" interface:

## Add DNS Mapping for juiceshop Static IP
I can't ping the `juiceshop` by its hostname from `sysadmin`:

I also can't ping `juiceshop`'s hostname from `pfsense`, just its IP address:

But I can ping `sysadmin` from `pfsense` using its hostname. That's because `sysadmin` used the DHCP service provided by the pfSense firewall server, and I had configured the DNS Resolver service to register the machine hostnames when they use the DHCP service.

Because `juiceshop` isn't using the DHCP service, its hostname needs to be manually entered in the DNS Resolver "Host Overrides" section if I want it to be mapped to its static IP:

Now, I'm able to ping `juiceshop` by its hostname:

## Re-configure Port Forwarding To juiceshop
I need to change the port forwarding settings I had created that allows users to access the `pfsense` web application. Previously, a user on the `default` virtual network could access the `juiceshop` web server by making an HTTP request to the `pfsense` firewall server, and that would be redirected to the old IP address for `juiceshop`: `192.168.1.21`.

In the pfSense firewall admin tool webConfigurator, this port forwarding is referenced in 2 places: the port forwarding setting at `Firewall / NAT / Port Forward` and the firewall rule at `Firewall / Rules / WAN`. 

I can't modify the firewall rule, because it's associated with the NAT port forwarding. So, I modify the NAT port forwarding setting. I change the setting to use the new IP address for `juiceshop`, `192.168.2.21`:

This automatically changes that WAN rule at `Firewall / Rules / WAN`. Now, the user on `juciefan` can keep accessing the `juiceshop` web server via the `pfsense` firewall.