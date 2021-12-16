#!/usr/bin/env bash
sudo apt-get update -y
sudo chmod  +x *.sh

sudo apt-get install docker.io -y
sudo usermod -aG docker vagrant
# exit/login or newgrp docker

sudo apt-get install net-tools arping -y

# install git
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update -y
sudo apt-get install git -y

# to gcc build ... 
sudo apt-get install build-essential -y

# *.localhost
sudo apt install libnss-myhostname

# for mkcert
sudo apt-get install libnss3-tools -y


# go install
curl -Lo go1.17.4.linux-amd64.tar.gz https://go.dev/dl/go1.17.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go1.17.4.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# install mkcert
git clone https://github.com/FiloSottile/mkcert && cd /home/vagrant/mkcert
go build -ldflags "-X main.Version=$(git describe --tags)"
sudo mv mkcert /usr/local/bin
CAROOT=/vagrant/mkcert/rootca mkcert -install

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
echo 'source <(kubectl completion bash)' >>/home/vagrant/.bashrc
echo "alias k='kubectl'" >>/home/vagrant/.bashrc
echo 'complete -F __start_kubectl k' >>/home/vagrant/.bashrc
source /home/vagrant/.bashrc

# k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# helm
sudo snap install helm --classic

# k9s
curl -sS https://webinstall.dev/k9s | bash
echo 'export PATH="/home/vagrant/.local/bin:$PATH"' >>/home/vagrant/.bashrc
echo 'EDITOR="code --wait"' >> ~/.bashrc
source /home/vagrant/.bashrc

cd /home/vagrant
docker run -it alpine:3.13 ping -c 3 google.com

k3d cluster create local-dev  \
-p "443:443@loadbalancer" \
-p "80:80@loadbalancer" \
-p "8080:8080@loadbalancer" \
-p "8081:30080@loadbalancer" \
-p "8441:30441@loadbalancer" \
--k3s-arg "--disable=traefik@server:*" \
--servers 1 \
--api-port 6443 \
--agents 3 \
--registry-config reg-config.yml \
--wait

mkdir /vagrant/work
cd /vagrant/work
git clone https://github.com/yohanncanu/kube-basic-demo.git
cd kube-basic-demo

sudo mkdir -p /etc/docker
sudo su -
echo '{ "insecure-registries": [ "k3d-registry.localhost:5000"]}' > /etc/docker/daemon.json
sudo systemctl restart docker

# mkdir -p sync/mkcert/demo3.example.com
# cd sync/mkcert/demo3.example.com
# mkcert demo3.example.com "*.demo3.example.com"