---
title: 02 Install Splunk Forwarders
type: docs
---

## Splunk Universal Forwarders
Splunk provides software that can be installed on servers that forwards log data to a Splunk server, so that you can use the Splunk web interface to easily analyze log data from multiple sources and in multiple formats.

In their words, [Splunk Universal Forwarders](https://www.splunk.com/en_us/download/universal-forwarder.html) "provide reliable, secure data collection from remote sources and forward that data into Splunk software for indexing and consolidation".

They can be installed on various operating systems, like Windows, Linux, and Unix (like the FreeBSD on the `pfsense` server).

## Send SplunkForwarder file to juiceshop
Because the `juiceshop` is in the `DMZ` network, there are no firewall rules allowing it to download software from the internet. To install the  SplunkForwarder software that can forward the access logs to the `splunk` VM, I'll download the software onto the `sysadmin` VM, and use the secure file tool `scp` to upload the file to `juiceshop`:
```
scp <splunk-forwarder-file> vmadmin@juiceshop:/home/vmadmin
```

Then, I'll SSH into `juiceshop` and install SplunkForwarder.
```
sudo rpm install <splunk-forwarder-file>.rpm
```

## Configure Splunk Server To Receive Logs
I open the Splunk server web interface at `http://splunk:8000` and go to the `Settings / Indexes` page.

I create an index called `juiceshop`. This will have the access logs from the `juiceshop` web server:
I go to the `/opt/splunkforwarder/etc/system/local` directory and add the configuration files that tell the Splunk Forwarder what log files should be monitored and forwarded to the Splunk server, and where to forward them.

I then go to the `Settings / Forwarding and receiving` to configure the server to listen to a port and receive the logs.

I click the `Configure receiving` link:

I click the `New Receiving Port` to add a new port:


## Allow juiceshop To Forward Logs Out Of DMZ
In order to for the `pfsense` web server in the `DMZ` network to forward its logs to the `splunk` server, I need to add a firewall rule. I'll make the rule specific: allow TCP traffic from the source host `juiceshop` (IP `192.168.2.21`) to the destination `splunk` server (IP `192.168.3.10`) at the destination's `9997` port. That's the receiving port I created on the Splunk server.

### inputs.conf
The first configuration file I'll add is `inputs.conf`. This identifies the log files to monitor and forward to the Splunk server.

In the `/opt/splunkforwarder/etc/system/local/inputs.conf` file:
```
[monitor:///opt/juice-shop/logs/access*]
index = juiceshop
sourcetype = access_log
```

This tells the Splunk Forwarder to monitor the logs at `/opt/juice-shop/logs/access*` for changes and forward them to the Splunk index `juiceshop`. It also gives the `soucetype`, so that Splunk knows the format the logs will be in.

### outputs.conf
I also add an `outputs.conf` file to configure where the logs will be forwarded to.

In the `/opt/splunkforwarder/etc/system/local/outputs.conf`:
```
[tcpout]
defaultGroup = splunk

[tcpout:splunk]
server = 192.168.3.10:9997
```

## Create SplunkForwarder systemd Service
I enable the `SplunkForwarder` service on the `juiceshop` server:
```
sudo /opt/splunkforwarder/bin/splunk enable boot-start -user splunkfwd  -systemd-managed 1
```

And I start it:
```
sudo systemctl start SplunkForwarder.service
```

Next, use the web app on `juiceshop` from a browser. Just refresh it once or twice. Then, I go on the Splunk web interface and use the search app to search for `index="juiceshop"` and I see access logs for the web app on `juiceshop`.
