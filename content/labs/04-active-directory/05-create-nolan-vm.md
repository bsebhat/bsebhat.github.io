---
title: 05 Create nolan VM
type: docs
---

Install `nolan` VM with Kubuntu.

![](nolan-iso.png)
![](nolan-create-vm.png)
![](nolan-begin-install.png)
![](nolan-install-kubuntu.png)
![](noan-create-vmadmin-hostname.png)
![](nolan-create-user.png)
![](nolan-install-packages.png)
![](nolan-net-settings.png)

The `systemd-resolved` service should be stopped and disabled, and the `/etc/resolv.conf` file unlinked. Otherwise, it will be used for dns services. Re-create the `/etc/resolv.conf` file with the `nameserver` and `search` configured:
```
nameserver DOMAIN-CONTROLLER-IP
search REYNHOLM.local
```

