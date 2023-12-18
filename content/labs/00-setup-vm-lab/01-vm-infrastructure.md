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

Check if libvirtd and dnsmasq is running
```
sudo systemctl status libvirtd
sudo systemctl status dnsmasq
```

Run enable/run if not:
```
sudo systemctl enable --now dnsmasq
sudo systemctl enable --now libvirtd
```

## Default virtual network
Check if `default` virtual network is running
```
sudo virsh net-list --all
```

I'm going to modify the `default` network DHCP range, so that IP addresses leased to VMs will be seperate from the IP addresses I give to static server VMs. It's not necessary, but it helps make network management a little easier.

Add EDITOR setting in `/etc/environment`:
```
EDITOR=vim
```

Edit `default` virtual network to change DHCP range to 192.168.122.100 to 192.168.122.254

```
sudo virsh net-edit default
```

Restart `default` network:
```
sudo virsh net-start default
sudo virsh net-autostart default
```