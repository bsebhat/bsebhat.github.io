---
title: 01 Install nginx
type: docs
---

I want to allow users to access the Juice Shop web application from the HTTP port 80. This is the default port used when the user enters `http://juiceshop` in a web browser.

SSH from `sysadmin` into `juiceshop`.

Install nginx on `juiceshop`:
```
sudo dnf install -y nginx
```

Configure nginx to reverse proxy for port 80 and 3000.
Create the configuration file `/etc/nginx/conf.d/juiceshop.conf`:
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

This will configure the `nginx` reverse proxy service to listen to port 80 on the `juiceshop` IP address, and "pass" the traffic to itself ("localhost") at port 3000. 

So I won't need to allow traffic from other machines on port 3000. It can be closed.

I can change the `juiceshop` firewall service again, closing the port 3000 used by Juice Shop:
```
sudo firewall-cmd --remove-port=3000/tcp --permanent
```

Now, I add the HTTP service. This will allow traffic on the HTTP port 80.
```
sudo firewall-cmd --zone=public --add-service=http --permanent
```

It's the same as using the `--add-port=80/tcp`, but because it's a common service, you can just use the service name and nginx will know the port and protocol because it's predefined.

Then, I reload the firewall:
```
sudo firewall-cmd --reload
```

The `nginx` service will forward traffic to that port 80 to the port 3000, and the juice-shop web application will see that as HTTP requests as if it's coming from the same machine, `juiceshop` (localhost).

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

Test by turning off SELinux enforcement:
```
sudo setenforce 0
```

The `http://juiceshop:80` is accessible. Turn it back on:
```
sudo setenforce 1
```

 `httpd_can_network_connect`:
```
sudo setsebool -P httpd_can_network_connect 1
```
