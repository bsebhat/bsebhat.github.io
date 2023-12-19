---
title: 05 Create Server Template
type: docs
---

I may want server VMs that don't run the GNOME desktop when they start. I'll just be starting them up, and managing them via SSH from a workstation VM.

## Clone template-centos
I'll clone the `template-centos` VM to create a `template-centos-server`.

## Change hostname to template-centos-server
I'll change the hostname from `template-centos` to `template-centos-server`
```
sudo hostnamectl set-hostname template-centos-server
```

## Add Script Setting Static IP
I'll be setting the static IP, DNS, and gateway for server VMs from the console. The network service that manages the NIC is `NetworkManager`. The command line tool for making changes to the connection is `nmcli`.

To make it easier to change the static IP, I add a bash script to the home directory.
```
vim ~/set-static-ip.sh
```

```bash
#!/bin/bash

# Ensure the script is run as root or with sudo
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script with sudo or as root"
   exit 1
fi

# Provide default values
default_conn_name="enp1s0"
# connection name may be "Wired Connection 1" for other distros

default_cidr="24"

# Prompt the user for input
read -p "Enter NetworkManager connection name [${default_conn_name}]: " conn_name
conn_name=${conn_name:-$default_conn_name}

read -p "Enter Static IP address: " ip_addr
read -p "Enter CIDR (subnet mask, e.g., 24 for 255.255.255.0) [${default_cidr}]: " cidr
cidr=${cidr:-$default_cidr}

# Extract network part of the IP to generate default gateway and DNS values
IFS='.' read -ra ADDR <<< "$ip_addr"
default_gateway="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1"
default_dns="$default_gateway"

read -p "Enter default gateway [${default_gateway}]: " gateway
gateway=${gateway:-$default_gateway}

read -p "Enter preferred DNS [${default_dns}]: " dns
dns=${dns:-$default_dns}

# Use nmcli to set the static IP
nmcli con mod "$conn_name" ipv4.addresses "${ip_addr}/${cidr}"
nmcli con mod "$conn_name" ipv4.gateway "$gateway"
nmcli con mod "$conn_name" ipv4.dns "$dns"
nmcli con mod "$conn_name" ipv4.method manual

# Bring the connection up to apply the changes
if nmcli con up "$conn_name"; then
    # If successful, show the device details filtered for IP4
    nmcli device show | grep "IP4"
else
    # Otherwise, print an error message
    echo "Failed to apply changes. Please check your input and try again."
fi
```

I'll make it executable:
```
chmod +x ./set-static-ip.sh
```

Now, I can run `sudo ~/set-static-ip.sh` to set the static IP address and change the DNS or gateway address.

To test it, I run the script and set the static IP to `192.168.122.2`:
```
[vmadmin@template-centos-server ~]$ sudo ./set-static-ip.sh 
[sudo] password for vmadmin: 
Enter NetworkManager connection name [enp1s0]: 
Enter Static IP address: 192.168.122.2
Enter CIDR (subnet mask, e.g., 24 for 255.255.255.0) [24]:   
Enter default gateway [192.168.122.1]: 
Enter preferred DNS [192.168.122.1]: 
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/9)
IP4.ADDRESS[1]:                         192.168.122.2/24
IP4.GATEWAY:                            192.168.122.1
IP4.ROUTE[1]:                           dst = 192.168.122.0/24, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = 192.168.122.1, mt = 100
IP4.DNS[1]:                             192.168.122.1
IP4.ADDRESS[1]:                         127.0.0.1/8
IP4.GATEWAY:                            --

```

I can run the `template-centos` and ping that new static IP address for `template-centos-server`:
```
ping 192.168.122.2
```

### Static IP DNS Issue
But I can't ping the hostname `template-centos-server`. I can ping `template-centos` from `template-centos-server`. That's because `template-centos` got its IP address from the DHCP service, which registers the hostname with the IP address in the DNS service at `192.168.122.1`.

If a VM has a static IP, the hostname will need to be added manually to the network device connecting it to other VMs. In the case of the `default` virtual network, this can be done by changing the definition in its XML file.

In other labs, when using a firewall server, you can add the static IP and hostname through the web GUI admin tool and configure the firewall DHCP service to register leased IP addresses with the DNS service.

Using the `virsh net-edit` command, I can add a `<host>` entry with the IP address to `<dns>`, with a `<hostname>`:
```xml
<network connections='2'>
  <name>default</name>
  <uuid>8dc19f4a-87d8-45ea-b8cb-ceaeeb19dc61</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:36:d3:73'/>
  <dns>
    <host ip='192.168.122.2'>
      <hostname>template-centos-server</hostname>
    </host>
  </dns>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.100' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

After editing the `default` network's definition, you can restart it by using the `virsh net-destroy` and `virsh net-start` commands:
```
sudo virsh net-destroy default
```
```
sudo virsh net-start default
```

After restarting the VMs, the `template-centos-server` can be pinged by its hostname.

The static IP and hostname should appear in the `/var/lib/libvirt/dnsmasq/default.addnhosts` file.

## Disable gdm Service
Next, I'll disable the service that starts the GUI when the VM starts:
```
sudo systemctl disable gdm
```
When I reboot, the console will be used to login a user.

## Change Console Font
I want the font to be larger. I install the terminus font:
```
sudo yum install epel-release
sudo yum install terminus-fonts-console.noarch
```

Then, I'll list the available terminus fonts:
```
ls /usr/lib/kbd/consolefonts/ter-*
```

I'll try the `ter-224b` font:
```
setfont ter-224b
```

I like it, so I edit the `/etc/vconsole.conf` file:
```
FONT=ter-224b
```

And rebuild the initramfs:
```
sudo dracut -f
```

Now, when I reboot, the console font is larger. I'll be using the server via SSH most of the time. Sometimes, I'll need to clone a new server and set the hostname and IP address in the beginning.

In the next lab, I'll create a server that runs the OWASP Juice Shop web application. But I'll be using a workstation VM most of the time, and installing the web application via SSH.