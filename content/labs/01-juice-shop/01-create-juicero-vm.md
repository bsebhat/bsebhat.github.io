---
title: 01 Create juicero VM
type: docs
---

## Setup juiceshop VM 
The VM creation process is basically the same as with sysadmin, except for two installation steps: Software Selection and Network & Host Name

### Software Selection
Instead of selecting "Workstation" like I did with `sysadmin`, I'll just choose "Server". It won't have a GNOME desktop environment, but I'll be using the `sysadmin` VM to manage the server via SSH. By default, it will have the SSH service installed.

### Network & Host Name
Instead of using DHCP to receive a leased IP address, I'll give `juiceshop` a static IP address of `192.168.122.10`. I'll use the same `192.168.122.1` for the gateway and DNS server settings.

After the CentOS installation has finished, I click "Reboot System". From now on, I'll be using the `sysadmin` to install the OWAS Juice Shop web application.

## Change Console Font
I want the font to be larger.

I'll install the Extra Packages for Enterprise Linux (EPEL):
```
sudo yum install -y epel-release
```

I install the terminus font:
```
sudo yum install -y terminus-fonts-console.noarch
```

Then, I'll find the available terminus fonts:
```
ls /usr/lib/kbd/consolefonts/ter-*
```

I'll try the `ter-224b` font:
```
setfont ter-224b
```

I like it, so I edit the FONT line in `/etc/vconsole.conf`:
```
FONT=ter-224b
```

And rebuild the initramfs:
```
sudo dracut -f
```

Now, when I reboot, the console font is larger. I'll be using the server via SSH most of the time. Sometimes, I'll need to configure network settings on the `juiceshop` VM terminal. So a larger console font will be helpful.


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

## SSH from sysadmin to juiceshop
Most of the time I will be using SSH to manage the `juiceshop` VM from the `sysadmin`. I could also do that from my my host machine (laptop) using the `juiceshop` IP address.

From a terminal on `sysadmin`, to SSH into `juiceshop` using the user account I created during installation, `vmadmin`:
```
ssh vmadmin@juiceshop
```

It asks me if I'm sure if I want to connect to juiceshop, because I haven't connected and it's not in the `sysadmin` list of known hosts yet. I say yes, and enter the vmadmin password.

Now, I can work on installing software on the `juiceshop` server. In the next lap, I'll install the vulnerable web application Juice Shop, and create a service so that it starts automatically when the `juiceshop` VM starts.