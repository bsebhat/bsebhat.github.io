---
title: 02 Create Domain Controller
type: docs
---

I need to create an Active Directory domain controller for the `LAN` network. It will act as the DNS server for the "acme.LOCAL" local domain for the other devices I add to the virtual internal network, including the `ipfire` firewall server, and the Windows 11 desktop VMs (`win-1`, `win-2`) and Fedora Linux VMs (`linux-1`, `linux-2`).

I'll clone the `template-win2k22-server` VM I created by installing the Windows Server 2022 to create the `acme-dc` VM:
![](../20231101035949.png)


It's only NIC was connected to the `default` virtual network. But I change it to connect to the `LAN` network:
![](../20231101040246.png)

I rename the clone from the template's name to `acme-dc`, and restart.
![](../20231101040341.png)

I go to `Settings` and `Network & Internet`, and click the `Change adapter options` link:
![](../20231101041139.png)

 I right-lick the `Ethernet Instance 0` icon and select `Properties`:
 ![](../20231101041216.png)

 I select `Internet Protocol Version 4 (TCP/IPv4)` and click `Properties`:
 ![](../20231101041306.png)

I set it's NIC IPv4 settings to have a static IP `192.168.1.21`, netmask `255.255.255.0`, and default gateway `192.168.1.1`. I haven't installed the firewall yet, so that default gateway IP isn't working right now. But when I setup the firewall server after making this a domain controller, I'll set its `LAN` interface to have that IP address of `192.168.1.1` and use this 192.168.1.21 as its preferred DNS.

 ![](../20231101042342.png)

 I have the static IP `192.168.1.21`, and I can ping the firewall LAN interface at `192.168.1.1`
![](../20231101052900.png)

I then restart the server and start to install Active Directory.

## Install Active Directory
I click the `Manage` menu and select `Add Roles and Features`
![](../20231101053021.png)

I use this VM as the selected server.
![](../20231101053141.png)

I install Active Directory Domain Services
![](../20231101053200.png)

This will install the `Group Policy Management` feature, which I'll be using later to apply settings to computers and accounts using group policy objects (GPOs) with domain groups to to restrict the access of users based on their group memberships.
![](../20231101053327.png)

I start installing, and select the restart option to automatically restart the machine.
![](../20231101053422.png)

After installation succeeded, I close the window.
![](../20231101053611.png)

Now, I click the flag and select the "Promote this server to a domain controller" link.
![](../20231101053646.png)

I add a new forest named "ACME.local"
![](../20231101053708.png)

![](../20231101053807.png)

![](../20231101053828.png)

NetBIOS name assigned to the domain is "ACME"
![](../20231101053857.png)


Install Active Directory Domain Services
![](../20231101053948.png)

After installing, it restarts.
![](../20231101054209.png)

Now, the server is the domain controller, and it's running a DNS server.
![](../20231101054810.png)

I can configure the ipfire firewall's DHCP server to use this domain controller as its preferred DNS, rather than the `192.168.1.1` I used when I installed it.

Using its web gui at `https://192.168.1.1:444`, I sign in as admin
![](../20231101055037.png)
![](../20231101055056.png)

In its DHCP server settings, I change the DNS server it uses:
![](../20231101055145.png)

Now, when I add a machine to the `LAN` network and its NIC is configured to use DHCP, it will be leased an IP and its hostname-ip mapping will be registered with the `ipfire` DHCP service.