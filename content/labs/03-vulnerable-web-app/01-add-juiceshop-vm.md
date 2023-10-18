---
title: 01 Add juiceshop VM
type: docs
next: 02 Add sysadmin VM
prev: 04-vulnerable-web-app
---

## Setup juiceshop VM 
First, I clone the `template-archlinux` VM to create a VM called `juiceshop`. After logging into `juiceshop`, I update the hostname:
```
sudo hostnamectl set-hostname juiceshop
```

Because I will use `juiceshop` as a server, I assign it a static IP of `192.168.122.21`:
![static-ip](../static-ip.png)

## Install juice-shop web app from Github
Before installing the `juice-shop` web application, I read its [README instructions on installing it from source](https://github.com/juice-shop/juice-shop#from-sources).

It's a NodeJS web application, so I need to install the `nodejs` and `npm` packages to run it:
```
yay -S nodejs npm
```

After they are installed, I'll use `git clone` to download the `juice-shop` code to the `/opt` directory. I put it there because I might have different users maintaining the code on this machine in the future, and `/opt` is commonly used for software deployed in a single directory.
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

## Test juice-shop Web App
After the `npm install` finishes, I run `npm start` to run the web application. It's running on port 3000. To test it out, I can open a web browser on `juiceshop` and request the address `http://localhost:3000`.
![view juice-shop local](../view-juice-shop-local.png)

I can also use the IP address and request the web application from my host computer's browser. Since the IP address for `juiceshop` is `192.168.122.21`, I can use my host computer's browser to visit `192.168.122.21:3000`.

For the next step, I will add a VM for a systems administrator who manages this web application. I'll call it `sysadmin`, and use it for most of the rest of the lab.