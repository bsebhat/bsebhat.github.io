---
title: 01 Install juice-shop App
type: docs
---

In this step, I'm following the Juice Shop [instructions on installing it from source](https://github.com/juice-shop/juice-shop#from-sources) to install the juice-shop web application on the `juiceshop` VM.

I'll be using the SSH service to use the `juiceshop` terminal from the `sysadmin`, using the user account I've created during the CentOS installation: `vmadmin`.

## Install NodeJS
First, I'll install NodeJS version 20.
```
dnf module -y install nodejs:20/common
```

I'll also need to install git
```
sudo dnf install git
```

I'll also install the sqlite3 package, so that I can query the juiceshop sqlite database.
```
sudo dnf install sqlite3
```

## Download juice-shop code from GitHub
After NodeJS is installed, I'll use `git clone` to download the `juice-shop` code to the `/opt` directory. I put it there because I might have different users maintaining the code on this machine in the future, and `/opt` is commonly used for software deployed in a single directory.
```
cd /opt
sudo git clone https://github.com/juice-shop/juice-shop.git --depth 1
```

After the code is downloaded, I go into the `juice-shop` directory and install the juice-shop web project using npm:
```
cd juice-shop/
sudo npm install
```
There are many warnings, because it's a vulnerable application that uses deprecated packages. There are also many warnings, because it's a vulnerable application that uses deprecated and insecure dependencies.

After `npm install` has completed, I run the server:
```
sudo npm start
```

This will run on port 3000. So the `sysadmin` VM should access it with the URL `http://juiceshop:3000` or `http://192.168.122.10:3000`. However, when I try this, I get a 404 error. This is because the firewalld service doesn't allow other machines to access the 3000 TCP port. 

I need to modify the `juiceshop` firewall to allow port 3000:
```
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
```

Now, the juice-shop web application running on port 3000 should be accessible to the `sysadmin` VM when the address `http://juiceshop:3000` is entered in a web browser.

## Juice Shop Main Pages
There are a few important pages you can use as the admin for the juice-shop web app.

You can login as the admin account with this user/pass:

admin username:
```
admin@juice-sh.op
```
admin password:
```
admin123
```

admin panel URL:
```
http://juiceshop:3000/#/administration
```

## Test Customer Feedback
You can login with your main browser, access the admin panel, then open a private/incognito browser window. From the private window, you can access the `http://juiceshop:3000` website without being recognized as the admin.

You can go to `http://juiceshop/#/contact` to access the Customer Feedback form and leave anonymous feedback. You just need to enter something in the Comment field, and enter the CAPTCHA math problem, and click Submit.

Then, in the non-private/incognito window where you're logged in as the admin user, you can reload the `http://juiceshop/#/administration` admin page and see your anonymous customer feedback at the bottom of the page.