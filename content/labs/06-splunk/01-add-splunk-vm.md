---
title: 04 Add splunk VM
type: docs
---

The `splunk` VM will run the Splunk server, and be accessed by the `soc-analyst` and `sysadmin` desktops.

I'll add the `splunk` server VM similar to the `juiceshop` in the `DMZ` network, with a static IP address. Except the `splunk` VM won't need a port redirect configured, because it won't be accessible to public users in the `WAN` network.

## Create splunk VM
I create the `splunk` VM with 4GB of RAM and 30GB hard disk storage. I give it a slightly larger disk, because it will be storing log data.

## Install Splunk Enterprise
To download Splunk Enterprise, the server that gets log data from `juiceshop`, use the `sysadmin` VM to log into the Splunk website and go to their [free trials page](https://www.splunk.com/en_us/download.html).

I choose "Splunk Enterprise", and download the RPM package file, because the `splunk` VM has CentOS installed.

I then use the secure copy utility `scp` to send the file to the `splunk` VM:
```
scp <splunk-enterprise-file>.rpm vmadmin@splunk:/home/vmadmin
```

I then SSH into the `splunk` VM and install the package:
```
sudo rpm -i <splunk-enerprise-file>.rpm
```

## Access Splunk Web Admin from soc-analyst
Running the Splunk server starts the Splunk Web interface at `http://splunk:8000`. I can access it from the `soc-analyst` VM:


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

## Add splunk hostname to pfSense DNS Resolver
Because the `splunk` server doesn't use DHCP, I need to manually add the hostname to the pfSense DNS Resolver service:

## Add soc-analyst User To Splunk Server
The Splunk server has an admin user account, but I think I'll create a lower-privilege account for the `soc-analyst` to use. They just need to monitor the events, while the `sysadmin` can have the admin account to make important changes to Splunk.

While creating a user for `soc-analyst` to use, I choose the "user" [role](https://docs.splunk.com/Documentation/Splunk/9.1.1/Admin/Aboutusersandroles). This gives them the ability to search, and create and edit saved searches.
