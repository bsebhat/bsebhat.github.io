---
title: 04 VM Info Display
type: docs
---

As I create other VMs by cloning the template VM, it would be nice to have a way of quickly seeing the VM's hostname and IPv4 address. I can install the tool `conky` to display this information on the desktop.

```
sudo dnf -y conky
```

If I run `conky` in the terminal, the desktop will display system information about things like RAM and CPU usage.

I'll create a `.conkyrc` configuration file in my home directory that displays the NIC device `enp1s0` IP address, and the hostname:
```
conky.config = {
        update_interval = 1,
        font = 'DejaVu Sans Mono:size=18',
        own_window_hints = 'undecorated, skip_taskbar, skip_pager',
        own_window = true,
        alignment = 'top_left',
        use_xft = true,
        background = false
};

conky.text = [[${color yellow}Hostname:$color ${exec hostname}  ${color yellow}IP Address:$color ${addr enp1s0}]];
```

To get `conky` to run on startup, I need to install `gnome-tweaks`.

```
sudo dnf install -y gnome-tweaks
```

Then run `gnome-tweaks` from the Utilities and add `conky` to the Startup Applications.


