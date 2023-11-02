---
title: 08 Set Linux Sudo Permissions
type: docs
---


The user amy doesn't have sudo privilege on the bravo Linux machine

I want to give the acme.local domain group `IT-Admin` full sudo privileges, and `IT-Staff` limited sudo privileges.

I'll first login as a user with sudo privileges, vmadmin. Then, I'll create two files in the `/etc/sudoers.d` directory.

## IT-Admin sudo
First, I'll create a sudo file for `IT-Admin` sudo permission.

I log in as VMAdmin, and create a sudo file:
```
sudo vim /etc/sudoers.d/it_admin
```
I put this line in the file to give the `IT-Admin` group full sudo privilege. This will allow domain users in the `IT-Admin` group to execute anything requiring sudo:
```
%it-admin@acme.local ALL=(ALL) ALL
```

## IT-Staff sudo
I also create a file for the lower `IT-Staff` domain group, giving them limited sudo privilege to install packages and use the systemd tool systemctl:
```
sudo vim /etc/sudoers.d/it_staff
```

I add these two lines:
```
%it-staff@acme.local ALL=(ALL) /usr/bin/dnf install *
%it-staff@acme.local ALL=(ALL) /bin/systemctl *
```

To see the commands that users can execute, I can use the `sudo -l -U <username>` command.

The `acme.local` domain user `amy` belongs to the `IT-Admin`, `IT-Staff`, and `Employees` groups.
User `bob` belongs to `IT-Staff` and `Employees`.
And `dan` belongs to `Employees`.

When I run `sudo -l -U amy`, it says :
```
User amy@ACME.local may run the following commands on linux-1:
    (ALL) ALL
    (ALL) /usr/bin/dnf install *
    (ALL) /bin/systemctl *
```

For a user in the `IT-Staff` group but not the `IT-Admin`, like `sam`:
```
User sam@ACME.local may run the following commands on linux-1:
    (ALL) /usr/bin/dnf install *
    (ALL) /bin/systemctl *
```

And for `mark`, a user not in `IT-Admin` or `IT-Staff`:
```
User mark@ACME.local is not allowed to run sudo on linux-1.
```

This gives different levels of privilege on the `linux-1` Linux machine. If I find that `IT-Staff` needs to execute more sudo commands, I can edit the `/etc/sudoers.d/it_staff` file and add more commands.
