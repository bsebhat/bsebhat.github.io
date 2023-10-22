---
title: Incomplete - Security Analysis
type: docs
---

In this lab, I'm going to analyze the security of the vulnerable web application I installed in [Lab 01 - Web Server](../../01-web-server/) and the firewall I installed in [Lab 02 - Firewall](../../02-firewall/).

I didn't spend too much time thinking about how insecure they were. I just wanted to get them running ASAP. I created the `juiceshop` web server to let users (like the one using the desktop `juicefan`) order juice online, and I added the `pfsense` firewall server to be a layer of protection between the users and the web server.

Now that it's up, I'm starting to think there might be some risk involved with running an e-commerce web application with international users using a NodeJS project I found on GitHub. It turns out, there are regulations concerning online payment data and personal information. And if business operations are impacted by hackers, it will impact the Juice Shop's revenue and reputation.

To manage this risk, I need to try doing security analysis. I'll use the [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework/getting-started/quick-start-guide) to identify risks and vulnerabilities related to my assets, and determine how I can protect those assets and reduce the risks associated with operating the Juice Shop web app.

Since this is a vulnerable web application created by OWASP to illustrate the most common web application vulnerabilities, I'm going to focus this lab on just a few of the biggest vulnerabilities and risks. I'll determine how to manage the risk associated with them by protecting assets and services. And I'll try to plan how to detect when those vulnerabilities are exploited