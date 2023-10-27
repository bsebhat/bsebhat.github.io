---
title: 02 Create moss VM
type: docs
---

![](moss-iso.png)

![](moss-new-vm.png)

![](moss-start-install.png)

![](moss-fedora-welcome.png)

![](moss-install-summary.png)

![](moss-install-restart.png)

![](moss-first-fedora.png)

![](moss-add-vmadmin.png)

![](moss-dns-settings.png)

![](moss-nslookup.png)

![](moss-install-vim-updates.png)

![](moss-change-hostname.png)

![](moss-install-packages.png)

![](moss-resolve-service.png)

![](moss-edit-resolv-conf.png)
![](moss-realm-discover.png)
![](moss-realm-join.png)
![](moss-su-works.png)
![](moss-logout-vmadmin.png)
![](moss-login-domain.png)
![](moss-logged-in.png)
![](moss-user-login-option.png)
![](moss-login-password.png)

give IT-Staff sudo privilege to install packages and manage systemd services
/etc/sudoers.d/it_staff_sudo:
%it-staff@reynholm.local ALL=(ALL) NOPASSWD: /usr/bin/dnf install *
%it-staff@reynholm.local ALL=(ALL) NOPASSWD: /bin/systemctl *

/etc/sudoers.d/it_admin_sudo:
%it-admin@reynholm.local ALL=(ALL) ALL


