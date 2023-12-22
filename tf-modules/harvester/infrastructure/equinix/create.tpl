#cloud-config
scheme_version: 1
token: "${token}"
os:
  ssh_authorized_keys:
  - "${ssh_key}"
  password: "${password}"
  hostname: "${hostname_prefix}-${count}"
  write_files:
  - content: |
      #!/usr/bin/env bash
      modprobe 8021q
      echo "8021q" >> /etc/modules
      ip link set down enp1s0f1
      ip -d link show enp1s0f1
      ip link set enp1s0f1 nomaster
      ip addr add 192.168.1.${count +2} dev enp1s0f1
      ip link set dev enp1s0f1 up
      ip -d link show enp1s0f1
      ip route add 192.168.1.0/24 dev enp1s0f1
    path: /home/rancher/enp1s0f1-setup.sh
    permissions: '0744'
#  after_install_chroot_commands:
#    - "sudo modprobe 8021q"
#    - "sudo echo '8021q' >> /etc/modules"
#    - "sudo ip link set down enp1s0f1"
#    - "sudo ip link set enp1s0f1 nomaster"
#    - "sudo ip addr add 192.168.1.${count +2} dev enp1s0f1"
#    - "sudo ip link set dev enp1s0f1 up"
#    - "sudo ip route add 192.168.1.0/24 dev enp1s0f1"
install:
  mode: create
  device: /dev/sda
  iso_url: https://releases.rancher.com/harvester/${version}/harvester-${version}-amd64.iso
  tty: ttyS1,115200n8
  vip: ${vip}
  vip_mode: static

%{ if cluster_registration_url != "" }
system_settings:
  cluster-registration-url: ${cluster_registration_url}
%{ endif }
