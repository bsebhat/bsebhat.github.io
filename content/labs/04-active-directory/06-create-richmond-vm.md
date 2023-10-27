---
title: 06 Create richmond VM
type: docs
---

Create `richmond` VM with Fedora Linux (KDE).

![](richmond-vm-iso.png)
![](richmond-vm-create.png)

Going through the same process as `moss` VM.


give the IT-Staff limited sudo:

/etc/sudoers.d/it_staff_sudo:
%it-staff@reynholm.local ALL=(ALL) NOPASSWD: /usr/bin/dnf install *
%it-staff@reynholm.local ALL=(ALL) NOPASSWD: /bin/systemctl *


/etc/sudoers.d/it_admin_sudo:
%it-admin@reynholm.local ALL=(ALL) ALL







