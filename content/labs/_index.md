---
title: Labs
type: docs
---

Here are some virtual machine (VM) labs I've been working on.

[Lab 00 - Setup](./00-setup): Install QEMU, libvirt, and virt-manager. Create a Linux workstation VM called `sysadmin`, connected to a virtual network.

[Lab 01 - juice-shop](./01-juice-shop): Create a Linux server VM called `juicero`, install the OWASP Juice Shop web application, and create a service to run it.

[Lab 02 - nginx](./02-nginx): Install NGINX and configure a reverse proxy on the `juicero` server. 

[Lab 03 - SSH Brute Force](./03-ssh-brute-force): Add a VM running Kali Linux called `hacker`, run `hydra` to crack SSH login on `juicero`, install `fail2ban` service on `juicero`. 

[Lab 04 - Password Policy](./04-password-policy): Improve the password policy on the `juicero` server.

[Lab 05 - pfsense](./05-pfsense): Create isolated virtual networks `LAN` and `DMZ`, add a VM called `pfsense` to act as gateway and firewall.

[Lab 06 - SOC](./06-soc): Add a security operations center (SOC), perform security analysis on network, create SOC playbook.

[Lab 07 - Splunk](./07-splunk): Add `splunk` VM running Splunk, configure `juicero` to forward log data.

[Lab 08 - Incident Response](./08-incident-response): Use `hacker` VM to exploit vulnerabilities in OWASP Juice Shop web application, use SOC to respond to incidents.