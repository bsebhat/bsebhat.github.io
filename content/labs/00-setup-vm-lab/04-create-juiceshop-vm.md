---
title: 04 Create juiceshop VM
type: docs
---

## Setup juiceshop VM 
The VM creation process is basically the same as with sysadmin, except for two installation steps: Software Selection and Network & Host Name

### Software Selection
Instead of selecting "Workstation" like I did with `sysadmin`, I'll just choose "Server". It won't have a GNOME desktop environment, but I'll be using the `sysadmin` VM to manage the server via SSH. By default, it will have the SSH service installed.

### Network & Host Name
Instead of using DHCP to receive a leased IP address, I'll give `juiceshop` a static IP address of `192.168.122.10`. I'll use the same `192.168.122.1` for the gateway and DNS server settings.

After the CentOS installation has finished, I click "Reboot System". From now on, I'll be using the `sysadmin` to install the OWAS Juice Shop web application.

## Add juiceshop host name to default Network DNS
Because the `sysadmin` VM used the DHCP service to request an IP address, its hostname is registered in the DNS service used by the default network: dnsmasq.


But I gave the `juiceshop` VM a static IP address. So I'll need to enter the hostname by editing the `default` network's definition. Like before where I modified the DHCP range, I'll use the `virsh net-edit` command.

Before editing the network, I'll shutdown the VMs and close the virt-manager application. I haven't found a way to change a network definition while the VMs are running and connected.

To change the `default` network definition to use the `juiceshop` static IP address of `192.168.122.10`, I'll add a `<dns>` element, with a `<host ip="192.168.122.10">` element that includes a `<hostname>juiceshop</hostname>` element:
```xml
<dns>
    <host ip="192.168.122.10">
        <hostname>juiceshop</hostname>
    </host>
</dns>
```

I'll "destroy" (stop) the network:
```
sudo virsh net-destroy default
```

And start it again:

```
sudo virsh net-start default
```

Then, I'll open `virt-manager` again and start the VMs. Now, I can ping the `juiceshop` VM from the `sysadmin` VM using its host name. Previously, I could only do that using its IP address.