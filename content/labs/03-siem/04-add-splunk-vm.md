---
title: 04 Add splunk VM
type: docs
---

The `splunk` VM will run the Splunk server, and be accessed by the `soc-analyst` and `sysadmin` desktops.

I'll add the `splunk` server VM similar to the `juiceshop` in the `DMZ` network, with a static IP address. Except the `splunk` VM won't need a port redirect configured, because it won't be accessible to public users in the `WAN` network.

## Create splunk VM
I create the `splunk` VM by cloning the `template-archlinux` VM. I'll be using this as a server, so I'll disable the `sddm` service later.

## Configure splunk Network Interface
Using the `NetworkManager` service, I configure the `splunk` network interface to use the `pfsense` SOC interface at `193.168.3.1` as its DNS and gateway, and assign the `splunk` network interface to have the static IP address `192.168.3.10/24`:

![splunk net interface](../splunk-net-interface.png)

## Install Splunk Server On splunk VM
I install the Splunk server by installing the aur package:
```
yay -S splunk
```

I start the splunk server:
```
sudo /opt/splunk/bin/splunk start
```

And I agree to the terms and conditions:
![splunk-tos](../splunk-tos.png)


## Access Splunk Web Admin from soc-analyst
Running the Splunk server starts the Splunk Web interface at `http://splunk:8000`. I can access it from the `soc-analyst` VM:
![splunk-admin](../splunk-admin.png)


## Enable Splunk service
I then enable the systemd service for the Splunk server:
```
sudo systemctl enable splunk
```
Now the Splunk server will start automatically. Since I don't need to use the KDE desktop environment, I disable the `sddm` service:
```
sudo systemctl disable sddm
```

## Add splunk hostname to pfSense DNS Resolver
Because the `splunk` server doesn't use DHCP, I need to manually add the hostname to the pfSense DNS Resolver service:
![splunk hostname](../splunk-hostname.png)

## Current Network Topology
So now the `soc-analyst` desktop and `splunk` server are connected to the `SOC` network. The `soc-analyst` can access the `DMZ` to ssh into the `juiceshop` web server and install Splunk software that forwards logs to the `splunk` server.


This is what the network previously looked like:
![firewall soc-analyst](../../../labs/diagrams/firewall-soc-analyst.drawio.png)

And now, with the `splunk` server added:
![firewall splunk](../../../labs/diagrams/firewall-splunk.drawio.png)

Next, I'm going to install the Splunk tool that forwards log data to the Splunk Server, Splunk Universal Forwarder.