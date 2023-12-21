---
title: 01 Add hacker VM
type: docs
---

I'm going to create a new VM running Kali Linux. This will act as a user to is trying to exploit vulnerabilities in the `juiceshop` VM.

Because `juiceshop` is communicating directly with users, and running services like Cockpit and SSH so that `sysadmin` can manage it, anyone can run scans on it and attempt to access those services.

Using the `hacker` VM, you can run common recon tasks to gain information about the open services, and attempt to access them.

TODO: add tasks attempting to exploit `juiceshop`.
