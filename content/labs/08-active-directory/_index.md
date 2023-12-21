---
title: Lab 08 - Active Directory
type: docs
next: 01-setup-lan-network
---

## Diagrams
Diagrams for the acme.local Active Directory domain

### Network
![network diagram](../diagrams/active-directory.drawio.png)

### Users and Groups
![users diagram](../diagrams/acme-users-groups.drawio.png)


## Lab Steps
1. Setup lan network
2. Create acme-dc: Windows Server VM with Active Directory domain ACME.local
3. Create ipfire firewall: Linux VM with ipfire firewall server
4. Create domain users: create domain users and groups
5. Add alpha VM: a VM with Windows 11 installed, joined to the ACME.local domain
6. Add bravo VM: a VM with Fedora Linux installed, joined to the ACME.local domain
7. Share files on acme-dc: Create folders and share them with different domain groups.