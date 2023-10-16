---
title: 01 Create template-win11 VM
type: docs
prev: 02-template-win11-vm
next: 02 Install OS
---

## Download Free Windows 11 ISO
Microsoft has a [Insider Preview Downloads page](https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewiso) the provides preview ISO files for Windows 11.

For this lab, I'm using the "Windows 11 Client Insider Preview - Build 25951 English" version with the filename `Windows11_InsiderPreview_Client_x64_en-us_25951.iso`.

## Create VM
I use that Windows 11 preview ISO file as the installation media for the VM. 

I give it 8 GB for memory, 2 CPUs, and 75 GB for the disk image. The [minimum requirements](https://www.microsoft.com/en-us/windows/windows-11-specifications) for Windows 11 are 4 GB RAM and 64 GB storage.

### Configure Hardware for Windows
Before I begin the installation process, I check the "Customize configuration before install" box. I want to add some hardware to the VM. Then, I click "Finish".
![pre install check](../pre-install-check.png)

#### Hypervisor Firmware
I change the Hypervisor settings to use the firmware `OVMF_CODE.secboot.fd`. 
![hypervisor firmware](../hypervisor-firmware.png)

#### TPM
I set the TPM to use version 2.0.
![TPM](../tpm.png)

## Begin Installation
That's it for the VM hardware. I click "Begin Installation" to begin installing the Windows 11 operating system.