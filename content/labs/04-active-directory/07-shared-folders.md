---
title: 07 Shared Folders
type: docs
---

![](users-shared.png)
![](domain-shared-folders.png)
![](shared-employees-docs.png)
![](employees-docs-security.png)
![](it-admin-docs-security.png)
![](it-staff-docs-security.png)

Network Path for `C:\Shared` is `\\REYNHOLM-DC\Shared`

Employees: nolan
As vmadmin, install cifs
```
sudo apt install cifs-utils -y
```

create mount dir for shared
```
sudo mkdir /mnt/domain-shared
```

mount shared directory
```
sudo mount -t cifs -o username=nolan,domain=REYNHOLM.local //REYNHOLM-DC/Shared /mnt/domain-shared/
```

The contents of `/mnt/domain-shared/` is `Employees-Docs`.

For user also in IT-Staff, contents are Employees-Docs and IT-Staff-Docs
For user also in IT-Admin, contents are Employees-Docs and IT-Staff-Docs
nd IT-Admin-Docs

NOTE:
Auto mount shared directory(?)
//ServerName/ShareName /path/to/mount cifs credentials=/path/to/credentials,file_mode=0755,dir_mode=0755 0 0
