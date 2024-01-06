---
title: 04 Summary
type: docs
---

So now I've got KVM/QEMU and libvirt installed. And I've got a GUI desktop application to manager the VMs and virtual networks called virt-manager. I can also manage the VMs and virtual networks using the command line tool virsh.

Here's a rough diagram showing the current setup on my machine. I'm the stick figure using the `virt-manager` and `virsh` applications to manage the virtual machines and virtual network via `libvirt`:
![libvirt diagram](../../diagrams/lab-00-setup.drawio.png)

In the [next lab](../../01-juice-shop), I'll install the [OWASP Juice Shop vulnerable web application](https://owasp.org/www-project-juice-shop/) on the `juiceshop` VM as a [systemd service](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html) so that it starts whenever I boot the `juiceshop` VM.