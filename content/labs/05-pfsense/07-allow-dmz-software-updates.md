---
title: 07 Potential Lab - Allow DMZ Updates
type: docs
---

Now that the `pfsense` web server is seperated from the `LAN` network in the `DMZ` network, I can use the pfSense firewall server to determine the minimal access it needs to function.

Right now, the `juiceshop` server can't make requests to the `LAN` network, or the `default` (or, as the pfSense software calls it, "WAN") network.

The reason I put the `juiceshop` web server in the `DMZ` is because I'm trying to follow the ["principle of least privilege"](https://en.wikipedia.org/wiki/Principle_of_least_privilege). I want to give the server the minimum privileges necessary to function as a web server. I do want to keep updating its software, and it can't do that without access to the internet.

So, I'm going to need to determine the external websites that are used to update the Linux operating system and Juice Shop web application packages.

## What Servers Are Required For Arch Linux OS Updates?
Using the `sysadmin` machine, I SSH into the `juiceshop` web server.

I can see a list of software update mirror sites used by the package management tool `pacman` in the `/etc/pacman.d/mirrorlist` file. Using ChatGPT, I wrote a bash script that takes the uncommented `Server =` lines and extracts the domain names:
```bash
#!/bin/bash

# Extract the active Server lines
grep -v "^#" /etc/pacman.d/mirrorlist | grep "Server =" | \
# Extract the domain part using awk
awk -F'/' '{print $3}' | \
# Sort and remove duplicates
sort -u
```

That script gave me a list of 69 hosts. Here's the first 5 lines:
```
america.mirror.pkgbuild.com
arch.hu.fo
archmirror1.octyl.net
arch.mirror.constant.com
arch.mirror.ivo.st
```

## Create Firewall Rule Allowing Pacman Mirror Lists
I think I'll create another lab where I figure out how to allow servers in the `DMZ` network be restricted to only allow updates to a list of pacman mirrors. 

Maybe I can add the individual mirror sites to a firewall alias named something like "Pacman_Mirrors" at `Firewall / Aliases / URLs`, like this:
![alias mirrors](../alias-mirrors.png)

The pfSense firewall software translates those domain names into IP addresses, and the alias name "Pacman_Mirrors" can be used to create firewall rules without having to list out all of the IP addresses.

Then, I can go to the `Firewall / Rules / DMZ` and add a rule allowing TCP traffic from the mirrors in that alias "Pacman_Mirrors", like this:
![alias rule](../alias-rule.png)

So now if I SSH into `juiceshop`, even though I can't ping the `sysadmin` from the `juiceshop` web server in the `DMZ` network, I can ping one of those few pacman mirror sites I added to the Pacman_Mirrors alias (`america.mirror.pkgbuild.com`) by its IP addresses (`143.244.34.62`):
![allow mirrors not LAN](../allow-mirrors-not-LAN.png)

I just need to figure out how to add dozens of mirror sites to an alias in the pfSense firewall. I've been using the webConfigurator web admin tool, but I think there's an easier way than just adding individual sites by clicking the "Add" button dozens of times.

I'll try working on this for a future lab


