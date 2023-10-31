---
title: 06 Add bravo VM
type: docs
---

![](20231029161709.png)

change hostname to bravo.acme.local
```
sudo hostnamectl set-hostname bravo.acme.local
```

Change DNS
![](20231029162019.png)




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

```
sudo realm discover ACME.local -v
```
![](20231029162648.png)

```
sudo realm join ACME.local -v
```

![](20231029162932.png)
![](20231029163204.png)

get user from passwd db
```
getent passwd bob@acme.local
```

enable default suffix
![](20231029163501.png)

get user from passwd db without `@acme.local`
```
getent passwd bob
```

Click "not listed"
![](20231029163957.png)

login as amy@ACME.local (case sensitive)
![](20231030040002.png)



