---
title: 05 Add win-1 VM
type: docs
---

I clone a Windows 11 desktop from my `template-win11` VM, and call it `win-1`
![](20231101060139.png)

I set its NIC to connect to the `LAN` network
![](20231101072843.png)

Starting the machine, it's given the IP address `192.168.1.100`, and the domain suffix `acme.local`.
![](20231101073012.png)

I haven't set the DNS to use the domain controller at `192.168.1.21`, or changed the computer/hostname.
![](20231101073207.png)

![](20231101073412.png)

Connecting to the `ipfire` web interface, it shows that the DHCP service has a record for the new VM.
![](20231101073804.png)


![](20231101080754.png)


join domain
![](20231101085602.png)
![](20231101085654.png)

![](20231101085711.png)
![](20231101085729.png)


![](20231101101335.png)
restart
![](20231101101409.png)
login as mark
![](20231101101451.png)

In the `acme-dc` domain controller, the newly joined `win-1` computer appears in the `ACME.local/Computers` folder.
![](20231101101639.png)

And the user is logged in as mark.
![](20231101101840.png)

I move that `win-1` computer into the Office OU, because it will belong to the office workers.
![](20231101102524.png)