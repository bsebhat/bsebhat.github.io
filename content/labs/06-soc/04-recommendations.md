---
title: 04 Recommendations
type: docs
---

There are a few things that can be added to teh system to make it easier for the SOC team to monitor the security of the `pfsense` and `juiceshop` servers, while minimizing the privileges given to SOC team members.

## Add Accounts For SOC on Servers
This can be done by creating lowest-privilege necessary accounts on the `juiceshop` and `pfsense` servers. This can allow them to access files and services required to investigate security incidents, without giving them the highest level privilege reserved for systems administrators.

### Add SOC Account On pfsense Server
For the `pfsense` server, a SOC-Team group can be created, and given access to specific service that can help them detect and investigate intrusions. Two of these include the packet capture service and the Suricata IDS.

#### Packet Capture
Another helpful service that the SOC team can use is the packet capture feature on `pfsense`. They can use it to temporarily monitor packets on the `DMZ` network during an ongoing attack, and save the packets to a pcap file to analyze later or present as evidence. The Packet Capture feature in pfSense uses the tcpdump application, and can be customized to limit the packets being captured.

#### Suricata
When the SOC team has identified certain actions taken by attackers, the Suricata service on `pfsense` can be used to create alerts when those actions are repeated in the future. If there is an HTTP status code that might occur when a user is attempting to exploit a vulnerability, like the HTTP status code 401 Unauthorized, you can create a Suricata rule that generates an alert when that status code is returned. Or, if an admin API request for the juice-shop web application that should only be made from the systems administrator LAN interface, you can create a rule that blocks it from the WAN interface.

### Add SOC Account On juiceshop Server
And the SOC team can use a lower privilege account to view the Juice Shop web application access logs on the `juiceshop` server. They can also be given access to query the sqlite database used by the web application, so that data from suspicious traffic can be compared with database records to see what actions where taken.

## Add Splunk SIEM Server In SOC Network
It would be very helpful to have a SIEM that can present access logs in an easy to view and easy to search format. You can install the Splunk Universal Forwarder on the `juiceshop` server, and a new `splunk` server in the `SOC` network, and have the access logs forwarded to the `splunk` server. Then, the SOC team can monitor the network traffic to the `juiceshop` server and search for specific HTTP requests.

## SOC Playbook
A "playbook" can be any document or blog or record keeping that can store important knowledge. Like how the networks or servers are structured and what they do, how to use tools that can help make incident investigations easier, or how to monitor systems and interpret alerts.

When the team isn't responding to an incident, they can be exploring and analyzing the `juiceshop` web server and documenting important facts that can be useful during an incident. For example, they can use the web application and attempt to access something they're not allowed to, and see a specific HTTP status code. They can then document the steps they took, the HTTP requests sent to the server, and the HTTPS status code it received. Then, if the incident occurs, they can look up this information and see the HTTP requests and status codes that are related to the incident. This can save time.

The playbook can also contain the steps to take to contain the threat, like requesting that the sys admin block a suspicious IP address. Or how to restore data or files after there has been an attack.

The playbook would be an ongoing project. As members of the SOC team learn new things, they can routinely update the playbook. And review it to remove irrelevent/outdated entries.
