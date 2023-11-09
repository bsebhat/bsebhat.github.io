---
title: 03 Setup NextCloud LDAP
type: docs
---

![](20231107133112.png)

create service user nextcloud_ldap
![](20231107133800.png)

make it member of Administrators
![](20231107133858.png)

go to nextcloud ldap settings
![](20231107134053.png)

SELinux blocks NextCloud (using the httpd service) from connecting to the domain controller at 192.168.1.21 via LDAP (port 389). The `/var/log/audit/audit.log` file will have lines like this:
```
ype=AVC msg=audit(1699500487.131:125): avc:  denied  { name_connect } for  pid=879 comm="php-fpm" dest=389 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:ldap_port_t:s0 tclass=tcp_socket permissive=0
```

You can also see the SELinux access control blocking it by going to the `intranet` admin console at `https://intranet.acme.local:9090/selinux`.
![](20231108195553.png)

One solution is to allow httpd to ldap connect:
```
setsebool -P httpd_can_connect_ldap 1
```


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

create new user called tom
![](20231108200442.png)

add tom to office-staff
![](20231108200605.png)

tom is included in NextCloud
![](20231108200624.png)

