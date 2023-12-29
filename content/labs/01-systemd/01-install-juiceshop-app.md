---
title: 01 Install juice-shop App
type: docs
---

In this step, I'm following the Juice Shop [instructions on installing it from source](https://github.com/juice-shop/juice-shop#from-sources) to install the juice-shop web application on the `juiceshop` VM.

I'll be using the SSH service to use the `juiceshop` terminal from the `sysadmin`, using the user account I've created during the CentOS installation: `vmadmin`.

## Download juice-shop v16 From GitHub
juice-shop version 16.0.0 is currently the latest version. You can download the packaged version from its GitHub releases page at `https://github.com/juice-shop/juice-shop/releases/tag/v16.0.0`.
```
wget https://github.com/juice-shop/juice-shop/releases/download/v16.0.0/juice-shop-16.0.0_node21_linux_x64.tgz
```

This packaged release doesn't require running `npm install` the first time. This will save a few minutes.

## Install NodeJS
The node version supported by this juice-shop release is included in the file name: node version 21. You can install this version using CentOS's package manager dnf:
```
dnf module -y install nodejs:21/common
```

## Extract juice-shop package
I'll extract the juice-shop .tgz file into the `/opt` directory, which requires `sudo`:
```
sudo tar zxvf juice-shop-16.0.0_node21_linux_x64.tgz -C /opt
```


## Run juice-shop on localhost:3000
After the code is downloaded, I go into the `juice-shop` directory and install the juice-shop web project using npm:
```
cd /opt/juice-shop/
sudo npm start
```

This will run on port 3000. So the `sysadmin` VM should access it with the URL `http://juiceshop:3000` or `http://192.168.122.10:3000`. However, when I try this, I get a 404 error. This is because the firewalld service doesn't allow other machines to access the 3000 TCP port. 

## Add Port 3000 To firewalld
I need to modify the `juiceshop` firewall to allow port 3000:
```
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
```

Now, the juice-shop web application running on port 3000 should be accessible to the `sysadmin` VM when the address `http://juiceshop:3000` is entered in a web browser.

## Try Using Juice Shop 
From `sysadmin`, you can open the Firefox browser and access the juice-shop app at `http://juiceshop:3000`.

As a quick test, you can submit anonymous customer feedback. Go to `http://juiceshop/#/contact` to access the Customer Feedback form and fill out the form. You just need to enter something in the Comment field, solve the CAPTCHA math problem, and click Submit.

To view the feedback, you can login as the built-in administrator account. The username is `admin@juice-sh.op` and the password is `admin123`. Go to the admin panel at `http://juiceshop/#/administration` at the end of the Customer Feedback section.