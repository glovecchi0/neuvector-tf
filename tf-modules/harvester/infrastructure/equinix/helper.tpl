#!/bin/bash

sudo useradd -s /bin/bash -d /home/rancher/ -m -G sudo rancher
sudo sh -c "echo 'rancher ALL=NOPASSWD: ALL' >> /etc/sudoers"
sudo mkdir /home/rancher/.ssh/
sudo chmod 0700 /home/rancher/.ssh/
sudo -- sh -c "echo '${ssh_key}' > /home/rancher/.ssh/authorized_keys"
sudo chown -R rancher:rancher /home/rancher/.ssh/

sudo modprobe 8021q
sudo echo "8021q" >> /etc/modules
sudo ip link set down enp1s0f1
#sudo ip -d link show enp1s0f1
sudo ip link set enp1s0f1 nomaster
sudo ip addr add 192.168.1.${count} dev enp1s0f1
sudo ip link set dev enp1s0f1 up
#sudo ip -d link show enp1s0f1

sudo apt-get update

sleep 5s
sudo apt install kea-dhcp4-server -y
cat >> /etc/kea/kea-dhcp4.conf <<EOF
{
  "Dhcp4": {
    "interfaces-config": {
    "interfaces": [ "enp1s0f1" ]
    },
    "control-socket": {
        "socket-type": "unix",
        "socket-name": "/run/kea/kea4-ctrl-socket"
    },
    "lease-database": {
        "type": "memfile",
        "lfc-interval": 3600
    },
    "valid-lifetime": 600,
    "max-valid-lifetime": 7200,
    "subnet4": [
    {
        "id": 1,
        "subnet": "192.168.1.0/24",
        "pools": [
        {
            "pool": "192.168.1.10 - 192.168.1.100"
        }
        ],
        "option-data": [
        {
            "name": "routers",
            "data": "192.168.1.${count}"
        },
        {
            "name": "domain-name-servers",
            "data": "192.168.1.${count}"
        },
        {
            "name": "domain-name",
            "data": "mydomain.example"
        }
        ]
    }
    ]
  }
}
EOF

sleep 5s
sudo apt install bind9 -y
cat >> /etc/bind/named.conf.options <<EOF
options {
        directory "/var/cache/bind";
        allow-query {
            any;
        };
        forwarders {
                 147.75.207.207; #Equinix dns server1
                 147.75.207.208; #Equinix dns server2
                 1.1.1.1; #Cloudflare
                 8.8.8.8; #Google
        };
        dnssec-validation auto;
        listen-on-v6 { any; };
};
EOF

sleep 5s
sudo apt install squid -y
cat >> /etc/squid.conf <<EOF
acl SSL_ports port 443
http_access allow localhost manager
http_access deny manager
include /etc/squid/conf.d/*.conf
http_access allow localhost
http_access allow all
http_access deny all
http_port 3128
EOF
