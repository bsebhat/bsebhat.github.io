---
title: 06 Summary
type: docs
---

In this lab, I was able to create a custom password policy to try to prevent Linux accounts on `juiceshop` from having weak passwords. 


The CentOS operating system that `juiceshop` runs would have, by default, stopped the user from choosing that weak password. Because CentOS Stream 9 used the [cracklib](https://github.com/cracklib/cracklib) library and dictionary to ensure users can't choose passwords that appear in most common dictionaries. I think this helps prevent regular users from choosing passwords that can easily be cracked by tools using brute force and large password wordlists/dictionaries.

However, Linux superusers on the `juiceshop` server, like `vmadmin` and `root`, can bypass this and give extremely weak passwords to accounts. If the users of those accounts don't change them, that weak password found in many popular wordlists will remain a vulnerability in the system.

An important part of having a good password policy is to make it a system requirement, communicate the requirements to all staff and users, have admin and users follow them, and require users to change the initial passwords for their accounts by making them expire on next login. 

This is a default option in the Windows Server Active Directory form for creating new domain users. In theory, requiring users to change their passwords should prevent brute force login attacks. But remembering new passwords is a huge hastle for people, so they might choose weak passwords, or reuse old ones. So a "defense in depth" of expiring passwords to force new ones and requiring strong passwords might help work together to solve this vulnerability.

I think the human-factor involved with remembering and entering strong passwords, especially with Linux command line interfaces, can be a huge vulnerability in otherwise secure systems. It's mentally taxing, so weaker passwords will be the easiest solution.

I think the best solution to gain popularity in the past 10-15 years would be [multi-factor authentication (MFA)](https://en.wikipedia.org/wiki/Multi-factor_authentication). I think I will start another lab that follows this [MFA/SSH/CentOS tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-centos-8), or something similar.