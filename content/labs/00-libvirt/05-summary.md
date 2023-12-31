---
title: 05 Summary
type: docs
---

So now I've got KVM/QEMU and libvirt installed. And I've got a GUI desktop application to manager the VMs and virtual networks called virt-manager. I can also manage the VMs and virtual networks using the command line tool virsh.

Here's a rough diagram showing the current setup on my machine. I'm the stick figure using the virt-manager and virsh applications to manage the virtual machines and virtual network:
![libvirt diagram](../../diagrams/lab-00-libvirt.drawio.png)

In the next lab, I'll install the OWASP Juice Shop web application on the `juiceshop` VM, and create a systemd service to run it whenever I start the VM.