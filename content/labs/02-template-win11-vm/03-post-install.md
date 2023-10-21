---
title: 03 Post Install
type: docs
---

After Windows 11 was installed on the `template-win11` VM, I can configure the template so that certain programs and settings are available on the clone VMs.

## Enable Shared Clipboard
To enable the Windows 11 VM to share the host computer's clipboard, I install the latest spice-guest-tools executable from the website [https://spice-space.org/download/windows/spice-guest-tools/](https://spice-space.org/download/windows/spice-guest-tools/).


## Configure Desktop and Taskbar
I change the taskbar and sleep/lock settings, and add the settings and Powershell app to the taskbar.

## Change Hostname
Windows 11 gave the VM a random desktop name, "Desktop-1b1ektn". So I change it to template-win11. It's not really necessary, because I'll have to change it when I create the clone VM.

## Configure Firewall To Allow Pings
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