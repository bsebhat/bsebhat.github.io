---
title: 05 Adding SOC Accounts
type: docs
---

Previously, the SOC team recommended that low-privilege accounts be created for them, so they can access data on the `juiceshop` web server and `pfsense` servers while investigating security incidents.

## juiceshop Access
For the `juiceshop` server, a new low-privilege user called `soc-analyst` can be created. I can go on the `sysadmin` desktop and SSH into `juiceshop`.

Then, I can create a new `soc-analyst` user:
```
sudo useradd soc-analyst
```

And I give it a password:
```
sudo passwd soc-team
```

Since the NodeJS app is located at `/opt/juice-shop`, and it's owned by the user `juiceshop` and group `juiceshop`, you can add the `soc-analyst` user to the `juiceshop` group, then adjust the permission for the `/opt/juice-shop` so the group `juiceshop` only has read access. This lets the user `juiceshop` to keep having read and write access, but the group `juiceshop` (including this new `soc-analyst` user) only has read access.

Add `soc-analyst` to the group `juiceshop`:
```
sudo usermod -a -G juiceshop soc-analyst
```

And change the group `juiceshop` permission to read and execute: 
```
sudo chmod -R g+rx /opt/juice-shop
```

Now, I can go on the `soc-analyst` computer and SSH into `juiceshop` using the `soc-analyst` user:
```
ssh soc-analyst@juiceshop
```

I can view files in the `/opt/juice-shop`, and access the sqlite database at `/opt/juice-shop/data/juiceshop.sqlite`, but I can't write to the files or change the database. This read-only privilege can be useful when invesigating incidents.

## pfsense Access
I can use the pfsense web console webConfigurator to create a new group called `soc-team`, and add a new `soc-analyst` to it. I can then the minimal privileges necessary to monitor and investigate network traffic. This includes accessing the system and firewall status logs, performing packet capture, and managing the Suricata service.

To test this, I can go on the `soc-analyst` desktop and access the `pfsense` webConfigurator through the `SOC` interface IP address at `https://192.168.3.1`. The view is very limited, compared with the normal root user view. But I can still access the Suricata service and some status logs.
