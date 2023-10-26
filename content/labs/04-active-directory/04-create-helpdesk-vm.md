---
title: 04 Create helpdesk VM
type: docs
---
![](helpdesk-install-iso.png)

![](helpdesk-create-vm.png)

![](helpdesk-install-fedora.png)

![](helpdesk-install-fedora-2.png)

![](helpdesk-install-fedora-3.png)
![](helpdesk-install-fedora-4.png)
![](helpdesk-install-net.png)
![](helpdesk-install-begin.png)
![](helpdesk-first-login.png)
![](helpdesk-increase-font.png)
![](helpdesk-check-dns.png)
![](helpdesk-join-realm.png)

Editing the `sssd.conf` file to add this:
```
default_domain_suffix = REYNHOLM.local
```

To give it-admin sudo access, create a sudoers file for the group at `/etc/sudoers.d/it_admin_sudo`:
```
%it-admin ALL=(ALL) NOPASSWD:ALL
```

Change permission for root:
```
sudo chown root:root /etc/sudoers.d/domain_group_sudo
sudo chmod 0440 /etc/sudoers.d/domain_group_sudo
```

Now, the only `reynholm.local` domain users in the `IT-Admin` domain group can  sudo on `helpdesk`.

Checking other domain users, including ones in the `IT-Staff` domain group like `jen` and `moss`, don't have sudo access. Just the ones in the `IT-Admin` group: `richmond`:
![](helpdesk-richmond-sudo.png)

