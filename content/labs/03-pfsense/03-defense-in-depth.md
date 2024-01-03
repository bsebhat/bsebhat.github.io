---
title: 03 Defense In Depth
type: docs
---

I had tried preventing the `hacker` VM from attacking the `juiceshop` server's SSH service with a login cracker tool called `hydra`. I installed a service that blocks an IP address if it has 3 failed SSH login attempts. But it wasn't able to stop `hacker` from completing its brute-force attack, just block it from establishing a new SSH connection.

This may require multiple defense strategies working together to effectively reduce the risk of attack using this SSH service. The best solution would be to eliminate it, but I want to use it from the `sysadmin`.

## Three Layers of Defense
I think there are three defense solutions that can work together:
1. Ban Brute Force SSH Attempts: Keep the `fail2ban` service, so that 3 failed SSH attempts cause the IP address to be banned.
2. Password Policy: Do not allow user accounts on `juiceshop` to use weak passwords, or passwords that can be found in wordlists like the one used by `hacker`, `rockyou.txt`. Simply having an administrative "best practices" policy won't be enough.
3. Isolated Network: Create a isolated network between machines used for managing the `juiceshop` web server (in these lab, just the `sysadmin` workstation) and the VMs on the `default` virtual network. I'm going to treat the `default` virtual network like a wide are network, or ["WAN"](https://en.wikipedia.org/wiki/Wide_area_network), and not trust traffic coming from it. It will have regular users (`customer`), and malicious users (`hacker`).

For the new isolated network and the existing `default` network, a firewall server can be added between them, managing what traffic is passed between them. It can act as a gateway server. This will also provide a way to log the traffic, and monitor it. The firewall server will have a easy-to-use firewall software called .

These multiple defense strategies  will make it harder for attacks to access the `juiceshop` server. If one fails, another will an additional layer of difficulty to the attack. This is using the cybersecurity principle of ["defense in depth"](https://www.cyberark.com/what-is/defense-in-depth/).

I've got a service installed, `fail2ban`, that blocks IP addresses if they have multiple failed SSH login attempts. In the next step, I'll implement a password policy for the `juiceshop` server, and communicate the requirements so that users know how to create strong passwords.