---
title: 04 Create Domain Users
type: docs
---


Create groups IT-Admin, IT-Staff, and Employees

Add to groups

Employees: amy, bob, charlie, dan
IT-Staff: amy, bob
IT-Admin: amy


Create Company organizational unit
![](../20231101093946.png)

Create an IT-Department and Office OU within the Company OU
![](../20231101094107.png)

Create a user named amy in the IT-Department OU
![](../20231101094453.png)

Create another one named sam.

Create a security group in the IT-Department OU called IT-Staff.
![](../20231101094810.png)

Add both amy and sam to the IT-Staff security group.
![](../20231101094907.png)

Create another security group called IT-Admin in the IT-Department OU, but only add amy to that security group.

Now the IT-Department security groups are:
IT-Staff: amy, sam
IT-Admin: amy

When configuring privileges on Linux computers that join the domain, only users in the IT-Staff security group can login, but users who are members of the IT-Admin security group will have higher privileges then users who are just members of IT-Staff.


Create two users in the Office OU: sara and mark
![](../20231101100356.png)

Create two security groups called Office-Staff and Office-Managers.
Add mark and sara to the Office-Staff security group, and only add mark to the Office-Manager group.

Now, the ACME.local domain has these OUs, users, and security groups:
1. Organizational Unit: IT-Department
   1. Security Groups: IT-Admin, IT-Staff
   2. Users: amy (IT-Admin, IT-Staff), sam (IT-Staff)
2. Organizational Unit: Office
   1. Security Groups: Office-Managers, Office-Staff
   2. Users: mark (Office-Managers, Office-Staff), sara (Office-Staff)

The Office-Managers should have higher privileges than Office-Staff, and IT-Admin should have higher privileges than IT-Staff.
