---
title: 01 Create VM
type: docs
---

## Download Arch Linux ISO file
You can find the ISO file at [https://archlinux.org/download](https://archlinux.org/download). It's a little over 800 MB.
![Arch Linux Download](../arch-linux-download.png)

## Create VM

### Choose the "Local install media" option
I'll be using the ISO image file.
![create-vm-1](../create-vm-1.png)

### Choose the ISO file
Select the path the the downloaded ISO file. If the operating system can't be automatically detected, you will need to select the best available Linux distro type. But it should detect "Arch Linux".
![create-vm-2](../create-vm-2.png)

### Choose Memory and CPU settings
I think 2048 MB is enough for running Linux with a KDE windows manager.
![create-vm-3](../create-vm-3.png)

### Create A Disk Image
When creating a disk image for the VM, it gives you the option of setting the size in gigabytes. I usually choose about 20-30 GB, but most Linux distros take up less than 20 GB, even with the KDE Plasma windows manager. Windows 11 VMs require more.
![create-vm-4](../create-vm-4.png)

### Final Step Before Installation
This is final step before the VM is created and the OS installation begins.  Here, you can name the VM. It's not the same as the VM's computer or hostname. That still needs to be configured when installing the OS.
![create-vm-5](../create-vm-5.png)

#### VM Naming
Because the VMs can be sorted by name, I like have the names begin with something similar. So the VMs I use as a template would be like `template-blahblah`. Because I may have other Linux distro templates, I'll have this one be `template-archlinux`. Then, if I do a Fedora Linux one, I'll call it `template-fedoralinux`. And if I clone the `template-archlinux` VM to make a NextCloud web server, I'll probably just call that VM clone `nextcloud`. This is just how I've been doing it, but I'm sure there's a better naming convention. I'll keep reading blog posts about VM lab best practices.

#### Customize Configuration Before OS Install
They also give you a "Customize configuration before install" option. If I want to add some other virtual devices before I install the OS, I'll check this. In case I'm creating a firewall server with multiple interfaces. You can also modify what virtual network the network interface is connected to. I'm fine with the `default` network. The internet connection is required to download packages.