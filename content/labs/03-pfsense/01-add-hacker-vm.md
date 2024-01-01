---
title: 01 Add hacker VM
type: docs
---

I'm going to create a new VM called `hacker`, running [Kali Linux](https://www.kali.org/). This will act as a malicious user who is trying to exploit vulnerabilities in the `juiceshop` VM.

Because `juiceshop` is communicating directly with users, and running the SSH service so that `sysadmin` can manage it, anyone can run scans on it and attempt to directly access it.

Using the `hacker` VM, you can run common recon tasks to gain information about the open services, and attempt to access them.

## Create hacker VM
I want to install the Kali Linux operating system on the `hacker` VM. I could just clone the `sysadmin` workstation, rename it, and install the penetration tools I'll use. But I think I'll use the Kali OS because it comes with commonly used tools, and I can use easily try them out in future labs.

The download page on the official website provides an ISO file that can be used to create a custom installation. But there's also an option of downloading pre-built VM images for hypervisors like VMware, VirtualBox, and QEMU. 

I download the QEMU VM file. It's a 3 GB 7zip compression of a qcow2 file. I extract it, to get the qcow2 file.

I create a VM called `hacker` using the `virt-manager` application, and in the first step I select "Import an existing disk image" as the method of OS installation.

The username and password for the VM are both "kali".

The `hacker` VM is connected to the same `default` virtual network as the other VMs, and gets leased an IP address from the DHCP service. I'm able to open a browser and connect to the `juiceshop` via `http://juiceshop`.

## Use Hacker To Exploit juiceshop
The Kali Linux OS comes with many popular penetration applications. 

TODO: include attempts to exploit `juiceshop`
nmap scan, nikto web scanning of, and hydra ssh brute force attempts, and /var/log/secure evidence of brute force attack, etc.