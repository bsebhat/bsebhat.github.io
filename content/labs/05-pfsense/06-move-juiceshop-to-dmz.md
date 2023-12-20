---
title: 06 Move juiceshop to DMZ
type: docs
---

At this point, the `pfsense` server is acting as a gateway between the `default` network and the isolated `LAN` network, and the `juiceshop` and `sysadmin` are on the same `LAN` network.

Right now, there's just two internal machines: `juiceshop` and `sysadmin`. But let's say we need to add an FTP file server or database server to the internal `LAN` that contains important employee data or juice recipes. 

If we want to quarantine the `juiceshop` web server used by the public from internal-only desktops and servers, we can add another isolated network for the `juiceshop` web server. This seperates it from other internal machines, with the `pfsense` firewall server acting as a gateway between the two networks. 

Here's what it looks like now:
![firewall](../../../labs/diagrams/firewall.drawio.png)

Here's what it will look like after I move `juiceshop` to the `DMZ`:
![firewall dmz](../../../labs/diagrams/firewall-dmz.drawio.png)


## Create DMZ Network
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
## Add DMZ Interface To pfsense
To allow access to this new isolated `DMZ` network, I'll have to add a new network interface to the `pfsense` server. This involves adding a virtual NIC device, and configuring the pfSense firewall server software to manage access to that interface.

### Add New DMZ Connected NIC to pfsense
I need to add another NIC to the `pfsense` VM. Just like I did with the `LAN` network interface when I installed the VM, I click the "Add Hardware" button on the VM details view. But this time, I'm selecting the `DMZ` isolated network.
![add dmz nic](../add-dmz-nic.png)

I then start the `pfsense` VM. The new NIC hardware is called `vtnet2`, but it needs to be configured with a label and IP address.

### Configure DMZ Interface in pfSense Firewall 
This will be like when I added the `LAN` interface as installation But since I have the `sysadmin` connected to the `LAN` network, I'll use the pfSense webConfigurator web interface admin tool to configure the `DMZ` interface instead of using the console.

I open the `sysadmin` VM, go to the `pfsense` gateway for the `LAN` network at `https://192.168.1.1`, and go to the Interfaces / Assignments page. 
![pfsense interface link](../pfsense-interface-link.png)

On the "Interface Assignments" page, I see the MAC address for the NIC I just added asn an available network port. I click the green "Add" button. 
![pfsense assign interface](../pfsense-assign-interface.png)

Now, the interface has been added, with the default "OPT1" name. I then click the "OPT1" link to configure the interface.
![pfsense assign interface added](../pfsense-assign-interface-added.png)

I change the name of the interface from "OPT1" to "DMZ", and enable it.
![pfsense name dmz interface](../pfsense-name-dmz-interface.png)

I also assign it the static IPv4 address `192.168.2.1/24`.
![pfsense dmz ip](../pfsense-dmz-ip.png)

Next, I need to configure the `juiceshop` network interface to use the `DMZ` network instead of the `LAN`.

## Move juiceshop to DMZ network
I'll move the `juiceshop` web server to the `DMZ` network by changing the network settings for its NIC. I'll do it by directly using the `juiceshop` VM, because can't SSH from the `sysadmin` while I change the network connection used by SSH.

I'll use the NetworkManager cli tool `nmcli` on `juiceshop` to change the static IP, gateway and and DNS settings for the "Wired Connection 1" connection:
```
nmcli connection modify "Wired connection 1" ipv4.address 192.168.2.21/24
nmcli connection modify "Wired connection 1" ipv4.gateway 192.168.2.1
nmcli connection modify "Wired connection 1" ipv4.dns 192.168.2.1
nmcli connection up "Wired connection 1"
```

Then, I'll restart the `NetworkManager` service:
```
sudo systemctl restart NetworkManager
```

## Test Ping to juiceshop from sysadmin
To test the move, I try pinging the `juiceshop` server's new IP address at 192.168.2.21 from the `sysadmin` machine, and I'm able to reach it.

However, I'm not able to ping the IP address of `sysadmin` from `juiceshop`. That's because the pfSense firewall software doesn't give the new "DMZ" interface the same default "Allow" firewall rules like it did with the "LAN" network.

Here are the default rules that the pfSense software gave the "LAN" interface, allowing anything from the "LAN" interface:
![lan rules](../lan-rules.png)

But those weren't added for this new "DMZ" interface:
![dmz no rules](../dmz-no-rules.png)

## Add DNS Mapping for juiceshop Static IP
I can't ping the `juiceshop` by its hostname from `sysadmin`:
![cant ping hostname](../cant-ping-hostname.png)

I also can't ping `juiceshop`'s hostname from `pfsense`, just its IP address:
![cant ping from pfsense](../cant-ping-from-pfsense.png)

But I can ping `sysadmin` from `pfsense` using its hostname. That's because `sysadmin` used the DHCP service provided by the pfSense firewall server, and I had configured the DNS Resolver service to register the machine hostnames when they use the DHCP service.
![register dns dhcp](../register-dns-dhcp.png)

Because `juiceshop` isn't using the DHCP service, its hostname needs to be manually entered in the DNS Resolver "Host Overrides" section if I want it to be mapped to its static IP:
![dns juiceshop](../dns-juiceshop.png)

Now, I'm able to ping `juiceshop` by its hostname:
![can ping juiceshop](../can-ping-juiceshop.png)

## Re-configure Port Forwarding To juiceshop
I need to change the port forwarding settings I had created that allows users to access the `pfsense` web application. Previously, a user on the `default` virtual network could access the `juiceshop` web server by making an HTTP request to the `pfsense` firewall server, and that would be redirected to the old IP address for `juiceshop`: `192.168.1.21`.

In the pfSense firewall admin tool webConfigurator, this port forwarding is referenced in 2 places: the port forwarding setting at `Firewall / NAT / Port Forward` and the firewall rule at `Firewall / Rules / WAN`. 

I can't modify the firewall rule, because it's associated with the NAT port forwarding. So, I modify the NAT port forwarding setting. I change the setting to use the new IP address for `juiceshop`, `192.168.2.21`:
![change port forwarding](../change-port-forwarding.png)

This automatically changes that WAN rule at `Firewall / Rules / WAN`. Now, the user on `juciefan` can keep accessing the `juiceshop` web server via the `pfsense` firewall.