---
title: 01 Add splunk VM
type: docs
---

The `splunk` VM will run the Splunk server, and be accessed by the `soc-analyst` and `sysadmin` desktops.

I'll add the `splunk` server VM similar to the `juicero` in the `DMZ` network, with a static IP address. Except the `splunk` VM won't need a port redirect configured, because it won't be accessible to public users in the `WAN` network.

## Clone juicero To Create splunk VM
I create the `splunk` VM by cloning the `juicero` VM and disabling the juice-shop service.

This requires changing the static IP, changing the hostname to splunk, and modifying the firewall. Because the VM was cloned from `juicero`, remove the 3000/tcp port:
```
sudo firewall-cmd --remove-port=3000/tcp --permanent
```

The Splunk Enterprise web interface will use port 8000, and the listening port I'll add will be 9997. So I'll need to add the 8000/tcp and 9997/tcp ports to the firewall:
```
sudo firewall-cmd --add-port=8000/tcp --add-port=9997/tcp --permanent
```

And reload:
```
sudo firewall-cmd --reload
```


## Add splunk hostname to pfSense DNS Resolver
Because the `splunk` server doesn't use DHCP, I need to manually add the hostname and static IP to the pfSense DNS Resolver service.

## Install Splunk Enterprise
To download Splunk Enterprise, the service that will ingest and displays log data from `juicero`, use the `sysadmin` VM to log into the Splunk website and go to their [free trials page](https://www.splunk.com/en_us/download.html).

I choose "Splunk Enterprise", and download the RPM package file, because the `splunk` VM has CentOS installed.

I then use the secure copy utility `scp` to send the file to the `splunk` VM:
```
scp <splunk-enterprise-file>.rpm vmadmin@splunk:/home/vmadmin
```

I then SSH into the `splunk` VM and install the package:
```
sudo rpm -i <splunk-enerprise-file>.rpm
```

## Access Splunk Web Interface
Running the Splunk server starts the Splunk Web interface at `http://splunk:8000`. 


## Enable Splunk service
On the `splunk` VM, you can create a systemd service using the spunk command at `/opt/splunk/bin/splunk`:
```
sudo /opt/splunk/bin/splunk enable boot-start -user splunk  -systemd-managed 1
```

Because the systemd service will run Splunk using the user splunk, I make sure all files in the `/opt/splunk` directory are owned by splunk:
```
sudo chown -R splunk:splunk /opt/splunk
```

This will create a system file at `/etc/systemd/system/Splunkd.service`, enabled to start on next boot, run by the user splunk, but not started.

Next, start it:
```
sudo systemctl start Splunkd.service
```

I go to `http://splunk:8000` and login 

