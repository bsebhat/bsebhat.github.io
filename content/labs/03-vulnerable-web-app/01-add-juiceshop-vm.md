---
title: 01 Add juiceshop VM
type: docs
next: 02 Add sysadmin VM
prev: 04-vulnerable-web-app
---

## Setup juiceshop VM 
For the `juiceshop` VM, I clone the `template-archlinux` VM.

Next, I rename the hostname that it kept from the template to `juiceshop`.
```
sudo hostnamectl set-hostname juiceshop
```

I then disable to `sddm` service, because I'll just need the console to run a web application.
```
sudo systemctl disable sddm
```

I reboot and login to the console with the `vmadmin` account I create with the original `template-archlinux` VM.

## Install juice-shop web app from Github
The code for the juice-shop web app is available on its GitHub project page at [https://github.com/juice-shop/juice-shop](https://github.com/juice-shop/juice-shop).

I'll use `git clone` to download the `juice-shop` code to my home directory. 
```
git clone https://github.com/juice-shop/juice-shop.git --depth 1
```

It takes a few minutes to download the code.

It's a NodeJS web application, so I need to install the `nodejs` and `npm` packages to run it:
```
yay -S nodejs npm
```

After NodeJS and NPM are installed, I go into the code's directory, `juice-shop`, and install the juice-shop web project using npm:
```
npm install
```
There are many warnings, because it's a vulnerable application that uses deprecated packages.
![install juice-shop](../install-juice-shop.png)
There are many warnings, because it's a vulnerable application that uses deprecated packages.

This also takes a few minutes, because there are many dependencies that need to be downloaded.

## Test juice-shop Web App
After the `npm install` finishes, I run `npm start` to run the web application. It's running on port 3000. To test it out, I could use a browser on my host machine. I can stop the web application from running with `Ctrl+C`, and run `ip a` to see the IP address for the Ethernet device.

I see that the IP address for the `juiceshop` VM is `192.168.122.140`. I then run it again with `npm start`, and open the `192.168.122.140:3000` in my host computer's web browser, and see the web app welcome page.
![juice shop running](../juice-shop-running.png)

But I don't want to have to run this from my home directory, or have to manually run it when I start the VM. I'll move it to the `/opt` directory and create a systemd service to run it on startup.