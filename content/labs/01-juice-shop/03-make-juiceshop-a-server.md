---
title: 03 Make juiceshop a "Server"
type: docs
---

## What makes it a "server"?
The only thing I want the `juiceshop` VM to do is serve the Juice Shop web application to users. Right now, I'm not going to use it for anything else. So that's why I consider it a "server". It's serving resources to clients ("Juice Shop users").

In a way, it's already a server, because running the web application is enough. But I want the Juice Shop web application to start automatically when the machine starts, after the network connection has been established. I'll create a systemd service and enable it so that it runs on startup.


## Create systemd service for running web application
I'll create a systemd service on the `juiceshop` VM by creating a systemd service file `/lib/systemd/system/juice-shop.service`:
```
[Unit]
Description=OWASP juice-shop web app service
Documentation=https://owasp.org/www-project-juice-shop/
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/juice-shop
ExecStart=/usr/bin/npm start
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Here's what some of the lines mean.

### After=network.target
This is a systemd [network configuration synchronization point](https://systemd.io/NETWORK_ONLINE/), saying the service should run after the network management stack has started. In the case of `juiceshop`, that's the `NetworkManager` service.

### Type=simple
This makes the service a "simple service". Meaning the main `npm` process will stay in the foreground and not the background.

### User=root
This means the root user will run the service.

### WorkingDirectory=/opt/juice-shop
This is where the service will start. It's like running `ch /opt/juice-shop` before the `ExecStart` is run.

### ExecStart=/usr/bin/npm start
This is the main process that starts the service. It's executed in the `WorkingDirectory`, and will start the juice-shop NodeJS web application.

### Restart=on-failure
This means the service wil restart if it fails.

### WantedBy=multi-user.target
This means the service should start up when the system accepts user login. This means that when I enable this service, a service file is created at `/etc/systemd/system/multi-user.target.wants/juice-shop.service`. Starting the VM without the `sddm` service will still start the login prompt, so it will still cause this service to be run.

### modify firewalld and selinux 
modify firewall to allow port 3000
```
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
```

modify selinux to allow nodejs exec:
```
sudo ausearch -c 'npm' --raw | sudo audit2allow -M my-npm
sudo semodule -X 300 -i my-npm.pp
```

## Test start juice-shop.service
Now, I'll try running the application with this new systemd service I created, `juice-shop`:
```
sudo systemctl start juice-shop.service
```

When I visit the web application from the `sysadmin` VM's browser at `http://juiceshop:3000`, the web app is running.

And when I stop the service with `sudo systemctl stop juice-shop`, the web application stops.

I enable it so that it starts when the `juiceshop` VM starts:
```
sudo systemctl enable juice-shop.service
```

## Test that juice-shop web application starts when VM starts
When I restart the `juiceshop` VM, after a few seconds, the web application is running. I can check if the 3000 port is open by running an nmap scan:
```
nmap juiceshop -p3000
```

## Disable sddm on juiceshop 
Since I don't think I'll need to use the KDE windows manager desktop on `juiceshop`, I disable the `sddm` service:
```
sudo systemctl disable sddm
```
Now, when I start it, it will stay in just terminal mode:
![juiceshop no sddm](../juiceshop-no-sddm.png)

Next, I'll add a Windows 11 VM called `juicefan` and use it like a regular customer/user would.