---
title: 03 Install Web App
type: docs
---

In this step, I'm following the Juice Shop [instructions on installing it from source](https://github.com/juice-shop/juice-shop#from-sources).

## Install NodeJS
First, I'll install NodeJS version 20.
```
dnf module -y install nodejs:20/common
```

I'll also need to install git
```
sudo dnf install git
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

Now, the juice-shop web application running on port 3000 should be accessible to the `sysadmin` VM.