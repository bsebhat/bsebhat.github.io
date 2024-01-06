---
title: Lab 02 - nginx
type: docs
next: 01-install-nginx
---

In the previous lab, I created a systemd service that runs the OWASP Juice Shop web application when the `juicero` VM starts. It ran on port 3000, so the user would enter `http://juicero:3000` in their web browser to access it.

In this lab, I'll install [the NGINX server to run as a reverse proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)  on the `juicero` server. 

This adds a layer of protection between the web application and makes it easier for users to access the web application.

It will allow HTTP traffic over port 80 and redirects it to the NodeJS juice-shop application running on port 3000. This will require modifying the `firewalld` service and SELinux security policy on the `juicero`.

It's a shorter lab than others.