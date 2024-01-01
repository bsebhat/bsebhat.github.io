---
title: 04 Create Service User
type: docs
---

I'd like to make a change to how the Juice Shop web application is run by its service, `juice-shop`. This is the systemd service file I created at `/lib/systemd/system/juice-shop.service`:

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

The `User=root` means the service will run the NodeJS web application as the user root. This is very insecure, because the root user has the highest privilege in Linux, and can do anything on the `juiceshop` web server. I would like to create a lower permission user called `juiceshop` who is just there to run that Juice Shop web application. There's no reason to use the `root` user to run the `npm start` command that runs the web application.

The code and database for the application are all contained in the directory `/opt/juice-shop`. So I will change the owner of that directory (and recursively, its content) to be this new user `juiceshop`.

And I'll do this from the `sysadmin` machine, via SSH.

Before making changes, I'll shutdown the `juiceshop` VM and create a snapshot. In case I need make a mistake and need to go back to the current state.

If this were a real website, I should first create a duplicate `juiceshop` server that closly matches the one being used, so that large changes like this can be tested without risking loss of data or a long downtime.

## Create No-Login User juiceshop
I will create the new user called `juiceshop` without a password or the ability to login:
```
sudo useradd -m -r -s /usr/sbin/nologin juiceshop
```

## Stop juice-shop Service
I will stop the systemd service that is currently running the web application so that I can test running the application with the new user:
```
sudo systemctl stop juice-shop
```

## Change /opt/juice-shop Permissions
Next, I'll change the owner of the Juice Shop web application's directory, `/opt/juice-shop`, to the new user:
```
sudo chown -R juiceshop:juiceshop /opt/juice-shop
```

I will also ensure that read+execute permissions for the directory to only the owner, `juiceshop`:
```
sudo chmod -R 750 /opt/juice-shop
```


## Test New User
From the `/opt/juice-shop` directory, I'll run a test to check that this new user can run the `/usr/bin/npm` command from the `/opt/juice-shop` directory:
```
sudo -u juiceshop -s -- sh -c 'cd /opt/juice-shop && /usr/bin/npm'
```

I see that it works, and the web application is running. I test it by adding some customer feedback. 

## Modify juice-shop systemd Service File
Now that the files in the `/opt/juice-shop` don't require the `root` user to access them, and I see that the new user I created can run the web application with `npm start`, I can edit the `juice-shop.service` systemd service file to use the new `juiceshop` user rather than the higher privileged `root` user.

I edit the `/lib/systemd/system/juice-shop.service` file:
```
sudo vim /lib/systemd/system/juice-shop.service
```

And edit the line `User=root` to be `User=juiceshop`:
```
[Unit]
Description=OWASP juice-shop web app service
Documentation=https://owasp.org/www-project-juice-shop/
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

Because I changed that service file, I need to reload it:
```
sudo systemctl daemon-reload
```

Next, I start the `juice-shop` service:
```
sudo systemctl start juice-shop.service
```

I wait about 5 seconds for the app to startup, and check the address `http://juiceshop` and it still works.

I modify the systemd service file to use the new user instead of root, and restart the `juiceshop` server. After testing the web application with some purchases, everything worked as expected.

So now the service running the Juice Shop web application uses a non-sudo, low permission user. And it's restricted to the `/opt/juice-shop` directory. If there were other users on the `juiceshop` web server, they would need sudo permission to access the directory. And they can't login as the new `juiceshop` users.

You can test it by adding anonymous customer feedback and checking the admin panel.

## Conclusion
Again, this isn't a very good representation of how users/customers interact with web servers on the internet. There would be seperate networks connected by devices like routers. For this lab, I treated the `default` virtual network like a wide area network (WAN) where users can connect to web servers, and IT staff can manage the servers from seperate machines. I just wanted to start adding some VMs for future labs.

This was just a lab to setup the web application on the Linux server VM, and configure a systemd service to get it running when the VM starts.

It's also a very insecure way of allowing users to access the Juice Shop web application. The user on the `customer` VM can directly access the `juiceshop` web server, and it's running SSH so the `sysadmin` can manage it.