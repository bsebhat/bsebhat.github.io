---
title: 05 Create Service User
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

The `User=root` means the service will run the NodeJS web application as the user root. This is very insecure, because the root user has the highest privilege in Linux, and can do anything on the `juiceshop` web server. I would like to create a lower permission user called `juiceshop` who is just there to run that Juice Shop web application.

After creating this new user, I will need to modify the owner of the `/opt/juice-shop` directory so that the new user has access to its content.

I'll do this from the `sysadmin` machine, via SSH.

## Create Non-sudo User
I will create the new user without a password or the ability to login:
```
sudo useradd -m -r -s /usr/sbin/nologin juiceshop
```

## Stop juice-shop Service
I will stop the systemd service that runs the web application, `juice-shop`:
```
sudo systemctl stop juice-shop
```

## Change /opt/juice-shop Permissions
Next, I'll change the owner of the Juice Shop web application's directory, `/opt/juice-shop`, to the new user:
```
sudo chown -R juiceshop:juiceshop /opt/juice-shop
```

I will also restrict read+execute permissions for the directory to only the owner, `juiceshop`:
```
sudo chmod -R 750 /opt/juice-shop
```


## Modify juice-shop systemd Service File
I modify the systemd service file to use the new user instead of root, and restart the `juiceshop` server. After testing the web application with some purchases, everything worked as expected.

So now the service running the Juice Shop web application uses a non-sudo, low permission user. And it's restricted to the `/opt/juice-shop` directory. If there were other users on the `juiceshop` web server, they would need sudo permission to access the directory. And they can't login as the new `juiceshop` users.
