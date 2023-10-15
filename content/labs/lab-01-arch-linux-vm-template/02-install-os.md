
---
title: 02 Install OS
type: docs
prev: 01 Create VM
next: 03 Install Programs
---

Now that the VM has been created, I'll install the Arch Linux OS on it. I usually use the `archinstall` program after I've created partitions, following (some of) the [Arch Linux Wiki's Installation guide](https://wiki.archlinux.org/title/installation_guide).

## Begin Installation
After I clicked the "Finish" button, the VM boots from the ISO image. If I'm going through the VM creation process, the virt-manager will not boot from the ISO when it reboots. Just the first time.

In the beginning, there's the Arch Linux installation menu.
![install-os-1](../install-os-1.png)


## Pre-Install Settings
Before I start, I like to increase the font size and check that the internet connection is working.

### Increase Console Font
To increase the font size, I use the `setfont` command to use a larger terminus font:
```
setfont ter-124b
```

If I'm installing on a laptop bare metal, I use the `iwctl` tool to connect to the Wifi. But with this VM connected to the internet through my host machine via NAT mode virtual interface device, I just check that the internet connection to archlinux.org is working:
```
ping -c 3 archlinux.org
```

## Create Boot and Root Partitions On Virtual Disk
I follow the [Arch Linux Wiki installation guide for partitioning the disk](https://wiki.archlinux.org/title/installation_guide#Partition_the_disks).
![install-os-3](../install-os-3.png)
I can use the `fdisk` program to create the partitions on the VM's disk. I use the `-l` option to see the device name for the VM's disk:
```
fdisk -l
```

It shows that the disk is `/dev/vda`, so I use `fdisk` to create the two partitions:
```
fdisk /dev/vda
```
Within the `fdisk` prompt, I create a 300 MB boot partition, and the root partition with the rest of the 30 GB disk.
![install-os-4](../install-os-4.png)

After that, I write my changes and go back to the command line. I'm not comfortable going through the whole Arch Linux installation process, so I run [archinstall](https://wiki.archlinux.org/title/archinstall) to use that command line tool to finish the installation process. I find it's a pretty neat "interactive" guided-installation command line tool for installing Arch Linux.

## Run archinstall
I run `archinstall` and I'm shown the menu with different installation settings.
![install-os-5](../install-os-5.png)

### Mirrors
For the mirror, I just select the United States.

### Disk Configuration
For disk configuration, I use its "best-effort" default option. I've just got the small boot partition and the rest is the primary partition, so it's pretty simple.

### Hostname
I set this to `template-archlinux`, like the VM. I try to keep the hostname and VM the same, except when they are joined to another domain in a Active Directory lab and they have a long fully qualified domain name (FQDN). Like `web-server.somebusiness.local`.

### Root Password
I don't usually set the root password, because I'll create an admin account with sudo privileges.

### User Account
I create a user account called `vmadmin` and make is a superuser (sudo) user. This gives it the highest privilege, because I'll probably use the VM as a server and I'll need to to make changes to the entire system.

### Profile
I usually create the template VM as a desktop with KDE, then remove it if I clone it to create a server. Or, just disable the SDDM service so it doesn't boot into a GUI login and go to KDE Plasma.

I choose KDE Plasma because it's easy for me to use. But they also have other popular window managers, like Gnome and Budgie.

### Network Configuration
I select the `NetworkManager` service, because it's easy to configure with a window manager like KDE. With server VMs, I like using the `systemd-networkd` service and manually editing configuration files for network settings like setting the static IP address and gateway. But if I need to do that, I'll just disable the `NetworkManager` service. But most of the time, I'll be using the VM as a desktop and using DHCP to get an IP address.

Later on, when I clone this template VM to create other VMs that require different gateway IP addresses or static IPs, I'll just change the clone VM.

### Timezone
I just set that to my timezone.

### Audio
For VMs, I skip the audio server installation.

## Install
![install-os-6](../install-os-6.png)
After I make my changes to those settings, I select the "Install" at the end. It shows the settings I configured, and I press ENTER to start the installation.

It goes through the installation process, formatting the drives, downloading the packages, etc.
![install-os-6](../install-os-6.png)

With a fast internet, it usually takes a few minutes to download and install all the packages. 
![install-os-7](../install-os-7.png)

## Post-Install Reboot, Start Arch Linux
![install-os-8](../install-os-8.png)
At the end, it asks if you want to go back. But I just say no and run `reboot`. Because this is the first installation boot, the reboot doesn't boot from the ISO/CDROM. So it doesn't need to be "ejected".

It starts the GRUB bootloader, then goes to the SDDM login screen.
![install-os-9](../install-os-9.png)
![install-os-10](../install-os-10.png)

## Create Snapshot
After I've started it for the first time, check a few programs, and ping google.com to see if everything's okay, I create an initial snapshop with a name like `installed-os`. Just in case I do something stupid later. Which I won't, but just in case.
![install-os-11](../install-os-11.png)