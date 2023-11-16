---
title: 01 Add intranet VM
type: docs
---

create intranet VM by cloning template of Fedora Linux Server
![](../20231107083448.png)

connect to LAN network
![](../20231107083526.png)


change hostname to intranet

set static IP 192.168.1.31, and gateway 192.168.1.1
```
sudo nmcli con modify 'enp1s0' ifname enp1s0 ipv4.method manual ipv4.addresses 192.168.1.31/24 gw4 192.168.1.1
sudo nmcli con up 'enp1s0'
```
![](../20231107083739.png)


Stop and disable systemd-resolved
```
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
```

unlink /etc/resolv.conf
```
sudo unlink /etc/resolv.conf
```

write /etc/resolv.conf with domain controller
```
nameserver 192.168.1.21
search acme.local
```

discover domain
```
sudo realm discover -v ACME.local
```
![](../20231107083925.png)


join acme.local domain:
```
sudo realm join -v ACME.local
```

The intranet server appears in domain computers
![](../20231107084018.png)

From the intranet vm, I can id domain user sam:
```
id sam@acme.local
```

enable default domain suffix 'ACME.local'
edit /etc/sssd/sssd.conf, add line:
```
default_domain_suffix = 'ACME.local'
```

restart sssd service:
```
sudo systemctl restart sssd
```

test user id
```
id sam
```

give the acme.local security group it-admin sudo access on the intranet server
create the it_admin_sudo file in /etc/sudoers.d/ with the line:
```
%it-admin@acme.local ALL=(ALL) ALL
```

from linux-1, login as amy, open a terminal, and ssh as amy into the new intranet server:
![](../20231107084449.png)

you can also use the web admin console at https
![](../20231107084627.png)
![](../20231107084639.png)

because the user amy it in the it-admin group, you can unlock administrative access
![](../20231107084729.png)
![](../20231107084924.png)

Add the HTTP port 80 to the public zone in the firewall
![](../20231107085735.png)


Next, I'll install the NextCloud prerequisites Apache web server, mariadb, and PHP (LAMP stack)

