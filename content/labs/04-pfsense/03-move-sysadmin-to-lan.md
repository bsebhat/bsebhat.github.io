---
title: 03 Connect sysadmin to LAN
type: docs
---

## Connect sysadmin NIC to LAN
When I open the `sysadmin` VM in the `virt-manager` QEMU program, go to the virtual hardware details, and click the its NIC device, there's a drop down menu for its network source. It's been connected to the `default` virtual network in NAT mode.

 When I click it, there's the `LAN` isolated network I just created. So, I select it. Now, the `sysadmin` VM's only network interface device is connected to the isolated `LAN` network:

## Change sysadmin NetworkManager settings
After changing the `sysadmin`'s NIC to the `LAN` network, it got a new IP address from the `pfsense` DHCP service.

## pfSense webConfigurator
I open a browser and enter the IP address for the `pfsense` interface connected to the `LAN` network: `https://192.168.1.1`. First, it gives me a warning message because the certificate pfSense uses for this HTTPS server isn't valid. I just click "Advanced" and click "Proceed to 192.168.1.1 (unsafe)".

I login with the default admin/pfsense username password. I will need to change that password.

## Allow SSH Access To pfsense
If I want to manage the `pfsense` firewall server from its terminal instead of the web admin tool webConfigurator, I can go on its menu and select 14 to "Enable Secure Shell (sshd)".

Now, I can ssh into the `pfsense` VM using the root account:

## Register DHCP Leases With DNS Resolver
I'm using the pfSense firewall server for several services. It's providing DHCP services, DNS resolution, routing, and firewall. I want to automatically add a computer's hostname to the DNS Resolver service when they get an IP address from the DHCP service. This will let them sometimes communicate with each other using their hostnames, rather than just their IP addresses.

I go to the `Services / DNS Resolver / General Settings` page and select the "Register DHCP leases in the DNS Resolver" option:

For machines with static IP addresses, I'll need to add them to the "Host Overrides" section.

## Connect to Internet
After I restart the `pfsense` VM, I'm able to access the internet from the `sysadmin` VM. 

