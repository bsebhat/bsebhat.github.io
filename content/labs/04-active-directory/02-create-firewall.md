---
title: 02 Create Firewall
type: docs
---


## Create ipfire VM
I download the IPFire ISO on its download page [https://www.ipfire.org/download/ipfire-2.27-core180](https://www.ipfire.org/download/ipfire-2.27-core180).
![](../20231101043049.png)


I create a new `ipfire` VM with 4GB RAM, 2 CPUs, and 25 GB storage. I check customize configuration to add another NIC before installing.
![](20231101043124.png)
![](20231101043149.png)

It has two NICs:
One is connected to the `default` network, and has the MAC address `52:54:00:ad:f1:77`.
The other is connected to the `LAN` network, and has the MAC address `52:54:00:9f:ee:b5`.

The def

I begin the installation:
![](20231101043352.png)
![](20231101043419.png)

I go through the installation process, installing an ext4 filesystem for the Linux operating system. It needs to reboot, then I can setup the firewall.
![](20231101043603.png)

I name the hostname `ipfire`.
![](20231101043720.png)

I give it the `acme.local` domain name, but I'll need to setup the `acme-dc` as the domain controller for that after this firewall is setup.
![](20231101043749.png)

I give it a root password and admin password. The root account is used to log into the system, and the admin account is used in the GUI web admin tool.

Asks for root password and admin (web admin) passwords.

Using GREEN + RED configuration type:
![](20231101043942.png)

Next, go to `Drivers and card assignments`:
![](20231101044049.png)



Configure GREEN (LAN)
![](20231101044121.png)
![](20231101044151.png)


Configure RED (WAN)
![](20231101044206.png)
![](20231101044219.png)


Both set
![](20231101044240.png)


set addresses
![](20231101044256.png)


Configure GREEN
Warning:
![](20231101044314.png)

![](20231101044342.png)



Configure RED
![](20231101044356.png)
**TODO: Add screenshot connecting NIC to RED/WAN using DHCP **

Done
![](20231101044511.png)

DHCP Server, ranges, using 192.168.1.21 as primary DNS and 192.168.122.1 as secondary. Later, when I setup the Active Directory domain controller at 192.168.1.21, it will have a DNS server running.
![](20231102040347.png)

Now setup is complete, and it restarts.
![](20231101051948.png)

ip addresses, red and green
![](20231101052152.png)

Next, setup the domain controller. 

