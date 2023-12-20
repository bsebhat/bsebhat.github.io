---
title: 02 Configure SELinux
type: docs
---

Test by turning off SELinux enforcement:
```
sudo setenforce 0
```

The `http://juiceshop:80` is accessible. Turn it back on:
```
sudo setenforce 1
```

Allow `httpd_can_network_connect`:
```
sudo setsebool -P httpd_can_network_connect 1
```

It works