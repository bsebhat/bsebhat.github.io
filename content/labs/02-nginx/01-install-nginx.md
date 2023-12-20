---
title: 01 Install nginx
type: docs
---

## Rough notes
SSH from `sysadmin` into `juiceshop`.

Install nginx on `juiceshop`:
```
sudo dnf install -y nginx
```

Configure nginx to reverse proxy for port 80 and 3000.
Create /etc/nginx/conf.d/juiceshop.conf:
```
server {
    listen 80;

    server_name 192.168.122.10;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Open HTTP/80 port:
```
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
```

Start/enable nginx service:
```
sudo systemctl enable --now nginx.service
```

Check status for nginx and juice-shop services:
```
sudo systemctl status nginx
sudo systemctl status juice-shop
```

Open browser and go to `http://juiceshop:80` or `http://juiceshop`

There's a Bad Gateway error.

Check the nginx error log at `/var/log/nginx/error.log`

See `(permission denied)`, might be SELinux.


