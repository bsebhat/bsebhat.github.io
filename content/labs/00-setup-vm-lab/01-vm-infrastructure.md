---
title: 01 VM Infrastructure
type: docs
---

I'm going to first setup my VM infrastructure. Basically, the software I need to add to the existing KVM hypervisor that will help make managing VMs and labs easier.

This is based on the Tecmint tutorial on [installing QEMU/KVM on Ubuntu](https://www.tecmint.com/install-qemu-kvm-ubuntu-create-virtual-machines/).

## Check If Virtualization Supported
get cpu thread count (greater than zero)
```
egrep -c '(vmx|svm)' /proc/cpuinfo
```

Install the `cpu-checker` package:
```
sudo apt install cpu-checker -y
```

Run `kvm-ok` utility:
```
kvm-ok
```

## Install VM management packages
```
sudo apt install -y qemu-kvm virt-manager virtinst libvirt-clients bridge-utils libvirt-daemon-system
```

Add current user to kvm and libvirt groups:
```
sudo usermod -aG kvm $USER
```
```
sudo usermod -aG libvirt $USER
```

Check if libvirtd is running
```
sudo systemctl status libvirtd
```

Run enable/run if not:
```
sudo systemctl enable --now libvirtd
```

## Default virtual network
Check if `default` virtual network is running
```
sudo virsh net-list --all
```

Display the `default` virtual network definition:
```
sudo virsh net-dumpxml default
```

Check if the host computer is connected to the virtual bridge `virbr0` used by the `default` network:
```
ip addr
```

This shows a connection to the `virbr0` virtual bridge:
```
5: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:36:d3:73 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
```

So now there's a virtual network created, and my host laptop computer is connected to it with the ip address `192.168.122.1`. When I create VMs, I can connect them to this virtual network with virtual network interface cards (NICs). They can have their own IP addresses (between `192.168.122.2` and `192.168.122.254`), and I can simulate how computers are connected to switch network devices.

I'll be using the `default` virtual network for the labs. It will be like a wide area network (WAN), outside of the internal networks I have behind a firewall server VM.