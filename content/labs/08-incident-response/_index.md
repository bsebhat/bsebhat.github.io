---
title: Lab 08 - Incident Response
type: docs
next: 01-broken-access-control
---

I'm going to use this `hacker` VM to exploit some of the [built-in vulnerabilities](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html) of the Juice Shop web application. The vulnerabilities are considered "challenges" that test the skills of penetration testers. Some challenges are considered easier, and have a "one star" score. The more difficult the exploit, the more stars.

They are also organized into [vulnerability categories](https://owasp.org/www-project-juice-shop/#div-challenges), like "Broken Authentication" and "Improper Input Validation".

For some of the exploits, I'll be using a penetration testing tool called [Burp Suite](https://portswigger.net/burp/) community edition. It's included on the `hacker` VM because it's running Kali Linux, but you can install it on Windows or Linux distros.