---
title: 06 Add linux-1 VM
type: docs
---

I'll clone the `template-fedora` VM with Fedora Linux installed, and create a new VM called `linux-1`:
![](../20231102124614.png)

I connect the NIC to the LAN network:
![](../20231102124712.png)

And start the VM.

change hostname to linux-1.acme.local
```
sudo hostnamectl set-hostname linux-1.acme.local
```


I also change the DNS server to use the domain controller at 192.168.1.21:
![](../20231102125012.png)



To prevent systemd-resolved from interfering, disable:
```
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo unlink /etc/resolv.conf
```

Create new /etc/resolv.conf
```
nameserver 192.168.1.21
search ACME.local
```
restart VM

install packages
```
sudo dnf install realmd sssd oddjob oddjob-mkhomedir adcli samba-common-tools -y
```

I use `realm discover` to see information about the domain:
```
sudo realm discover ACME.local -v
```
![](../20231102125550.png)


I join the realm ACME.local:
```
sudo realm join ACME.local -v
```

And I'm joined to the realm.
![](../20231102125657.png)

get user from passwd db
```
getent passwd amy@acme.local
```

And it prints information from the domain controller:
```
amy@ACME.local:*:513001108:513000513:Amy Adams:/home/amy@ACME.local:/bin/bash
```

I set the `default_domain_suffix` to be `ACME.local` in the `/etc/sssd/sssd.conf` file so I don't need to add `@ACME.local` at the end of usernames:
![](../20231102125942.png)

I then restart the `sssd` service:
```
sudo systemctl restart sssd
```

Now, I can get run `getent passwd` without `@acme.local`
```
getent passwd amy
```

I can login with this domain user.

Click "not listed", then login as amy@ACME.local (case sensitive). Now, I'm logged in as the domain user amy. 

The `linux-1` computer shows up in the "Computers" folder.
![](../20231102132038.png)

I move the `linux-1` computer into the IT-Department organization unit.
![](../20231102132153.png)

