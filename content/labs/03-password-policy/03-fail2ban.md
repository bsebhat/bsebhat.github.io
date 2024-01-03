---
title: 03 fail2ban
type: docs
---

One immediate solution to brute force SSH login tools is to add security automation tools that detect when an IP address has been used in multiple failed login attempts and ban it.

One open source too that does this is [fail2ban](https://github.com/fail2ban/fail2ban). It's a service that can be configured to monitor the `/var/log/auth` file for failed login attempts for a service like sshd or Apache web server.

I install the package:
```
sudo dnf install fail2ban
```

I create a new config file:
```
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

And edit the file:
```
sudo vim /etc/fail2ban/jail.local
```

I go to the `[ssh]` section and change the configuration to this:
```
[sshd]
port    = ssh
enabled = true
filter = sshd
logpath = /var/log/secure
maxretry = 3
bantime = 3600
```

This will configure the `fail2ban` service to monitor the `/var/log/secure` (`logpath`) for any source IP addresses making 3 failed SSH login attempts (`maxretry`), and blocks them for 3600 seconds, or 1 hour (`bantime`).

I start and enable the service:
```
sudo systemctl enable --now fail2ban.service
```

Then, from the `hacker` VM, I run the same `hydra` command to brute force the `support` user account on `juiceshop`:
```
hydra -l support -P /usr/share/wordlists/rockyou.txt ssh://juiceshop
```

The password was still cracked. However, when I attempted to login to `juiceshop` from `hacker`, I got this message:
```
ssh: connect to host juiceshop port 22: Connection refused
```

When I check the `iptables` on the `juiceshop` server:
```
sudo iptables -n -L
```

I see this section at the end of the output:
```
Chain f2b-sshd (1 references)
target     prot opt source               destination         
REJECT     all  --  192.168.122.226      0.0.0.0/0            reject-with icmp-port-unreachable
RETURN     all  --  0.0.0.0/0            0.0.0.0/0    
```

This shows the IP address for `hacker` in the `f2b-sshd` iptables chain. If I want to just list the blocked IP addresses in that `f2b-sshd` chain, I can run this:
```
sudo iptables -L f2b-sshd -v -n
```

To unban an IP address, use this command:
```
sudo fail2ban-client set sshd unbanip <IP-ADDRESS>
```

To make this easier in the future, I can add those commands as [bash aliases](https://linuxize.com/post/how-to-create-bash-aliases/) in the `~/.bashrc` file:
```bash
alias f2b_list_banned="sudo iptables -L f2b-sshd -v -n"
alias f2b_unban="sudo fail2ban-client set sshd unbanip $1"
```

Then, make that change available in your current session:
```
source ~/.bashrc
```

If I want to list the IP addresses banned by `fail2ban` for SSHD, I can run:
```
f2b_list_banned
```

And if I need to unban the IP address `192.168.122.226`, I run:
```
f2b_unban 192.168.122.226
``` 
Because they need to run as sudo, you'll need to be a superuser and enter your password.

So the current configuration of `fail2ban` was able to block the `hacker` IP address, but it didn't stop its multiple failed login attempts. Now `hacker` can use a proxy server or virtual private network (VPN) to access `juiceshop` from a new source IP address, and establish an SSH connection using that `support` password it discovered.

So it looks like relying on a single solution or layer of defense can be insufficient when the attacker has access to penetration testing tools like `hydra`.

In the next step, I'll come up with multiple ways to prevent the `hacker` VM from gaining access to the `juiceshop` server via its ["attack surfaces"](https://www.ibm.com/topics/attack-surface), like the SSH service and HTTP service.