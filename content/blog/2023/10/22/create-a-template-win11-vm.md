---
title: Create A Template Win11 VM
date: 2023-10-22T03:06:00
---

I'm creating a template VM with the Windows 11 OS installed. When I want to add a Windows 11 desktop VM to a lab, I can clone this template and make small changes, like changing the computer/host name

## Windows Is Tricky
Because this isn't an open source operating system like Linux or UNIX, I may have to add a few special steps when installing Windows. I'm going to be using the Windows preview edition from that ["Windows Insider"](https://www.microsoft.com/en-us/windowsinsider/) program. And I won't be registering it, so some of the settings will be limited. And I don't want to have to register with Microsoft's online account, so the installation process will have a couple workarounds.

## VM Lab Environment
I will be using the `virt-manager` software to manage the VM. I'll create a VM called `template-win11`, and give it 75 GB storage and 4 GB memory. The [Windows 11 minimum hardware requirements](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements#hardware-requirements) are 4 GB memory and 64 GB storage.


## Download Free Windows 11 ISO
Microsoft has a [Insider Preview Downloads page](https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewiso) the provides preview ISO files for Windows 11.

For this lab, I'm using the "Windows 11 Client Insider Preview - Build 25951 English" version with the filename `Windows11_InsiderPreview_Client_x64_en-us_25951.iso`.

## Create VM
I use that Windows 11 preview ISO file as the installation media for the VM. 

I give it 8 GB for memory, 2 CPUs, and 75 GB for the disk image. The [minimum requirements](https://www.microsoft.com/en-us/windows/windows-11-specifications) for Windows 11 are 4 GB RAM and 64 GB storage.

### Configure Hardware for Windows
Before I begin the installation process, I check the "Customize configuration before install" box. I want to add some hardware to the VM. Then, I click "Finish".
![pre install check](../win11-screenshots/pre-install-check.png)

#### Hypervisor Firmware
I change the Hypervisor settings to use the firmware `OVMF_CODE.secboot.fd`. 
![hypervisor firmware](../win11-screenshots/hypervisor-firmware.png)

#### TPM
I set the TPM to use version 2.0.
![TPM](../tpm.png)

## Install Windows 11 OS
That's it for the VM hardware. I click "Begin Installation" to begin installing the Windows 11 operating system. I follow the normal Windows 11 installation process, but I do change some things so that I don't need to use online accounts with this VM template.

## Activate Windows
For the `Activate Windows` stage, I give a generic product key for Windows 11 Pro, found [here](https://www.elevenforum.com/t/generic-product-keys-to-install-or-upgrade-windows-11-editions.3713/).

## Install Windows
![install windows only](../win11-screenshots/install-windows-only.png)
I go through the normal process of installing Windows, choosing the "Custom: Install Windows only" option, then installing on the VM's drive.

## Disable Internet After Reboot
The install will go through its normal installation process of installing files, and rebooting.
![installing files](../win11-screenshots/installing-files.png)

However, after rebooting, I don't want to use a Microsoft account for the VM. I found a guide for getting around that on the [Tom's Hardware blog](https://www.tomshardware.com/how-to/install-windows-11-without-microsoft-account) and a couple other forums.

When you get to the screen asking for country or origin, now is the time to stop Windows from forcing you to have an internet connection to continue the installation process. Use `Shift+F10` to have the command prompt appear.
![command prompt](../win11-screenshots/command-prompt.png)

Run `OOBE\BYPASSNRO` in the command prompt. THe VM will reboot.

When it comes back, you'll see the same screen about country or origin. Just use `Shift+F10` again to get back to the command prompt.

This time, run `ipconfig /release` in the command prompt to disable the VM's internet connection.
![windows turn off internet](../win11-screenshots/windows-turn-off-internet.png)

Now, you can close the command prompt and continue choosing the country or region, then the keyboard layout, 

But now, when you get to the internet connection screen, you get the option of "I don't have internet".
![no internet option](../win11-screenshots/no-internet-option.png)

That's a lot of work to avoid creating a Microsoft account. It's kind of the reason why I want to have a Windows 11 template VM that I can clone.

## Create User Account
Now, I'll give it a user account with something like "VM Admin". When I clone it, I can create different accounts for the different labs.
![user account](../win11-screenshots/user-account.png)

The rest is just security questions and privacy settings.

## Installation Completed
After the installation process, the Windows 11 OS should be installed and working.
![installed win11](../win11-screenshots/installed-win11.png)

There are some restrictions, because it's a preview/evaluation copy. Like you can't change some personalization settings.

## Create Post-Install Snapshot
I think it's a good idea to create a VM snapshot after Windows 11 has been installed.

## Post Install Configuration

### Enable Shared Clipboard
To enable the Windows 11 VM to share the host computer's clipboard, I install the latest spice-guest-tools executable from the website [https://spice-space.org/download/windows/spice-guest-tools/](https://spice-space.org/download/windows/spice-guest-tools/).


### Configure Desktop and Taskbar
I change the taskbar and sleep/lock settings, and add the settings and Powershell app to the taskbar.

### Change Hostname
Windows 11 gave the VM a random desktop name, "Desktop-1b1ektn". So I change it to template-win11. It's not really necessary, because I'll have to change it when I create the clone VM.

### Create Firewall Rule To Allow Pings
I'm going to use the VM in virtual networks, so I want its firewall configured to allow it to receive ICMP echo ping requests. I'll use the Powershell to configure the firewall. This requires me to run it as Administrator.

The Powershell command to allow incoming ICMP pings is:
```Powershell
New-NetFirewallRule `
    -Name AllowPing `
    -DisplayName "Allow ICMP Echo Request" `
    -Protocol ICMPv4 `
    -IcmpType 8 `
    -Action Allow `
    -Enabled True
```

You can test that it accepts ICMP pings by getting its IPv4 IP address, and pinging it from your host computer. It should be accessible to the host computer, because they are both connected to the default virtual network.

## Test Template By Creating Clone
To test the `template-win11` clone. I'll clone it to a new VM called `win11-clone`. It gets a new IP address via the default network's DHCP service, and I'm able to ping it from my host machine.

## Conclusion
So, I was able to create a template Windows 11 desktop VM. I can use it in other labs, without having to install Windows 11 again.