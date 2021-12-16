# test docker dns
docker run -it alpine:3.13 ping -c 3 google.com
docker rm -f k3d-registry.localhost
# create registry
k3d registry create registry.localhost --port 5000
cat << EOF > reg-config.yml
mirrors:
  "k3d-registry.localhost:5000":
    endpoint:
      - http://k3d-registry.localhost:5000
EOF
k3d cluster delete local-dev
k3d cluster create local-dev  \
-p "443:443@loadbalancer" \
-p "80:80@loadbalancer" \
-p "8080:8080@loadbalancer" \
-p "8081:30080@loadbalancer" \
-p "8441:30441@loadbalancer" \
--token YtPIwEMJXJebvXfNcZud \
--k3s-arg "--tls-san=kubedev@server:*" \
--k3s-arg "--cluster-domain=mycluster.localhost@server:*" \
--k3s-arg "--disable=traefik@server:*" \
--k3s-arg "--cluster-cidr=10.118.0.0/17@server:*" \
--k3s-arg "--service-cidr=10.118.128.0/17@server:*" \
--servers 1 \
--api-port 6443 \
--agents 3 \
--registry-config reg-config.yml \
--wait


  mkdir -p /home/vagrant/.kube && \
      k3d kubeconfig get local-dev > /home/vagrant/.kube/config && \
      chown -R vagrant:vagrant /home/vagrant/.kube

kubectl config set-context --current --namespace=default

cd /vagrant/mkcert/demo3.example.com
export CERT_NAME=demo3.example.com
export KEY_FILE=demo3.example.com+1-key.pem
export CERT_FILE=demo3.example.com+1.pem
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}

# cd -

helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

helm uninstall ingress-nginx --namespace ingress-nginx