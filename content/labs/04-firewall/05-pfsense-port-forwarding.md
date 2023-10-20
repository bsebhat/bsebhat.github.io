---
title: 05 pfsense Port Forwarding
prev: 04 Connect juiceshop to LAN
type: docs
---

I'll be using the webConfigurator web admin tool on the `pfsense` VM from the `sysadmin` VM. I'll use the `sysadmin` VM for managing server VMs like `pfsense` and `juiceshop`, because it's a desktop and it kind of represents how IT staff manage servers from their desktops.

## Port Forwarding to juiceshop
To allow users to access the `juiceshop` VM via the `pfsense` VM, I need to configure port forwarding. In this lab, I want HTTP traffic from `juicefan` to the WAN interface on the `pfsense` VM to get forwarded to the `juiceshop`. And it would need to be to the 3000 port on `juiceshop`, because that's the port that the Juice Shop web application is running on.

Using the webConfigurator tool, I can go to the Firewall / NAT / Port Forward settings page. I click the "Add" button, and create a "Redirect Entry" that forwards TCP communication to the WAN address HTTP port to the `juiceshop` IP address `192.168.1.21`, specifically its 3000 port.
![nat port forward](../nat-port-forward.png)

This creates a firewall rule for the WAN interface.
![firwall rule](../firewall-rule.png)

## Test Firewall
Now that port forwarding was setup, I use the `juicefan` VM to visit the `juiceshop` by 
![juicefan pfsense juiceshop](../juicefan-pfsense-juiceshop.png)

## Conclusion
I used this lab to move the `juiceshop` and `sysadmin` VMs to a new isolated virtual network, `LAN`. I added a new VM, `pfsense`, running a pfSense firewall server and acting as a gateway between the customers/users on the `default` network and the `juiceshop` VM on the `LAN` internal network.