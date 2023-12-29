---
title: 01 Install juice-shop App
type: docs
---

In this step, I'm following the Juice Shop [instructions on installing it from "packaged distribution"](https://github.com/juice-shop/juice-shop#packaged-distributions) to install the juice-shop web application on the `juiceshop` VM.

I'll be using the SSH service to use the `juiceshop` terminal from the `sysadmin`, using the user account I've created during the CentOS installation: `vmadmin`.

## Download juice-shop v16 From GitHub
juice-shop version 16.0.0 is currently the latest version. It has different packaged files for download from its GitHub repository. They are for different platforms (Windows, Linux, Mac) and different versions of NodeJS (version 18, 19, 20, 21).

I'll be using the Linux x64 version with NodeJS version 20. You can download the packaged version from its GitHub releases page at `https://github.com/juice-shop/juice-shop/releases/tag/v16.0.0`.
```
wget https://github.com/juice-shop/juice-shop/releases/download/v16.0.0/juice-shop-16.0.0_node20_linux_x64.tgz
```

And I extract it:
```
tar xzvf juice-shop-16.0.0_node20_linux_x64.tgz
```

I'll rename the output directory from `juice-shop_16.0.0` to `juice-shop`:
```
mv juice-shop_16.0.0 juice-shop
```

And go to that directory:
```
cd juice-shop
```

This packaged release doesn't require running `npm install` the first time. This will save a few minutes.

## Install NodeJS
The node version supported by this juice-shop release is included in the file name: node version 20. You can install this version using CentOS's package manager dnf:
```
dnf module -y install nodejs:20/common
```

## Extract juice-shop package
I'll extract the juice-shop .tgz file into the `/opt` directory, which requires `sudo`:
```
sudo tar zxvf juice-shop-16.0.0_node20_linux_x64.tgz
```

I rename the extracted directory to simply `juice-shop`:
```
mv juice-shop-16.0.0 juice-shop
```

And cd into it:

```
cd juice-shop
```

## Run juice-shop on localhost:3000
I can run the juice-shop web application without running `npm install`. Just start it:
```
npm start
```

Within a few seconds, it should say it's running on port 3000. So the `sysadmin` VM should access it with the URL `http://juiceshop:3000` or `http://192.168.122.10:3000`. However, when I try this from `sysadmin`, I get a 404 error. This is because the firewalld service on `juiceshop` doesn't allow other machines to access that 3000 TCP port. 

## Add Port 3000 To firewalld
I need to modify the `juiceshop` firewall to allow the TCP port 3000. I stop the `npm start` command, and modify the firewall:
```
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload
```

Then, I re-run the `npm start` command.

Now, the juice-shop web application running on port 3000 can be accessed by the `sysadmin` VM when the address `http://juiceshop:3000` is entered in a web browser.

## Try Using Juice Shop 
From `sysadmin`, you can open the Firefox browser and access the juice-shop app at `http://juiceshop:3000`.

As a quick test, you can submit anonymous customer feedback. Go to `http://juiceshop/#/contact` to access the Customer Feedback form and fill out the form. You just need to enter something in the Comment field, solve the CAPTCHA math problem, and click Submit.

To view the feedback, you can login as the built-in administrator account. The username is `admin@juice-sh.op` and the password is `admin123`. Go to the admin panel at `http://juiceshop/#/administration` at the end of the Customer Feedback section.