---
title: 01 Add hacker VM
type: docs
---

I'm going to create a new VM called `hacker`, running [Kali Linux](https://www.kali.org/). This will act as a malicious user who is trying to exploit vulnerabilities in the `juiceshop` VM.

Because `juiceshop` is communicating directly with users, and running the SSH service so that `sysadmin` can manage it, anyone can run scans on it and attempt to directly access it.

Using the `hacker` VM, you can run common recon tasks to gain information about the open services, and attempt to access them.

## Create hacker VM
I want to install the Kali Linux operating system on the `hacker` VM. I could just clone the `sysadmin` workstation, rename it, and install the penetration tools I'll use. But I think I'll use the Kali OS because it comes with commonly used tools, and I can use easily try them out in future labs.

### Download Kali Linux QEMU Image
The download page on the official website provides an ISO file that can be used to create a custom installation. But there's also an option of downloading [pre-built VM images](https://www.kali.org/get-kali/#kali-virtual-machines) for hypervisors like VMware, VirtualBox, and QEMU. 

I download the QEMU VM file. It's a 3 GB 7zip compression of a `.qcow2` file. I extract it to get the qcow2 file.

### Import Kali Linux qcow2 File
I create a VM called `hacker` using the `virt-manager` application, and in the first step I select "Import an existing disk image" as the method of OS installation.

I select the `.qcow2` file I extracted in the `~/Downloads` directory.

I give it 4 GB of RAM. It's a virtual disk file I'm importing, so I don't need to give it a hard disk. It's NIC is connected to the `default` virtual network.

I don't need to install an operating system with an `.iso` file. The disk image will have Kali Linux pre-installed, with many popular penetration testing tools.

I start the VM, and the pre-installed Kali Linux operating system starts. The login username and password are both `kali`.

## Access juiceshop From hacker
The `hacker` VM is connected to the same `default` virtual network as the other VMs, and gets leased an IP address from the DHCP service. I'm able to open a browser and connect to the `juiceshop` via `http://juiceshop`.

I'll be using the `hacker` VM to exploit vulnerabilities in the `juiceshop` server, and the `juice-shop` OWASP web application it's running. In the next step, I'll use the `hydra` login cracking tool pre-installed on Kali Linux to attempt to gain access to the SSH service running on `juiceshop`.

At this point, this is what the lab looks like with the new `hacker` VM added:
![diagram](../../diagrams/lab-03-ssh-brute-force.drawio.png)