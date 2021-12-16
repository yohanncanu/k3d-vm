# K3D VM on windows

# vagrant VM

* IP : 192.168.56.2
* public_key: ~/.ssh/id_rsa.pub
* user: vagrant

## MacOSX

```bash
brew tap homebrew/cask
brew install --cask vagrant
brew install --cask virtualbox
brew install mkcert
brew install nss

# sudo "/Library/Application Support/VirtualBox/LaunchDaemons/VirtualBoxStartup.sh" restart --> allow in preference security
# restart computer

cp .env.default .env
echo "$(openssl rand -base64 20)" > .vault-pass

# create root cert and copy to project


```

## Both windows and macos

```bash
mkcert -install
mkdir -p sync/mkcert/rootca
rootdir=$PWD
cd "$(mkcert -CAROOT)"
cp -r ./* "$rootdir/sync/mkcert/rootca"
mkdir -p sync/mkcert/demo3.example.com
cd sync/mkcert/demo3.example.com
mkcert demo3.example.com "*.demo3.example.com"
```

## Windows

use `mkcert` to have a root-certificate trusted by all machines on local dev env
```bash 
choco install mkcert

# on the kube host machine
CAROOT=/vagrant/mkcert/rootca mkcert -install


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

## Prepare a domain name and ssl cert



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

