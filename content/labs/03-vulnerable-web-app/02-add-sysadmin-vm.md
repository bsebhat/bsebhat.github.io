---
title: 02 Add sysadmin VM
type: docs
prev: 01 Add juiceshop VM
next: 03 Make juiceshop a "Server"
---

I'm going to add another VM. This one will be an Arch Linux desktop called `sysadmin`. In this lab, I'm pretending there's a systems administrator that needs to manage the web application Juice Shop that's running on the `juiceshop` VM.


I will also enable the OpenSSH server on `juiceshop` so that the systems administrator on `sysadmin` can manage the web application.

## Clone sysadmin from template-archlinux
I'll clone the `template-archlinux` VM to create the `sysadmin` VM. 
![clone](../clone.png)

After starting `sysadmin` and logging in, I change the clone VM's hostname to "sysadmin":
```
sudo hostnamectl set-hostname sysadmin
```

## Check sysadmin can ping juiceshop
I run both `juiceshop` and `sysadmin` and confirm that they can ping each other. I can also view the web application in the `sysadmin` VM by requesting `http://juiceshop:3000`:
![sysadmin view juiceshop](../sysadmin-view-juiceshop.png)

## Enable juiceshop SSH server
I install the `openssh` package on the `juiceshop` and `sysadmin` VMs. To access the SSH server on `juiceshop`, I enable and start its systemd `sshd` service:
```
sudo systemctl enable --now sshd
```

I check the status, and it's running:
```
sudo systemctl status sshd
```

From the `sysadmin` VM, I can SSH in using the `vmadmin` user account by running:
```
ssh vmadmin@juiceshop
```
![ssh juiceshop](../ssh-juiceshop.png)

Now that I can use the console on `juiceshop` via SSH on `sysadmin`, I'm going to stop `juiceshop` from using the KDE Plasma windows manager and create a systemd service that runs the Juice Shop web app on startup. That way, I don't need to switch back and forth between VMs. And everything else I need to do on `juiceshop` can be handled with the command line. I'm going to change `juiceshop` from running more like a "desktop" into running like a "server": its main purpose is to provide the service of running the Juice Shop web application.