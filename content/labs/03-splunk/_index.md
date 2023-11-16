---
title: Lab 03 - Splunk
type: docs
next: 01-use-badjuicer-to-exploit
---

After the previous labs, I have two important assets that are critical to the juice selling business Juice Shop: the `pfsense` firewall server and the `juiceshop` web server.

I'm using the `sysadmin` desktop to manage the servers. And everything's working out fine.

In this lab, I'll add a new user to the `default` network: `badjuicer`. It will use it to exploit one of the vulnerabilities in the Juice Shop web application.

I'll add a small security operations center to help investigate security events using the `juiceshop` server logs and a security information and event management (SIEM) tool called [Splunk](https://www.splunk.com/).

Splunk has a tool to forward log data, like a web server's access logs, to a Splunk server. The Splunk server aggregates the log data and presents it in an easily readable and searchable format. This helps IT staff investigate events to understand what happened without reading the raw log files.