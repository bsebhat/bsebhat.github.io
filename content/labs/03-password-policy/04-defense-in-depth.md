---
title: 04 Defense In Depth
type: docs
---

I had tried preventing the `hacker` VM from attacking the `juiceshop` server's SSH service with a login cracker tool called `hydra`. I installed a service that blocks an IP address if it has 3 failed SSH login attempts. But it wasn't able to stop `hacker` from completing its brute-force attack, just block it from establishing a new SSH connection.

This may require multiple defense strategies working together to effectively reduce the risk of attack using this SSH service. The best solution would be to eliminate it, but I want to use it from the `sysadmin`.

## Three Layers of Defense
I think there are three defense solutions that can work together:
1. Require Strong Passwords: Do not allow users to choose weak passwords whenever they choose a new one. And clearly communicate those password requirements.
2. Have New Passwords Expire: If a superuser on `juiceban` assigns a password to an account, set it to expire so the user must choose a new password.
3. Ban Brute Force SSH Attempts: Keep the `fail2ban` service, so that 3 failed SSH attempts cause the IP address to be banned from connecting via SSH.

The first layer will require all password changes to follow a clearly communicated "strong" password minimum requirements. However, this can be bypassed by superusers (like `vmadmin` or `root`). They can still assign weak initial passwords to accounts.

The next layer requires that the passwords expire. So when the user logs in the first time, they must change the password. And, unlike the password change by superusers, this new password will have to follow the strong password requirements.

And the next layer will ban IP addresses if they make 3 or more failed SSH login attempts.

These multiple defense strategies  will make it harder for attacks to access the `juiceshop` server's SSH service. If one fails, another will an additional layer of difficulty to the attack. This is using the cybersecurity principle of ["defense in depth"](https://www.cyberark.com/what-is/defense-in-depth/).

I've got a service installed, `fail2ban`, that blocks IP addresses if they have multiple failed SSH login attempts. In the next step, I'll implement a password policy for the `juiceshop` server, and communicate the requirements so that users know how to create strong passwords.


**NOTE:** In the next lab, I'll add another layer of defense: Network Segmentation
Currently, the network topology consist of one network: the `default` network. Users on `hacker` and `customer` communicate on it, and `sysadmin` and `juiceshop` communicate with each other on it. In the next lab, I'll create isolated networks for the `juiceshop` web server and the `sysadmin` workstation.

I'll add a firewall server that connects the `default` virtual network with the new isolated network segments. It will allow traffic between them, but under certain restricted firewall rules.