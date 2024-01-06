---
title: 01 Install VM Software
type: docs
---

I'm going to first setup my VM infrastructure. Basically, the software I need to add to the existing KVM hypervisor that will help make managing VMs and labs easier.

My computer is a Dell XPS laptop, running Kubuntu 22.04.03 LTS with 32GB RAM and Intel i9-9980HK processor.

This is based on the Tecmint tutorial on [installing QEMU/KVM on Ubuntu](https://www.tecmint.com/install-qemu-kvm-ubuntu-create-virtual-machines/).

## Check If Virtualization Supported
Before installing the virtualiztion software, I'll check if my laptop's processor supports efficient KVM virtualization. Having KVM manage 

This command will check how many times the `vmx` (Intel VT-x) or `svm` (AMD-V) flags appear in the file `/proc/cpuinfo` files. More than 0 means the CPU supports KVM's virtualizations extensions, and you can efficiently run multiple VMs:
```
egrep -c '(vmx|svm)' /proc/cpuinfo
```

There's also a `cpu-checker` apt package that provides the `kvm-ok` command for checking for CPU features required to support KVM acceleration are enabled and accessible. It can be installed on Ubuntu with:
```
sudo apt install -y cpu-checker
```

The `cpu-checker` package includes a tool for easily determining if your processor supports KVM accelertion called `kvm-ok`:
```
kvm-ok
```

Running this program shows this output:
```
INFO: /dev/kvm exists
KVM acceleration can be used
```

NOTE: If other VM hypervisors, like VMWare workstation or VirtualBox, are installed they may already be taking advantage of virtualization on the system. `kvm-ok` can check for that.

## Install VM management packages
Next, install the following packages:
```
sudo apt install -y qemu-kvm virt-manager virtinst libvirt-clients bridge-utils libvirt-daemon-system
```

That command installs severa packages, incuding QEMU/KVM, the GUI desktop VM management app `virt-manager`, and the `libvirt` virtualization library and API, and the `libvirtd` system service. These will provide tools that make it easier to manager virtual machines, networks, and resources.

## Add User To kvm libvirt Groups
Check if your account is added to the `libvirt` and `kvm` groups:
```
groups $USER
```

Add your user to the kvm and libvirt groups if they aren't added:
```
sudo usermod -aG kvm $USER
```
```
sudo usermod -aG libvirt $USER
```

Check if the `libvirtd` service is running and enabled:
```
sudo systemctl status libvirtd
```

Run enable/run it if it isn't:
```
sudo systemctl enable --now libvirtd
```

## Default virtual network
Check if `default` virtual network is running
```
virsh net-list --all
```

It should show the `default` network as started.

Display the `default` virtual network definition:
```
virsh net-dumpxml default
```

Check if the host computer is connected to the virtual bridge `virbr0` used by the `default` network:
```
ip addr
```

This shows that the `virbr0` virtual bridge interface:
```
5: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:36:d3:73 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
```

This is used by the `default` virtual network, allowing VMs to communicate on the network, and provides services like DHCP and DNS to VMs connected the network.

So now there's a virtual network created, and my host laptop computer is connected to it with the ip address `192.168.122.1`. When I create VMs, I can connect them to this virtual network with virtual network interface cards (NICs). They can have their own IP addresses (between `192.168.122.2` and `192.168.122.254`), and I can simulate how computers are connected to switch network devices.

I'll be using the `default` virtual network for the labs. It will be like a wide area network (WAN), outside of the internal networks I have behind a firewall server VM.

## virt-manager 
I'll be using the [virt-manager](https://virt-manager.org/) graphical user interfce (GUI) tool to manage the VMs. If you just installed `libvirt`, you may get an error message saying "Unable to connect to libvirt qemu:///system." Try logging out of your desktop environment and logging back in.

If you didn't add your user to the `libvirt` group, you may need to enter your password to run it with sudo.

In the next step, I'll create the VMs and have them communicate with eachother over the `default` virtual network.