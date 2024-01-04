---
title: 06 Summary
type: docs
---

In this lab, I added a `hacker` VM running Kali Linux. I was able to download a pre-installed QEMU VM image, so I didn't have to go through the installation process. It came with a lot of popular penetration testing software.

I was able to use the `hydra` login cracking tool brute force the SSH service on the `juiceshop` server. It used a giant text document called a "wordlist". It has the most commonly used passwords, and can be used to automate the process of guessing passwords for an account. It was for a user account with an extremely weak password, near the top of many password dictionaries, so it was easily cracked.

The CentOS operating system that `juiceshop` runs would have, by default, stopped the user from choosing that weak password. Because CentOS Stream 9 used the [cracklib](https://github.com/cracklib/cracklib) library and dictionary to ensure users can't choose passwords. However, Linux superusers on the `juiceshop` server, like `vmadmin` and `root`, can bypass this and give extremely weak passwords to accounts.

An important part of having a good password policy is to make it a system requirement, communicate the requirements to staff and users, have admin and users follow them, and require users to change the initial passwords for their accounts by making them expire on next login.

This is a default option in the Windows Server Active Directory form for creating new domain users. In theory, requiring users to change their passwords should prevent brute force login attacks. But remembering new passwords is a huge hastle for people, so they might choose weak passwords, or reuse old ones. So a "defense in depth" of expiring passwords to force new ones and requiring strong passwords might help work together to solve this vulnerability.

I think the human-factor involved with remembering and entering strong passwords, especially with Linux command line interfaces, can be a huge vulnerability in otherwise secure systems. It's mentally taxing, so weaker passwords will be the easiest solution.

I think the best solution to gain popularity in the past 10-15 years would be [multi-factor authentication (MFA)](https://en.wikipedia.org/wiki/Multi-factor_authentication). I think I will start another lab that follows this [MFA/SSH/CentOS tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-centos-8), or something similar.