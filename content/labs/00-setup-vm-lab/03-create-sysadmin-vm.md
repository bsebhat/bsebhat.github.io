---
title: 03 Create sysadmin VM
type: docs
---

## Create sysadmin VM
The first VM I create will be called `sysadmin`. It's the VM that I'll use as a "systems administrator". This will be a workstation with a GUI windows manager that I use to manage other servers via SSH. It will have the CentOS Linux operating system.

I download the CentOS Stream 9 ISO file from [https://centos.org/centos-stream/](https://centos.org/centos-stream/).

I click the "Create a new virtual machine" button, select "Local media", and select the CentOS ISO I downloaded. The operating system type should be automatically detected by virt-manager.

It then asks for "search permissions" for the iso file path. I click "Yes" to give it permission, because it's in my Download directory.

I give the VM 4096 megabytes of memory and 2 CPUs, and the default 20 gigabytes of disk image size.

I name it `sysadmin`. By default, it's given a virtual NIC device connected to the `default` virtual network. If I had another virtual network I wanted to use, I could change it now.

Or, if there were other VM configurations I wanted to make before installing the OS, I could check the "Customize configuration before install" box, and it would take me to the VM settings window before beginning OS installation. But I don't need that for this VM.

## Install CentOS Linux on sysadmin
I start the installation process, and select "Install CentOS". To make the screen stretch to the VM window size, I select `View>Scale Image>Always`.

Then it's a basic Linux installation process.

### Installation Destination
I just need to click this and click "Done" to use the 20 GB virtual disk I created for the VM.

### Software Selection
For the `Software Selection` I choose Workstation. It installs basic desktop software and the GNOME desktop environment. I don't need additional software, but there's options on the right.

### Network & Host Name
I give it the hostname `sysadmin`. The default NIC device added to the VM is given the name `enp1s0`, and its IPv4 method is "Automatic", so it gets an IP address from DHCP.

Because it's connected to the `default` virtual network, by default it requests an IP address and gets it from that virtual network's DHCP service at `192.168.122.1`. Because I modified the DHCP range, it should be between `192.168.122.100` and `192.168.122.254`. You can also click the "Configure" button and give it a static IPv4 address.

### Security Profile
Because some computers may be used in enterprises involving healthcare data, credit card data, or government work, there may be regulations regarding how secure the OS settings are configured. For these labs, I won't choose a security profile.

### Root Password
I set the root password, but don't allow root SSH login.

### User Creation
I create a user named `vmadmin`, and make it administrator.

### Begin Installation
After I've made my configurations, I begin installation. It takes my setup a little over 5 minutes.

After it's done, there's a blue "Reboot System" button. The `virt-manager` will automatically change the boot options for the VM, so it won't boot back into the installtion ISO like it's a "CD" in the "CDROM" that wasn't ejected.

### New CentOS Workstation
Now it's a VM with CentOS Stream 9 installed. The GNOME desktop is installed, with the GNOME display manager (GDM) providing a login screen on startup. There are a lot of commonly used applications installed, like terminal and Firefox browser, that can be accessed with the "Activities" button in the lop left.

You can open the terminal application and run `ip addr` to get the IP address for the virtual NIC device `enp1s0`.