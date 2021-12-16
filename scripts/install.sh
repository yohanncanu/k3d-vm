#!/usr/bin/env bash

cd /home/vagrant/
sudo chmod  +x *.sh

# fix dns on netplan
cat << EOF > 50-vagrant.yaml
---
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      addresses:
      - 192.168.10.2/24
      nameservers:
          addresses: [1.1.1.1, 1.0.0.1]
EOF
sudo chown root:root 50-vagrant.yaml
sudo chmod 644 50-vagrant.yaml
sudo mv 50-vagrant.yaml /etc/netplan

exec /home/vagrant/install-tools.sh
exec /home/vagrant/install-cluster.sh
exec /home/vagrant/load-docker-images.sh