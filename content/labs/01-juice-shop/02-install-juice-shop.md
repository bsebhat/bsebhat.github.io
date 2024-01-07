---
title: 02 Install juice-shop
type: docs
---

In this step, I'm following the Juice Shop [instructions on installing it from "packaged distribution"](https://github.com/juice-shop/juice-shop#packaged-distributions) to install the juice-shop web application on the `juicero` VM.

I'll be using the SSH service to use the `juicero` terminal from the `sysadmin`, using the user account I've created during the CentOS installation: `vmadmin`.

## SSH Into juicero From sysadmin
I'll be using the `sysadmin` VM as a workstation that manages other server VMs. I'll run commands on the `juicero` server by using its SSH service. I login to `juicero` using the user account I created called `vmadmin`:
```
ssh vmadmin@juicero
```

Now I can use the `juicero` as if I was working on it directly. However, if I change things like certain network settings, the SSH connection will end. For now, I'm just installing the juice-shop web application.

## Download juice-shop v16
juice-shop version 16.0.0 is currently the latest version. It has different packaged files for download from its GitHub repository. They are for different platforms (Windows, Linux, Mac) and different versions of NodeJS (version 18, 19, 20, 21).

I'll be using the Linux x64 version with NodeJS version 20. You can download the packaged version from its GitHub releases page at `https://github.com/juice-shop/juice-shop/releases/tag/v16.0.0`.
```
wget https://github.com/juice-shop/juice-shop/releases/download/v16.0.0/juice-shop-16.0.0_node20_linux_x64.tgz
```
This packaged release doesn't require running `npm install` the first time. This will save a few minutes.

## Install NodeJS v20
The node version supported by this juice-shop release is included in the file name: node version 20. You can install this version using CentOS's package manager dnf:
```
sudo dnf module -y install nodejs:20/common
```

## Extract juice-shop package
Initially, I'll put the `juice-shop` code in the home directory of `/home/vmadmin`, just to test it out. 

I'll extract the juice-shop .tgz file:
```
tar zxvf juice-shop-16.0.0_node20_linux_x64.tgz
```

I rename the extracted directory to the simpler `juice-shop`:
```
mv juice-shop-16.0.0 juice-shop
```

And go into it:
```
cd juice-shop
```

This directory contains the web application files, including database files, images, and other assets.

Before I run the `juice-shop` web application, I need to modify the `firewall` service running on `juicero`. If I don't allow other machines to access the TCP port 3000, I won't be able to visit the web application from `sysadmin`. 

## Add Port 3000 To firewalld
I can see the open ports on the `firewall` service by listing its configuration:
```
sudo firewall-cmd --list-all
```

I change the `juicero` firewall to allow the TCP port 3000:
```
sudo firewall-cmd --add-port=3000/tcp --permanent
```

And then reload it:
```
sudo firewall-cmd --reload
```

Now, I can see the 3000 on the `ports:` setting on the `firewall` service by listing its configuration again:
```
sudo firewall-cmd --list-all
```

## Run juice-shop on localhost:3000
I can run the juice-shop web application without running `npm install`. Just start it:
```
npm start
```

Within a few seconds, it should say it's running on port 3000. I can go on the `sysadmin` VM and access it with the URL `http://juicero:3000` or `http://192.168.122.10:3000`. I could also access it from my host machine at `http://192.168.122.10:3000`.

Now, the juice-shop web application running on port 3000 can be accessed by the `sysadmin` VM when the address `http://juicero:3000` is entered in a web browser.

## Try Using Juice Shop 
As a quick test, you can submit anonymous customer feedback. Go to `http://juicero:3000/#/contact` to access the Customer Feedback form and fill out the form. You just need to enter something in the Comment field, solve the CAPTCHA math problem, and click Submit.

After submitting feedback, you can view it by logging in using the built-in administrator account. The username is `admin@juice-sh.op` and the password is `admin123`. Go to the admin panel at `http://juicero:3000/#/administration` at the end of the Customer Feedback section.

You can also create a new user account by clicking the "Account" link in the toolbar, clicking "Login", and clicking the "Not yet a member?" link. You can use a fake email, and enter anything for the security question answer. Then, login using those credentials.

NOTE: Any data you enter into the app, like when you create user accounts or submit feedback, will be deleted whenever the `juice-shop` web app restarts. So if you restart it, you will need to re-create the user account you created.