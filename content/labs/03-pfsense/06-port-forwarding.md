---
title: 06 Port Forwarding
type: docs
---

I'll be using the webConfigurator web admin tool on the `pfsense` VM from the `sysadmin` VM. I'll use the `sysadmin` VM for managing server VMs like `pfsense` and `juiceshop`, because it's a desktop and it kind of represents how IT staff manage servers from their desktops.

## Port Forwarding to juiceshop
To allow users to access the `juiceshop` VM via the `pfsense` VM, I need to configure port forwarding. In this lab, I want HTTP traffic from `customer` to the WAN interface on the `pfsense` VM to get forwarded to the `juiceshop`. And it would need to be to the 3000 port on `juiceshop`, because that's the port that the NodeJS Juice Shop web application is running on.

I was previously using the nginx reverse proxy service to allow HTTP traffic to port 80 to get redirected to port 3000, but I'll disable that for now. Until I can solve this issue with source IP addresses in requests*.

Using the webConfigurator tool, I can go to the Firewall / NAT / Port Forward settings page. I click the "Add" button, and create a "Redirect Entry" that forwards TCP communication to the WAN address HTTP port to the `juiceshop` IP address `192.168.1.21`, specifically its 3000 port.

This creates a firewall rule for the WAN interface.

## Test Firewall Forwards HTTP to juiceshop
Now that port forwarding was setup, I use the `customer` VM to visit the `juiceshop` by using making an HTTP request to the IP address for `pfsense`: `http://192.168.122.178`

## *TODO: nginx Reverse Proxy and Original Source IP
I tried configuring port redirect from the HTTP port 80 on the `pfsense` WAN interface to the HTTP port on `juiceshop`, leaving the nginx reverse proxy to send incoming HTTP traffic to the juice-shop NodeJS port 3000. It worked great, but the original client IP address in the app's access logs were replaced by the localhost `127.0.0.1` because the packets were coming from the nginx on `juiceshop`. I wanted that original client IP in the access logs, so that you could see the HTTP traffic source when reviewing logs in the Splunk server (in a later lab). It took too long to find a work around, so that's why I'm disabling the nginx reverse proxy on `juiceshop`, and configuring the port redirect to use the 3000 port on `juiceshop`. It's a little less secure, but I need to figure out the source IP issue first.