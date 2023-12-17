---
title: 01 VM Infrastructure
type: docs
---

I'm going to first setup my VM infrastructure. Basically, the software I need to add to the existing KVM hypervisor that will help make managing VMs and labs easier.

Rough Notes
yay -S qemu-full libvirt virt-manager dnsmasq
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER

sudo systemctl enable --now dnsmasq
sudo systemctl enable --now libvirtd

sudo virsh net-list --all
sudo virsh net-dumpxml default
sudo vim /etc/environment  to set EDITOR=vim

sudo virsh net-edit default to change DHCP range
sudo virsh net-start default
sudo virsh net-autostart default

open virt-manager, create VM

test ping
add dns host record for server static ip to default virtual network settings