---
title: 02 Install LAMP
type: docs
---

using guide from https://www.atlantic.net/dedicated-server-hosting/how-to-install-nextcloud-on-fedora/

login into linux-1 as amy

ssh into intranet server
```
ssh amy@intranet
```

become root
```
sudo -i
```

install apache http server
```
dnf install httpd
```

install remi
```
dnf install -y http://rpms.remirepo.net/fedora/remi-release-38.rpm
```

install php version 8.2 with remi *(php 8.2 is recommended for nextcloud 27.1.3, but 8.3 is supported)*
```
dnf module reset php -y
dnf module install php:remi-8.2
```

install php libraries
```
dnf install php php-gd php-curl php-dom php-xml php-simplexml php-mbstring php-json php-mysqlnd -y
```

enable php extensions
```
yum --enablerepo=remi install php-intl php-zip
```

start apache http server now
```
systemctl enable --now httpd
```
Check the test page at http://intranet.acme.local
![](20231107090646.png)


install mariadb client+server
```
dnf install mariadb mariadb-server -y
```

start and enable the mariadb server
```
systemctl enable --now mariadb
```

connect to database server to setup nextcloud database
```
mysql
```

create database and user that will be used by nextcloud (change 'dbpassword' to nextcloud db password)
```
CREATE DATABASE nextcloud;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'thatnextcloudpass';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

