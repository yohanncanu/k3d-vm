#!/usr/bin/env bash

# install docker
sudo apt-get update -y
sudo apt-get install docker.io -y
sudo usermod -aG docker vagrant

# install network tools
sudo apt-get install net-tools arping -y

# install git
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update
sudo apt-get install git -y

# sudo cp -r /vagrant/binaries/* /usr/local/bin
# k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
echo 'source <(kubectl completion bash)' >>/home/vagrant/.bashrc
echo "alias k='kubectl'" >>/home/vagrant/.bashrc
echo 'complete -F __start_kubectl k' >>/home/vagrant/.bashrc
# helm
sudo snap install helm --classic
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh
# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
# arkade
curl -sLS https://dl.get-arkade.dev | sudo sh
# k9s
curl -sS https://webinstall.dev/k9s | bash
echo 'export PATH="/home/vagrant/.local/bin:$PATH"' >>/home/vagrant/.bashrc
echo 'EDITOR="code --wait"' >> ~/.bashrc
# istioctl
curl -L https://istio.io/downloadIstio | sh -
echo 'export PATH=$PATH:/home/vagrant/istio-1.12.1/bin' >>/home/vagrant/.bashrc

# go install
curl -Lo go1.17.4.linux-amd64.tar.gz https://go.dev/dl/go1.17.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf go1.17.4.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc

# kn

sudo apt-get install build-essential -y
git clone https://github.com/knative/client.git
cd /home/vagrant/client/
hack/build.sh -f
sudo mkdir -p /usr/local/bin
sudo mv kn /usr/local/bin
# echo 'export PATH=$PATH:/usr/local/bin/kn' >> /home/vagrant/.bashrc
cd /home/vagrant

# *.localhost
sudo apt install libnss-myhostname

# mkcert
sudo apt-get install libnss3-tools -y
git clone https://github.com/FiloSottile/mkcert && cd /home/vagrant/mkcert
go build -ldflags "-X main.Version=$(git describe --tags)"
sudo mv mkcert /usr/local/bin
CAROOT=/vagrant/mkcert/rootca mkcert -install
