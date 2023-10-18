---
title: 03 Make juiceshop a "Server"
type: docs
prev: 02 Add sysadmin VM
next: 04 Add juicefan VM
---

I'm going to make some changes to how the Juice Shop web application is run on the `juiceshop` VM. I don't want `vmadmin`, a user with sudo privileges, to run it. It's located in the `/opt` directory, so I'll create a new non-sudo user named `juiceshop-admin` that owns the directory with the web application code: `/opt/juice-shop`. If the web application needs to be configured, the systems administrator can SSH into `juiceshop` with that non-sudo users and only have access to edit the files in that directory.

I also want the web application to start automatically when the machine starts, after the network connection has been established. I'll create a systemd service and enable it so that it runs on startup.


## Use Non-Sudo User For Juice Shop Web App
Instead of running the Juice Shop app with a high privilege, like `sudo npm start`, I'll create a non-sudo system user with no password.

### Create juiceshop user
First, I'll go on the `sysadmin` VM and SSH into the `juiceshop` VM:
```
ssh vmadmin@juiceshop
```

Then, I'll create the low-privilege system user called "juiceshop":
```
sudo useradd -m -r -s /usr/sbin/nologin juiceshop
```

### Give juiceshop user access to web application directory
I'll need to change the owner of the code in the `/opt/juice-shop` directory to be this new user "juiceshop" instead of the root user:
```
sudo chown -R juiceshop:juiceshop /opt/juice-shop
```

And I'll give that "juiceshop" user read and execute permissions:
```
sudo chmod -R 750 /opt/juice-shop
```

### Create systemd service for running web application
I'll create a systemd service, with the service file `/lib/systemd/system/juice-shop.service`:
```
[Unit]
Description=OWASP juice-shop web app
Documentation=https://github.com/juice-shop/juice-shop
After=network.target

[Service]
Type=simple
User=juiceshop
WorkingDirectory=/opt/juice-shop
ExecStart=/usr/bin/npm start
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

### Test running web application using new user
Now, I'll try running the application with this new low-privilege user:
```
sudo systemctl start juice-shop.service
```

When I visit the web application from the `sysadmin` VM's browser at `http://juiceshop:3000`, the web app is running.

And when I stop the service with `sudo systemctl stop juice-shop`, the web application stops.

I enable it so that it starts when the `juiceshop` VM starts:
```
sudo systemctl enable juice-shop.service
```

When resart the `juiceshop` VM, after a few seconds, the web application is running. Since I don't think I'll need to use the KDE windows manager desktop on `juiceshop`, I disable the `sddm` service:
```
sudo systemctl disable sddm
```

Now, when I start it, it will stay in just terminal mode.

Next, I'll add a Windows 11 VM called `juicefan` and use it like a regular customer/user would.
