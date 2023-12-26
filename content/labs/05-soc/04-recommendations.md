---
title: 04 Recommendations
type: docs
---

There are a few things that can be added to teh system to make it easier for the SOC team to monitor the security of the `pfsense` and `juiceshop` servers, while minimizing the privileges given to SOC team members.

## Add pfsense User Account For SOC
This can be done by creating lowest-privilege necessary accounts on the `juiceshop` and `pfsense` servers. For the `pfsense` server, a SOC-Team group can be created, and given access to the Suricata service and log files. This would help during and after a security incident, so that log data for HTTP traffic can be analyzed.

### Suricata
When the SOC team has identified certain actions taken by attackers, the Suricata service on `pfsense` can be used to create alerts when those actions are repeated by new machines.

### Packet Capture
Another helpful service that the SOC team can use is the packet capture feature on `pfsense`. They can use it to temporarily monitor packets on the `DMZ` network during an ongoing attack, and save the packets to a pcap file to analyze later or present as evidence. The Packet Capture feature in pfSense uses the tcpdump application, and can be customized to limit the packets being captured.

## Add juiceshop soc-analyst User Account
And the SOC team can use a lower privilege account to view the Juice Shop web application access logs on the `juiceshop` server. They can also be given access to query the sqlite database used by the web application, so that data from suspicious traffic can be compared with database records to see what actions where taken.

## Add Splunk SIEM Server In SOC Network
It would be very helpful to have a SIEM that can present access logs in an easy to view and easy to search format. You can install the Splunk Universal Forwarder on the `juiceshop` server, and a new `splunk` server in the `SOC` network, and have the access logs forwarded to the `splunk` server. Then, the SOC team can monitor the network traffic to the 