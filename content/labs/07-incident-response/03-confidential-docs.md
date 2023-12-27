---
title: 03 Confidential Docs
type: docs
---

This is following the [access a confidential document](https://pwning.owasp-juice.shop/companion-guide/latest/appendix/solutions.html#_access_a_confidential_document) vulnerability.

In the "About Us" page, there is a link to a `legal.md` file. But the file is located at `/ftp/legal.md`. If the user changes the request to just `/ftp`, they will see a list of other files. They include a backup of a package.json file, a document explaining the companies planned aquisitions, and other documents that shouldn't be publicly available.

From the `hacker` machine, I download the `aquisitions.md` file and release it to the public. This causes the admin to send the following email:
```
Someone found out about our secret aquisitions plan. 
Please find out who hacked our secret FTP folder.
-admin
```