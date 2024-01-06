---
title: 03 Create juice-shop.service
type: docs
---


I want the Juice Shop web application to start automatically when the machine starts, after the network connection has been established. I'll create a systemd service and enable it so that it runs on startup.

## Create systemd service for running web application
I'll create a systemd service on the `juicero` VM by creating a systemd service file `/lib/systemd/system/juice-shop.service`:
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
This is a systemd [network configuration synchronization point](https://systemd.io/NETWORK_ONLINE/), saying the service should run after the network management stack has started. In the case of `juicero`, that's the `NetworkManager` service.

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

I try to run the service:
```
sudo systemctl start juice-shop.service
```

But I get an error when I check the status:
```
sudo systemctl status juice-shop.service
```

I check the logs, and it was blocked by SELinux.

### Modify SELinux To Allow NodeJS
For the I need to modify SELinux to allow nodejs exec.

First, I search the audit logs for denials related to the 'npm' command and create a new custom policy module called my-npm:
```
sudo ausearch -c 'npm' --raw | sudo audit2allow -M my-npm
```

Next, I install that new policiy module:
```
sudo semodule -X 300 -i my-npm.pp
```

Now, when I run the service, it works.
```
sudo systemctl start juice-shop.service
```

So, I enable it so it runs when the machine starts:
```
sudo systemctl enable juice-shop.service
```

When I restart the `juicero` VM, and wait for it to show the login prompt, the web app should be accessible at `http://juicero:3000`.

