---
title: 06 Summary
type: docs
---

In this lab, I added a `hacker` VM running Kali Linux. I was able to download a pre-installed QEMU VM image, so I didn't have to go through the installation process. It came with a lot of popular penetration testing software.

I was able to use the `hydra` login cracking tool brute force the SSH service on the `juiceshop` server. It used a giant text document called a "wordlist". It has the most commonly used passwords, and can be used to automate the process of guessing passwords for an account. It was for a user account with an extremely weak password, near the top of many password dictionaries, so it was easily cracked.

I was then able to install a service to block the IP address of `hacker` because it had multiple failed SSH login requests. However, this was after the password was discovered via brute force. And it's easy to use that password from another IP address and login. So I think that this single layer of defense, IP blocking failed login attempts, isn't enought.

So, in the next lab, I'll use a "defense in depth" strategy to add another layer of defense against the SSH login vulnerability: password policy 

### Additional Thoughts