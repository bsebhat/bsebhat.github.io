---
title: 06 Add wuzah
type: docs
---

I'm going to add an Ubuntu Server to the SOC network, and install Wazuh on it.

I'll create the wuzah VM and install Ubuntu Server
![](20231115031117.png)

![](20231115042700.png)

![](20231115042816.png)
![](20231115042830.png)


Follow the same steps to join this wuzah VM (Ubuntu Server) as with the previous soc-analyst

Except 
On the wazuh VM, give full sudo privileges to the domain group SOC-Admin by creating the sudo file /etc/sudoers.d/soc_admin_sudo:
```
%soc-admin@abc.local ALL=(ALL) ALL
```

Add wazuh static IP 192.168.2.10 to domain controller's DNS Server
![](20231115130422.png)
![](20231115130502.png)



Install wuzah using the "all-in-one" guide https://documentation.wazuh.com/current/quickstart.html

Log into the linux-1 VM as adam, and SSH into wazuh as adam
![](20231115131226.png)

download the installation shell and run it
![](20231115131628.png)

visit https://wazuh.abc.local:443
![](20231115133108.png)
![](20231115133143.png)
![](20231115133234.png)

Install Windows agent on domain controller abc-dc
![](20231115133459.png)
![](20231115133552.png)
![](20231115133721.png)

Windows events from domain controller abc-dc
![](20231115134012.png)
