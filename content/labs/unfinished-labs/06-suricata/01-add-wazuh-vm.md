---
title: 01 Add wazuh VM
type: docs
---


![](20231109195733.png)
![](20231109195842.png)

set hostname to wazuh
```
sudo hostnamectl set-hostname wazuh.acme.local
```

set static IP 192.168.1.44, and gateway 192.168.1.1
```
sudo nmcli con modify 'enp1s0' ifname enp1s0 ipv4.method manual ipv4.addresses 192.168.1.44/24 gw4 192.168.1.1
sudo nmcli con up 'enp1s0'
```

add wazuh to acme.local domain
![](20231109201114.png)
![](20231109201224.png)

create new organization unit for servers
![](20231109201312.png)

move intranet and wazuh servers to Servers OU
![](20231109201401.png)

create new security group called wazuh-admin
![](20231109201915.png)

create new user called dan
![](20231109201826.png)

add dan to IT-Staff group
![](20231109202035.png)


add amy and dan to Wazuh-Admin group
![](20231109202115.png)


give Wazuh-Admin group full sudo privilege on wazuh server by adding this to new /etc/sudoers.d/wazuh_admin_sudo file:
```
%wazuh-admin@acme.local ALL=(ALL) ALL
```



