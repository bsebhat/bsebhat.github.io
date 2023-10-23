---
title: Create A Template Arch Linux VM
date: 2023-10-22T02:30:00
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

## Download Arch Linux ISO file
You can find the ISO file at [https://archlinux.org/download](https://archlinux.org/download). It's a little over 800 MB.
![Arch Linux Download](../arch-linux-screenshots/arch-linux-download.png)

## Create VM

### Choose the "Local install media" option
I'll be using the ISO image file.
![create-vm-1](../arch-linux-screenshots/create-vm-1.png)

### Choose the ISO file
Select the path the the downloaded ISO file. If the operating system can't be automatically detected, you will need to select the best available Linux distro type. But it should detect "Arch Linux".
![create-vm-2](../arch-linux-screenshots/create-vm-2.png)

### Choose Memory and CPU settings
I think 2048 MB is enough for running Linux with a KDE windows manager.
![create-vm-3](../arch-linux-screenshots/create-vm-3.png)

### Create A Disk Image
When creating a disk image for the VM, it gives you the option of setting the size in gigabytes. I usually choose about 20-30 GB, but most Linux distributions like Arch Linux take up less than 20 GB, even with the KDE Plasma windows manager and a lot of additional packages installed. The Windows 11 operating system requires more.
![create-vm-4](../arch-linux-screenshots/create-vm-4.png)

### Final Step Before Installation
This is final step before the VM is created and the OS installation begins.  Here, you can name the VM. It's not the same as the VM's computer or hostname. That still needs to be configured when installing the OS.
![create-vm-5](../arch-linux-screenshots/create-vm-5.png)

#### VM Naming
Because the VMs can be sorted by name, I like have the names begin with something similar. So the VMs I use as a template would be like `template-blahblah`. Because I may have other Linux distro templates, I'll have this one be `template-archlinux`. Then, if I do a Fedora Linux one, I'll call it `template-fedoralinux`. And if I clone the `template-archlinux` VM to make a NextCloud web server, I'll probably just call that VM clone `nextcloud`. This is just how I've been doing it, but I'm sure there's a better naming convention. I'll keep reading blog posts about VM lab best practices.

#### Customize Configuration Before OS Install
They also give you a "Customize configuration before install" option. If I want to add some other virtual devices before I install the OS, I'll check this. In case I'm creating a firewall server with multiple interfaces. You can also modify what virtual network the network interface is connected to. I'm fine with the `default` network. The internet connection is required to download packages.
After the Arch Linux os has been installed, I'll add some commonly used programs and settings. So that when I clone it, I won't have to take a few minutes and install it on the clone VM.

## Install Arch Linux
Now that the VM has been created, I'll install the Arch Linux OS on it. I usually use the `archinstall` program after I've created partitions, following (some of) the [Arch Linux Wiki's Installation guide](https://wiki.archlinux.org/title/installation_guide).

## Begin Installation
After I clicked the "Finish" button, the VM boots from the ISO image. If I'm going through the VM creation process, the virt-manager will not boot from the ISO when it reboots. Just the first time.

In the beginning, there's the Arch Linux installation menu.
![install-os-1](../arch-linux-screenshots/install-os-1.png)

## Create Boot and Root Partitions On Virtual Disk
I follow the [Arch Linux Wiki installation guide for partitioning the disk](https://wiki.archlinux.org/title/installation_guide#Partition_the_disks).
![install-os-3](../arch-linux-screenshots/install-os-3.png)
I can use the `fdisk` program to create the partitions on the VM's disk. I use the `-l` option to see the device name for the VM's disk:
```
fdisk -l
```

It shows that the disk is `/dev/vda`, so I use `fdisk` to create the two partitions:
```
fdisk /dev/vda
```
Within the `fdisk` prompt, I create a 300 MB boot partition, and the root partition with the rest of the 30 GB disk.
![install-os-4](../arch-linux-screenshots/install-os-4.png)

After that, I write my changes and go back to the command line. I'm not comfortable going through the whole Arch Linux installation process, so I run [archinstall](https://wiki.archlinux.org/title/archinstall) to use that command line tool to finish the installation process. I find it's a pretty neat "interactive" guided-installation command line tool for installing Arch Linux.

## Run archinstall
I run `archinstall` and I'm shown the menu with different installation settings.
![install-os-5](../arch-linux-screenshots/install-os-5.png)

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
![install-os-6](../arch-linux-screenshots/install-os-6.png)
After I make my changes to those settings, I select the "Install" at the end. It shows the settings I configured, and I press ENTER to start the installation.

It goes through the installation process, formatting the drives, downloading the packages, etc.
![install-os-6](../arch-linux-screenshots/install-os-6.png)

With a fast internet, it usually takes a few minutes to download and install all the packages. 
![install-os-7](../arch-linux-screenshots/install-os-7.png)

## Post-Install Reboot, Start Arch Linux
![install-os-8](../arch-linux-screenshots/install-os-8.png)
At the end, it asks if you want to go back. But I just say no and run `reboot`. Because this is the first installation boot, the reboot doesn't boot from the ISO/CDROM. So it doesn't need to be "ejected".

It starts the GRUB bootloader, then goes to the SDDM login screen.
![install-os-9](../arch-linux-screenshots/install-os-9.png)
![install-os-10](../arch-linux-screenshots/install-os-10.png)

## Create Snapshot
After I've started it for the first time, check a few programs, and ping google.com to see if everything's okay, I create an initial snapshop with a name like `installed-os`. Just in case I do something stupid later. Which I won't, but just in case.
![install-os-11](../arch-linux-screenshots/install-os-11.png)
## Post Install Configuration
After the Arch Linux os has been installed, I'll add some commonly used programs and settings. So that when I clone it, I won't have to take a few minutes and install it on the clone VM.
## Install yay for installing AUR packages
`yay` is a great AUR helper I've been using. It's super easy to use, and allows you to search for packages.

### Download yay
I usually follow the installation guide I read in a [tecmint blog post](https://www.tecmint.com/install-yay-aur-helper-in-arch-linux-and-manjaro/). I download `yay`'s PKGBUILD build script to the `/opt` directory with `git clone`. But I haven't installed the `git` aur package yet.

So, I first install the `git` aur package using the `pacman` package manager:
```
sudo pacman -S git
```

Then, I go to the `/opt` directory and clone the `yay` build script, and make my user account `vmadmin` the owner of the directory:
```
cd /opt
sudo git clone https://aur.archlinux.org/yay.git
sudo chown -R vmadmin:vmadmin ./yay
```

*BTW: I think I could just install it in my home directory. But it's kind of like a package manager that will install things system-wide, so I'll use the `/opt` directory. I might want to create different users for a VM, like when I'm joined to an Active Directory domain and have multiple domain users logging in and using the `yay` tool to install servers and services.*

Anyway, I go into the new `/opt/yay` directory and run `makepkg -si` to build the package. It's a `go` tool, so it installs that, and builds it, and about 10 seconds later it's done.

### Test yay
Now, I'll test it by installing the `nmap` aur package:
```
yay -S nmap
```
And it's able to install the package.

## Configure Sharing Between Host and Guest VM
There are two main things I will usually need to do with between my host machine (the laptop I'm using to run the VMs) and the guest machine (the VM): share the clipboard and access a shared folder.

The one I use the most is having a shared clipboard, so I'll do that first.

### Shared Clipboard
According the [Arch Linux Wiki on QEMU](https://wiki.archlinux.org/title/QEMU#Enabling_SPICE_support_on_the_guest), I need to install two aur packages: `spice-vdagent` and `xf86-video-qxl`. Also, from several forum posts, it sounds like this works best with the X11 server, not Wayland. You can choose between X11 and Wayland at the SDDM login screen.

#### Install Spice support package

I do that with `yay`:
```
yay -S spice-vdagent xf86-video-qxl
```

#### Test clipboard
The `spice-vdagent` packages creates a systemd service called `spice-vdagentd`. I reboot the VM, and check that the service is running:
```
sudo systemctl status spice-vdagentd
```

It's running. Next, I test that the VM shares the host machine's clipboard. On my laptop, I copy something. Then, I check the clipboard contents in the KDE taskbar. It's able to share the contents of my host computer's clipboard. 

![post-install-configuration-01](../arch-linux-screenshots/post-install-configuration-01.png)


### Shared Folder
Next, I want to share a folder on my host computer with the VM. With the `virt-manager` program I'm using, this requires enabling shared memory and adding adding a file system that's connected to a folder on my host computer.

#### Enable Shared Memory
In order to enable shared memory, I shutdown the VM, switch to the "Virtual Hardware Details" view, click on the "Memory", and check the "Enable shared memory" box.
![post-install-configuration-02](../arch-linux-screenshots/post-install-configuration-02.png)

If I changed this while the VM was running, I would still need to shut the VM down for the changes to be applied.

#### Add New Filesystem Device To VM
Next, I click the "Add Hardware" button to add a filesystem. For the `Driver:`, I select [virtiofs](https://libvirt.org/kbase/virtiofs.html). The `Source path:` I select the folder on my host computer that I want to share. I've already created it in my home directory, called "Shared". I click the `Browse..` button and then the `Browse Local` button and select the folder. In the `Target path:` I enter a name for the filesystem that I'll use in the VM, "mount_shared".
![post-install-configuration-03](../arch-linux-screenshots/post-install-configuration-03.png)

#### Mount Shared Folder In VM
After adding the new filesystem, I start the VM again. I need to mount the filesystem I added to the VM. But first, I create a directory under the `/mnt` directory that I will mount the new filesystem to:
```
sudo mkdir /mnt/shared
```

Then, I mount the filesystem for the host's shared folder to the VM's `/mnt/shared` directory:
```
sudo mount -t virtiofs mount_shared /mnt/shared
```

Now, if I list the VM's directory `/mnt/shared`, it should show the content of the host computer's shared directory.
![post-install-configuration-04](../arch-linux-screenshots/post-install-configuration-04.png)

## Install Web Browser
Next, I'll install the Google Chrome browser. I like using that to access web admin tools.
```
yay -S google-chrome
```

## Increase Console Font Size
If I want to disable SDDM and use the Arch Linux VM in console mode, the console font is too small. You can see this by using `Shift+F6` to leave the KDE windows manager and see the Linux console.

So, I install the `terminus-font` package and set the font size for the console to the larger `ter-122b` with the command `setfont ter-122b`. I can try other larger sizes, like `ter-124b`, but I like that one. You can list the other terminus fonts with `ls /usr/share/kbd/consolefonts/ter-*`.

To make that font the permenent console font, edit the `/etc/vconsole.conf` file and add a line saying `FONT=ter-122b`.

## Configure Window Manager
I also want to configure the desktop so that applications I use a lot are on the taskbar. Like the Konsole terminal application.

I also disable the screen locking and energy saving settings. That way, I can leave the VM on and come back to it after 10 minutes without having to unlock the screen.

## Install and Configure conky
I also want to make it easy to identify different VMs I use in a lab when I take screenshots. I install the X server diplay tool `conky` and configure it to display the VM's hostname and Ethernet network device's IP address on the desktop background.

The default configuration displays a ton of computer information, like the memory, CPU, and file system usage, and running processes:
![post-install-configuration-05](../arch-linux-screenshots/post-install-configuration-05.png)

I just want to display the hostname and IP address, so I create a `.conkyrc` file in my home directory with these settings:
```
conky.config = {
        update_interval = 1,
        font = 'DejaVu Sans Mono:size=24',
        own_window_hints = 'undecorated, skip_taskbar, skip_pager',
        own_window = true,
        alignment = 'top_left',
        use_xft = true,
        background = false
};

conky.text = [[
        ${color yellow}Hostname:$color ${exec hostnamectl hostname}  ${color yellow}IP Address:$color ${addr enp1s0}
]];
```
And change the background to plain black. This way, it's easier to see the hostname and IP address:
![post-install-configuration-06](../arch-linux-screenshots/post-install-configuration-06.png)

To change the background color, add `own_window_colour = 'xxxxxx'` to the `conky.config`, with `xxxxxx` being the hex color code. The desktop background color can be changed with the windows manager settings.


## Add Bash Alias File
I will be using the bash shell because...I'm just used to it. I want to add a separate bash alias file because I usually have commands that I keep running, and I might get tired of typing it.

First, I create a `.bash_alias` file where I'll keep my aliases. I'll start by creating a `ls` alias for listing details in order of modified:
```bash
alias ll='ls -alth'
```
Then, I'll add this to my home directory's `.bashrc` file to source that `.bash_alias` file:
```bash
if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi
```

Now, when I run `ll`, it's like running `ls -alth`. If I think of other aliases, I'll add them to the `.bash_alias` file. I'll also keep a copy of that alias file in the host computer's shared folder in case I want to use it in other Linux or UNIX VMs that use bash.

## Clear bash History
When I'm done working on a template VM, I like to clear the bash history with the commands `history -c && history -w`. Then, when I clone it and start working on the clone VM, if I look at the bash history I know it starts when it was created. But I don't think it's very necessary.


## Test Template By Clonging It
To test out the template, I'll clone it. I'm using the `virt-manager` program, so I'll right-click the `template-archlinux` VM and select "Clone". Then, I'll name it `archlinux-clone`. This will be the name of the VM, not the hostname. The hostname is set in the Arch Linux operating system, and will need to be changed after it's been created.
![Clone Template](../arch-linux-screenshots/Screenshot_20231015_115814.png)

## Clone VM
The clone VM initially has the same hostname but a different IP address. The `template-archlinux` VM had the IP address `192.168.122.121`, but the new `archlinux-clone` VM has an IP address of `192.168.122.136`.

It has the same hostname because the clone is a copy of the template, but the network interface device has a new MAC address. The interface was configured to use a DHCP service provided by the default network to get an IP address. So `archlinux-clone`'s new MAC address will give it a new DHCP leased from the default virtual network. 
![Clone VM](../arch-linux-screenshots/Screenshot_20231015_120125.png)

**NOTE: This is when using the `NetworkManager` service. The `systemd-networkd` seems to use the `/etc/machine-id` instead of the hardware MAC address. So, if the VM is cloned, that machine-id value will be copied like the other files in the filesystem.**

## Change Clone Hostname
To change the hostname to match the clone VM, I run this command:
```
sudo hostnamectl set-hostname archlinux-clone
```

Since this is a long command I will use for new clone VMs, I'll add it to the `.bash_aliases` file:
```
alias change_hostname="sudo hostnamectl set-hostname $1"
```

If the original VM had a network interface configured with a static IP address, I would need to change it using the `NetworkManager` service. 

## Conclusion
That's all I can think of for now. I'm going to use this as a "dynamic template", so if I think of other things I want to have when I clone this, I'll modify this `template-archlinux` VM. I'll also come back and update the packages. That way, I won't have to download and update new clone VMs in the future.