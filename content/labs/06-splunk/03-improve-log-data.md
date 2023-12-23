---
title: 03 Improve Log Data
type: docs
---

Currently, the access logs form the web app running on `juiceshop` are being forwarded to the Splunk Enterprise server running on `splunk`.

And I can use the `soc-analyst` VM to log in to the Splunk web portal at `http://splunk:8000` and view the log data using the Search app. It's easier than reading the log files on the `juiceshop` server.

## Log Format
To show how user interaction with the web app shows in the log data on `splunk`, I can use the `customer` VM to submit anonymous feedback. The logs appears, and it's in the [Apache access log format](https://www.sumologic.com/blog/apache-access-log/).

## Source IP Problem
The beginning is the IP address for the client requesting from the server. But if I look at the logs in the Splunk, the client is 127.0.0.1. That's because I installed that nginx reverse proxy. The client, in this case the `customer` VM, sends a request to the `pfsense` VM. The `pfsense` VM uses port redirect to send the request to the `juiceshop` VM's HTTP port 80. The nginx reverse proxy takes the traffic from the HTTP port 80 and sends it to the NodeJS web app running at port 3000, with the source IP being the localhost (the `juiceshop` VM).

If I went on the `soc-analyst` VM and accessed the web application at `http://juiceshop:3000`, then checked the Splunk search, I would see the `soc-analyst` IP address in the beginning of the log data entries.

So I'll need to configure the `nginx` and `juice-shop` services on `juiceshop` to pass the client's source IP through the reverse proxy process.

## Modify nginx


