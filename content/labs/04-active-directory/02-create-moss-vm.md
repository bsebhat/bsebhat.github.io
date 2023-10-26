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

give moss and the IT-Admin group sudo access
/etc/sudoers.d/moss_sudo:
moss@reynholm.local ALL=(ALL) ALL

/etc/sudoers.d/it_admin_sudo:
%it-admin@reynholm.local ALL=(ALL) ALL


