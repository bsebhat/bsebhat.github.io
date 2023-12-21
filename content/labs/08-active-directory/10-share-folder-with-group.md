---
title: 09 Share Folders With Groups
type: docs
---

I want to share files with domain users. I create a folder at `C:\Shared`
![](../20231104035922.png)

I create two folders in `C:\Shared`, `Office-Files` and `IT-Files`.

I want to share the contents of the `Office-Files` folder with users in the `Office-Staff` and `Office-Managers` security groups.

I want users in the `Office-Staff` group to be able to read the files, and users in the `Office-Managers` should be able to read AND write.

I right-click the `C:\Shared\Office-Files` folder and select "Properties". I go to "Sharing", and I click the "Share..." button.
![](../20231104040732.png)

It shows a "Network access" window, where I can enter domain groups or names and give them "Read" or "Read/Write" permission on the folder. By default, the user I'm currently using has "Read/Write" and "Owner" permission, because I just created it.
![](../20231104040946.png)


To give `Office-Managers` the "Read/Write" permission, I type "Office-Managers" and click the "Add" button. Then, click the permission dropdown and select "Read/Write".
![](../20231104041055.png)

I do the same to add the `Office-Staff` group and give them "Read" permission.
![](../20231104041225.png)

Next, I click the "Share" button.

The folder is now shared with those groups, with different permission levels, at the path `\\ACME-DC\Office-Files`
![](../20231104041314.png)

I open the Group Policy Manager, and create a new GPO called `Map-Office-Files`:
![](../20231104043148.png)

I drag that new GPO to the `Office` OU:
![](../20231104043305.png)

Now, the `Map-Office-Files` is linked to the `Office` organizational unit:
![](../20231104043648.png)


On the `win-1` VM, I login as mark, who is in both the `Office-Managers` and `Office-Staff`.

Add the shared folder to the `Office` organizational unit:
![](../20231104043851.png)
![](../20231104044038.png)
![](../20231104044057.png)

Edit the `Map-Office-Files` GPO:
![](../20231104044132.png)

Go to User Configuration > Preferences > Drive Maps.
![](../20231104083949.png)


Have it mapped to the O drive:
![](../20231104044347.png)

Common:
![](../20231104044518.png)



On the `win-2` VM, if I login as sara, a user in the Office organizational unit, the shared Office folder is mapped to the O drive:
![](../20231104064119.png)

The user sara can read the content of the shared folder, "Office Rules.txt":
![](../20231104064223.png)

But because sara is a member of the `Office-Staff` security group and not `Office-Managers` group, you can't edit the file.
![](../20231104064422.png)

But if I log in as mark, who is a member of both groups, the text file can be edited.

Install samba clients:
```
sudo dnf install samba-client cifs-utils
```

I create a folder for IT-Staff at `C:\Shared\IT-Files`
![](../20231104083302.png)
![](../20231104083351.png)
![](../20231104083729.png)


On `linux-1`, I log in as amy, and run this command to mount the shared folder IT-Files
```
sudo mount -t cifs -o username=amy,domain=acme.local //ACME-DC/IT-Files ~/IT-Dept-Share/
```
![](../20231104084745.png)

![](../20231104084928.png)

