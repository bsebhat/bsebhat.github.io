---
title: 06 Confidential Docs Investigation
type: docs
---

Review access logs for any requests contianing `/ftp` with the HTTP method `GET`. They may have several downloads from IP addresses belonging to internal devices, like `sysadmin`. But some may be from the `WAN` interface. Save the access logs with requests from unusual IP addresses as a report titled "Unusual FTP access" for later review.