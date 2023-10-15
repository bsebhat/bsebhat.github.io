
---
title: 03 Post-Install Configuration
type: docs
prev: 02 Install Arch Linux
---

After the Arch Linux os has been installed, I'll add some commonly used programs and settings. So that when I clone it, I won't have to take a few minutes and install it on the clone VM.

## Install yay for installing AUR packages
`yay` is a great AUR helper I've been using. It's super easy to use, and allows you to search for packages.

### Download yay
I usually follow the installation guide I read on tecmit [here](https://www.tecmint.com/install-yay-aur-helper-in-arch-linux-and-manjaro/). I download `yay`'s PKGBUILD build script to the `/opt` directory with `git clone`. But I haven't installed the `git` aur package yet.

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

![post-install-configuration-01](../post-install-configuration-01.png)


### Shared Folder
Next, I want to share a folder on my host computer with the VM. With the `virt-manager` program I'm using, this requires enabling shared memory and adding adding a file system that's connected to a folder on my host computer.

#### Enable Shared Memory
In order to enable shared memory, I shutdown the VM, switch to the "Virtual Hardware Details" view, click on the "Memory", and check the "Enable shared memory" box.
![post-install-configuration-02](../post-install-configuration-02.png)

If I changed this while the VM was running, I would still need to shut the VM down for the changes to be applied.

#### Add New Filesystem Device To VM
Next, I click the "Add Hardware" button to add a filesystem. For the `Driver:`, I use `virtiofs`. The `Source path:` I select the folder on my host computer that I want to share. I've already created it in my home directory, called "Shared". I click the `Browse..` button and then the `Browse Local` button and select the folder. In the `Target path:` I enter a name for the filesystem that I'll use in the VM, "mount_shared".
![post-install-configuration-03](../post-install-configuration-03.png)

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
![post-install-configuration-04](../post-install-configuration-04.png)

## Install Web Browser
Next, I'll install the Google Chrome browser. I like using that to access web admin tools.
```
yay -S google-chrome
```

## Configure Window Manager
I also want to configure the desktop so that applications I use a lot are on the taskbar. Like the Konsole terminal application.

I also disable the screen locking and energy saving settings. That way, I can leave the VM on and come back to it after 10 minutes without having to unlock the screen.

## Install and Configure conky
I also want to make it easy to identify different VMs I use in a lab when I take screenshots. I install the X server diplay tool `conky` and configure it to display the VM's hostname and Ethernet network device's IP address on the desktop background.

The default configuration displays a ton of computer information, like the memory, CPU, and file system usage, and running processes:
![post-install-configuration-05](../post-install-configuration-05.png)

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
![post-install-configuration-06](../post-install-configuration-06.png)


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

## Conclusion
That's all I can think of for now. I'm going to use this as a "dynamic template", so if I think of other things I want to have when I clone this, I'll modify this `template-linux` VM. I'll also come back and update the packages. That way, I won't have to download and update new clone VMs in the future.