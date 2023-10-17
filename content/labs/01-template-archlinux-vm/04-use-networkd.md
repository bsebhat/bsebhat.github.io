---
title: 04 Use networkd
type: docs
prev: 03 Post Install
next: 05 Test Clone
---

I'll use systemd-networkd to manage the network interface rather than NetworkManager. I could use NetworkManager without using the KDE Plasma window manager, just in console mode. But I like editing the Ethernet device configuration file rather than using the nmcli command line tool to change NetworkManager settings.

With servers, I'll usually set a static IP, rather than getting an IP via DHCP. So I'll add a bash alias short cut for editing that file. I'll add other bash aliases that are commonly used when managing servers.

## Use systemd-networkd instead of NetworkManager
I like using the `systemd-networkd` instead of NetworkManager if it's just console Linux. I can just edit a file, and I don't need to use the `NetworkManager` command line tool `nmcli`. It's not difficult to use, but it's just easier to edit a file.

**NOTE: This isn't necessary, I just like using it better than NetworkManager when I'm not using a windows manager.**

I've used the `Netplan` service on Ubuntu a few times, and that's also pretty cool with the YAML configuration. But I'll just choose `systemd-networkd` for this VM template.

The instructions I found on the blog [here](https://linux.fernandocejas.com/docs/how-to/switch-from-network-manager-to-systemd-networkd) were very helpful.

### Disable NetworkManager Service
First, I stop and disable the `NetworkManager` service:
```
sudo systemctl stop NetworkManager
sudo systemctl disable NetworkManager
```

### Enable systemd-networkd Service
Next, I enable to `systemd-networkd` service:
```
sudo systemctl enable systemd-networkd
```

## Create Network Connection Configuration File
I'm always using VMs with a virtual Ethernet network interface device. And it's either using DHCP or a static IP, and a gateway server, or DNS server. So I think it's easier to edit a file to change those configurations.

With the `systemd-networkd`, the network interface device's configuration should be set in the directory `/etc/systemd/network`, with the file name following the format `##-devicename.network`, with `devicename` being the network interface device name you would find in the `/dev` directory.

I can get the device name by running `ip a`. It's name is `enp1s0`.
![ethernet device](./ethernet-device.png)

So, I create a file called `/etc/systemd/network/00-enp1s0.network` and write this:
```
[Match]
Name=enp1s0

[Network]
#Address=192.168.122.20/24
#Gateway=192.168.122.1
DNS=192.168.122.1
DHCP=ipv4
```

This sets the `enp1s0` network interface to use DHCP to get an IPv4 address, and comments out the Address line with the value `192.18.122.20/24`, setting the gateway and DNS server values `192.168.122.1`. That IP is used by the default virtual network that I've connected this VM's network interface to.

If I connect it to a different virtual network, I'll edit this file to use the different network addresses.

If I stop using DHCP and give it a static IP, I can edit that `00-enp1s0.network` file to say this:
```
[Match]
Name=enp1s0

[Network]
Address=192.168.122.20/24
Gateway=192.168.122.1
DNS=192.168.122.1
#DHCP=no
```

That will configure the network interface to use the static IP address of `192.18.122.20/24`.

## Test Clone
I'll create a clone of the `template-archlinux-server` VM and call it `clone-server`.

I was able to ping `clone-server`'s DHCP IP from my host computer, since they were both connected to the default virtual network. When I edited the network interface configuration file to use the static IP address `192.168.122.99`, and restarted the `systemd-networkd` service, I was able to ping it at that new static IP address.

In the template VM, I added an alias to the `.bashrc` file that opens vim to edit the network interface configuration file:
```
alias edit_net="sudo vim /etc/systemd/network/00-enp1s0.network"
```