---
title: 03 Setup NextCloud LDAP
type: docs
---

![](20231107133112.png)

create service user nextcloud_ldap
![](20231107133800.png)

make it member of Administrators
![](20231107133858.png)

TODO: modify SELinux to allow LDAP communication from NextCloud on intranet to acme-dc domain controller

go to nextcloud ldap settings
![](20231107134053.png)

use service user
![](20231108081313.png)

limit to user security groups
![](20231108081404.png)

use username and name attributes
![](20231108081447.png)

include groups
![](20231108081526.png)

users and groups added from domain
![](20231108081548.png)

login as mark from win-1
![](20231108081659.png)
![](20231108081842.png)
![](20231108081903.png)

login as sam from linux-2
![](20231108082130.png)
![](20231108082202.png)

private chat between sam and mark
![](20231108082552.png)
![](20231108082615.png)
![](20231108082724.png)
![](20231108082739.png)