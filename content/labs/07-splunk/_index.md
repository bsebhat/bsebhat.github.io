---
title: Lab 07 - Splunk
type: docs
next: 01-add-splunk-vm
---

After the previous labs, I have two important assets that are critical to the juice selling business Juice Shop: the `pfsense` firewall server and the `juicero` web server.

I'm using the `sysadmin` desktop to manage the servers. And everything's working out fine.

Splunk has a tool to forward log data, like a web server's access logs, to a Splunk server. The Splunk server aggregates the log data and presents it in an easily readable and searchable format. This helps IT staff investigate events to understand what happened without reading the raw log files.