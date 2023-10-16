---
title: Lab 02 - Template Windows 11 VM
type: docs
next: 01-create-template-win11-vm
---

## Intro
This is a lab very similar to the lab 01 where I created an Arch Linux template VM.

## Why?
Same reason as the other VM template lab. Installing an operating system on a VM takes time. While Windows 11 is easier to install, I still don't like all the steps it takes. So, I'll create a template VM and clone it whenever I want to use a Windows 11 VM.

## Windows Is Tricky
Because this isn't an open source operating system like Linux or UNIX, I may have to add a few special steps when installing Windows. I'm going to be using the Windows preview edition from that ["Windows Insider"](https://www.microsoft.com/en-us/windowsinsider/) program. And I won't be registering it, so some of the settings will be limited. And I don't want to have to register with Microsoft's online account, so the installation process will have a couple workarounds.

## VM Lab Environment
I will be using the `virt-manager` software to manage the VM. I'll create a VM called `template-win11`, and give it 75 GB storage and 4 GB memory. The [Windows 11 minimum hardware requirements](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-requirements#hardware-requirements) are 4 GB memory and 64 GB storage.