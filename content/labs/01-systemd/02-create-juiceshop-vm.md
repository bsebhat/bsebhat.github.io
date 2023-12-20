---
title: 02 Create juiceshop VM
type: docs
---

## Setup juiceshop VM 
The VM creation process is basically the same as with sysadmin, except for two installation steps: Software Selection and Network & Host Name

### Software Selection
Instead of selecting "Workstation" like I did with `sysadmin`, I'll just choose "Server". It won't have a GNOME desktop environment, but I'll be using the `sysadmin` VM to manage the server via SSH.

### Network & Host Name
Instead of using DHCP to receive a leased IP address, I'll give `juiceshop` a static IP address of `192.168.122.10`. I'll use the same `192.168.122.1` for the gateway and DNS server settings.

After the CentOS installation has finished, I click "Reboot System". From now on, I'll be using the `sysadmin` to install the OWAS Juice Shop web application.

## Install juice-shop web app from Github
