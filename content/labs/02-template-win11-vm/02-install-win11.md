---
title: 02 Install Windows 11
type: docs
---

I follow the normal Windows 11 installation process, but I do change some things so that I don't need to use online accounts with this VM template.

## Activate Windows
For the `Activate Windows` stage, I give a generic product key for Windows 11 Pro, found [here](https://www.elevenforum.com/t/generic-product-keys-to-install-or-upgrade-windows-11-editions.3713/).

## Install Windows
![install windows only](../install-windows-only.png)
I go through the normal process of installing Windows, choosing the "Custom: Install Windows only" option, then installing on the VM's drive.

## Disable Internet After Reboot
The install will go through its normal installation process of installing files, and rebooting.
![installing files](../installing-files.png)

However, after rebooting, I don't want to use a Microsoft account for the VM. I found a guide for getting around that on the [Tom's Hardware blog](https://www.tomshardware.com/how-to/install-windows-11-without-microsoft-account) and a couple other forums.

When you get to the screen asking for country or origin, now is the time to stop Windows from forcing you to have an internet connection to continue the installation process. Use `Shift+F10` to have the command prompt appear.
![command prompt](../command-prompt.png)

Run `OOBE\BYPASSNRO` in the command prompt. THe VM will reboot.

When it comes back, you'll see the same screen about country or origin. Just use `Shift+F10` again to get back to the command prompt.

This time, run `ipconfig /release` in the command prompt to disable the VM's internet connection.
![windows turn off internet](../windows-turn-off-internet.png)

Now, you can close the command prompt and continue choosing the country or region, then the keyboard layout, 

But now, when you get to the internet connection screen, you get the option of "I don't have internet".
![no internet option](../no-internet-option.png)

That's a lot of work to avoid creating a Microsoft account. It's kind of the reason why I want to have a Windows 11 template VM that I can clone.

## Create User Account
Now, I'll give it a user account with something like "VM Admin". When I clone it, I can create different accounts for the different labs.
![user account](../user-account.png)

The rest is just security questions and privacy settings.

## Installation Completed
After the installation process, the Windows 11 OS should be installed and working.
![installed win11](../installed-win11.png)

There are some restrictions, because it's a preview/evaluation copy. Like you can't change some personalization settings.

## Create Post-Install Snapshot
I think it's a good idea to create a VM snapshot after Windows 11 has been installed.