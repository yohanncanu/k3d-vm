# K3D VM on windows


# vagrant VM

* IP : 192.168.63.11
* public_key: ~/.ssh/id_rsa.pub
* user: vagrant

## Prepare a domain name and ssl cert

use `mkcert` to have a root-certificate trusted by all machines on local dev env
```bash 
choco install mkcert
mkcert -install
mkdir -p sync/mkcert/rootca
rootdir=$PWD
cd "$(mkcert -CAROOT)"
cp -r ./* "$rootdir/sync/mkcert/rootca"
mkdir -p sync/mkcert/demo3.example.com
cd sync/mkcert/demo3.example.com
mkcert demo3.example.com "*.demo3.example.com"
# on the kube host machine
CAROOT=/vagrant/mkcert mkcert -install


# fix dns on netplan
sudo cat << EOF > /etc/netplan/50-vagrant.yaml
---
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      addresses:
      - 192.168.10.11/24
      nameservers:
          addresses: [1.1.1.1, 1.0.0.1]
EOF

```

## check scripts/install-tools.sh to install all fancy tools

## check scripts/install-cluster.sh to create k3d cluster

## on windows box

* choco install mkcert
* mkcert -install
* copy root-CA cert to sync/mkcert
* copy result of `ssh vagrant@kubedev k3d kubeconfig get local-dev`

## Test ingress, nodeport, loadbalancer

## vm network

* connect to host laptop
* connect to internet
* connect to a private network with other vm if needed

need a host only network

