---
title: Lab 01 Template Arch Linux VM
type: docs
next: 01-create-vm
---

## Intro
I'm going to create a virtual machine (VM) of Arch Linux using QEMU. I'll use it as a "template" for other VMs in other labs. I'll install it with the settings and programs I want, then clone it to create other VMs later on.

## Why VM Templates?
I've been working on VM labs for a couple of months, and I find that sometimes I want to work on a concept or try something out on a machine. To get hands on experience with a cybersecurity technology of "best practice". But creating a VM will require installing an operating system, configuring it, and adding software and services. And that takes time.

I saw other people use [VM templates](https://www.nakivo.com/blog/vm-templates-a-to-z/). They create a VM, install an operating system on it, configuring it, add necessary tools and applications, and clone it to create new VMs whenever they work on a lab or try a new program. The VM manager they use (VMWare, Virtualbox, etc) can take  the VM and create a new one with a duplicate filesystem, duplicate static IP address, duplicate hostname.

There will be some differences in the virtual devices associated with the VMs. For example, the clone VM's new virtual network interface card (NIC) will have a different MAC address. This is good, because if I clone a template into two different clone VMs, and I connect them to the same network, this could potentially create a conflict. Because DHCP uses MAC addresses to determine which IP address to assign to a device.

## Why Arch Linux?
I like using Arch Linux. I also like Fedora and Ubuntu and Windows 11. But I've gotten comfortable using Arch, and it doesn't require too much memory, so I'll probably use it more often for VM labs. That's why it will be the first template.

## VM Templates: Static vs Dynamic
I could create a template Arch Linux template, call it something like template-archlinux-v1. And don't modify the settings or configuration, then clone it into template-archlinux-v2 if necessary later on.

I'm going to create an Arch Linux "dynamic" template. I'll create a template now, call it template-archlinux. Then, if I want to change it I'll just change it. If there's a major change I want to make, but I want to keep the other template version, I'll clone it into another template. Like maybe a server template and a desktop template.

So it will be a template VM, but in the broader sense. A dynamic VM template.

## VM Lab Environment
### Host Machine
I'm using the [virt-manager](https://virt-manager.org/) GUI for managing VMs. My host computer is Arch Linux, with the KDE Plasma windows manager. I also use the [libvirt](https://libvirt.org/) API to manage virtual networks.

### Virtual Networks
I'm going to mostly use the default virtual network for most of my VM labs. It has an IP address of `192.168.122.1`, and I modified it to have a DHCP range of `192.168.122.100` to `192.168.122.254`.

