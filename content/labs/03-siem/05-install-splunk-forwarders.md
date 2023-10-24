---
title: 05 Install Splunk Forwarders
type: docs
---

## Splunk Universal Forwarders
Splunk provides software that can be installed on servers that forwards log data to a Splunk server, so that you can use the Splunk web interface to easily analyze log data from multiple sources and in multiple formats.

In their words, [Splunk Universal Forwarders](https://www.splunk.com/en_us/download/universal-forwarder.html) "provide reliable, secure data collection from remote sources and forward that data into Splunk software for indexing and consolidation".

They can be installed on various operating systems, like Windows, Linux, and Unix (like the FreeBSD on the `pfsense` server).

## Allow DMZ To Access WAN For Install
I haven't figured out a way to create an alias in the pfSense firewall software that allows all of the software package mirror sites I would need to update software on the `juiceshop`. So I'll have the `sysadmin` allow the `DMZ` network to access the `WAN` internet so it can install the Splunk Universal Forwarder software.

So, if I want to install the Splunk Forwarder on `juiceshop` to forward the web application's logs to `splunk`, I think I can either:
1. Temporarily enable access to `WAN` from `DMZ`
2. Download the Splunk Forwarder software on another machine and send it to the `juiceshop` server via scp
3. Add the update mirror sites to the pfSense firewall alias, and allow access to only those sites from the `DMZ`, letting `juiceshop` update and install the Splunk software

I think maybe a compromise is to configure pfSense to log traffic coming from the `DMZ` network to the `WAN` network. And maybe an intrusion detection system (IDS) can be configured to alert when traffic from the DMZ isn't going to an approved software update mirror site.

But for now, I'll just create a rule enabling TCP traffic from the `DMZ` network to `WAN`, and disable it when I'm done.

## Install Forwarder On juiceshop
From `sysadmin`, I use the webConfigurator firewall admin tool to temporarily allow TCP fom `DMZ` to `WAN`:
![dmz allow](../dmz-allow.png)

Then, I SSH into the `juiceshop` web server, update software, and install the Splunk Forwarder:
![update juiceshop](../update-juiceshop.png)
![install forwarder](../install-forwarder.png)

This is what the `/opt` directory on the `juiceshop` server looks like:
![splunk forwarder dir](../splunk-forwarder-dir.png)

Now that the Splunk Forwarder is installed, I delete the firewall rule that allows the `DMZ` access to the `WAN` network.


## Configure Splunk Server To Receive Logs
I open the Splunk server web interface at `http://splunk:8000` and go to the `Settings / Indexes` page.
![splunk index setting](../splunk-index-setting.png)

I create an index called `juiceshop`. This will have the access logs from the `juiceshop` web server:
![splunk juiceshop index](../splunk-juiceshop-index.png)
I go to the `/opt/splunkforwarder/etc/system/local` directory and add the configuration files that tell the Splunk Forwarder what log files should be monitored and forwarded to the Splunk server, and where to forward them.

I then go to the `Settings / Forwarding and receiving` to configure the server to listen to a port and receive the logs.
![splunk forwarding setting](../splunk-forwarding-setting.png)

I click the `Configure receiving` link:
![receiving](../receiving.png)

I click the `New Receiving Port` to add a new port:
![new receiving port](../new-receiving-port.png)

![9997](../9997.png)

## Allow juiceshop To Forward Logs Out Of DMZ
In order to for the `pfsense` web server in the `DMZ` network to forward its logs to the `splunk` server, I need to add a firewall rule. I'll make the rule specific: allow TCP traffic from the source host `juiceshop` (IP `192.168.2.21`) to the destination `splunk` server (IP `192.168.3.10`) at the destination's `9997` port. That's the receiving port I created on the Splunk server.
![specific rule splunk](../specific-rule-splunk.png)

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
maxQueueSize = 1
batchSize = 1
maxEventBatchSize = 1
sendBuf = 1

[tcpout:splunk]
server = 192.168.3.10:9997
```

## Start splunkforwarder systemd Service
I start and enable the `splunkforwarer` service on the `juiceshop` server:
```
sudo systemctl enable --now splunkforwarder
```

I go on the Splunk web interface and use the search app to search for `index="juiceshop"`. But I don't see any events. The problem was with the `juiceshop` and `splunk` service users on the `juiceshop` server.

## Service Users juiceshop and splunk, and Linux Permissions
At first, I thought this was due to the firewall rule I created that restricted access from the `DMZ` network to the `SOC` network. When I SSH into the `juiceshop` server and tried to ping the `splunk` server, it couldn't. But the real reason was the `juiceshop` Linux file permissions. Specifically, the `/opt/juice-shop` and `/opt/splunkforwarder` directories, and the `juiceshop` and `splunk` service users that both use

When I created the `juiceshop` web server, I created a `juiceshop` user for the `juice-shop` systemd service to use to run the web application.

I made the user `juiceshop` owner of the `/opt/juice-shop` directory with all the application's files:
![juice-shop dir](../juice-shop-dir.png)

When I installed the Splunk Forwarder on the `juiceshop` web server, it created a `splunk` user that runs the `splunkforwarder` systemd service.

The way `splunkforwarder` works is it monitors the log files I specify in the `inputs.conf` file. With this line, I told `splunkforwarder` to monitor the access logs in the `/opt/juice-shop/logs` directory:
```
[monitor:///opt/juice-shop/logs/access*]
```

But that's owned by the `juiceshop` user I created. So it couldn't access them. And I forgot about that.

There are different ways to fix this, but I decided to add the `splunk` user that runs `splunkforwarder` to the `juiceshop` group, allowing it to monitor the log files in `/opt/juice-shop/logs`:
```
sudo usermod -aG juiceshop splunk
```

Then, I restarted the `splunkforwarder` service:
```
sudo systemctl restart splunkforwarder
```

And now the `juiceshop` access logs are in the `juiceshop` index on the Splunk server:
![juice logs](../juice-logs.png)