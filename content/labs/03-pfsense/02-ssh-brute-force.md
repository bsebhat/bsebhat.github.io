---
title: 02 SSH Brute Force
type: docs
---

The Kali Linux OS on `hacker` comes with many popular penetration applications. You can use them to investigate the `juiceshop` server for avaiable services.

Using the SSH service available on `juiceshop` from the `sysadmin` VM helps make it easier for me to manage the server. I can open a terminal, connect via SSH, and run a few commands to change the `juiceshop` server's configuration.

I assumed the other VMs would just access the Juice Shop web application at port 80, because I didn't put a link advertising the open SSH service on `juiceshop`. Because I thought 99% of users don't know what SSH is, or how servers use TCP port 22 to allow SSH access, I assumed it's safe to leave it open as long as I never referred to it with a link or document. This is an example of ["security through obscurity"](https://en.wikipedia.org/wiki/Security_through_obscurity) And changing the port number used by SSH is still using obscurity.

## hacker Does SSH Brute Force
A common network scanning tool is [nmap](https://nmap.org/). This can scan a host for open ports, and is included in the Kali Linux VM image downloaded as one of the many pre-installed packages.

They can check if the SSH port 22/TCP is open on `juiceshop`:
```
nmap -p22 juiceshop
```

Next, the [hydra](https://en.wikipedia.org/wiki/Hydra_(software)) login cracker tool can be used. It can use a large list of possible passwords and attempt to ["brute-force"](https://en.wikipedia.org/wiki/Brute-force_attack) gain access to the open SSH service.

In the `/usr/share/wordlists/` directory of `hacker` is a large compressed file called `/usr/share/wordlists/rockyou.txt.gz`. This can be extracted:
```
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz
```

This `rockyou.txt` file is a 134 MB text file containing commonly used passwords. And the `hydra` tool can use that huge "wordlist" to attempt SSH logins on the `juiceshop` server.

To demonstrate how it can be used, I'll SSH from `sysadmin` into the `juiceshop` server, and create a new user called `support`:
```
sudo useradd support
```

I'll give it one of the passwords near the beginning of the `rockyou.txt` file, "babygirl":
```
sudo passwd support
```
This will give the warning message:
```
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
```

Then, on the `hacker` VM, I run `hydra` using that new user's name, `support`, and that wordlist, `rockyou.txt`:
```
hydra -l support -P /usr/share/wordlists/rockyou.txt ssh://juiceshop
```

Because it's a very common password, it's near the top of the wordlist (the 13th line) and only takes about 20 seconds. The output is:
```
[22][ssh] host: juiceshop   login: support   password: babygirl
1 of 1 target successfully completed, 1 valid password found
```

I can see evidence of the multiple failed SSH login attempts on `juiceshop` if I look in the `/var/log/secure` file. I can print the last 100 lines of that file, that contain the text "support" (the username I used with the `hydra` login cracker):
```
sudo tail -100 /var/log/secure | grep support
```

The output is:
```
Jan  1 22:43:58 juiceshop sshd[4636]: Failed password for support from 192.168.122.226 port 39510 ssh2
Jan  1 22:43:58 juiceshop sshd[4628]: Failed password for support from 192.168.122.226 port 39430 ssh2
Jan  1 22:44:00 juiceshop sshd[4630]: Connection closed by authenticating user support 192.168.122.226 port 39460 [preauth]
Jan  1 22:44:00 juiceshop sshd[4630]: PAM 1 more authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.122.226  user=support
```

## Auto-Ban Multiple Login Attempts
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

So the current configuration of `fail2ban` was able to block the `hacker` IP address, but it didn't stop its multiple failed login attempts. Now `hacker` can use a proxy server or virtual private network (VPN) to access `juiceshop` from a new source IP address, and establish an SSH connection using that `support` password it discovered.

So it looks like relying on a single solution or layer of defense can be insufficient when the attacker has access to penetration testing tools like `hydra`.

In the next step, I'll come up with multiple ways to prevent the `hacker` VM from gaining access to the `juiceshop` server via its ["attack surfaces"](https://www.ibm.com/topics/attack-surface), like the SSH service and HTTP service.