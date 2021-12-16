# --k3s-arg '--flannel-backend=none@server:*' \
# --k3s-arg "--cluster-cidr=10.118.0.0/17@server:*" \
# --k3s-arg "--service-cidr=10.118.128.0/17@server:*" \
  # podSubnet: "10.240.0.0/16"
  # podSubnet: 192.168.0.0/16 # set to Calico's default subnet
  # serviceSubnet: "10.0.0.0/16"
# --k3s-arg "--tls-san=kubedev@server:*" \
# --volume "$(pwd)/docs/usage/guides/calico.yaml:/var/lib/rancher/k3s/server/manifests/calico.yaml"
# --no-lb 
# --volume /etc/resolv.conf:/etc/resolv.conf@server:0 \
# --registry-use k3d-registry.localhost:5000 \

# https://k3d.io/v5.0.0/usage/advanced/calico/
# https://projectcalico.docs.tigera.io/master/reference/cni-plugin/configuration
# "container_settings": {
#     "allow_ip_forwarding": true
# }


# --k3s-arg "--cluster-domain=cluster.local@loadbalancer" \

# istioctl install --set profile=demo -y
# k apply -f https://github.com/knative/operator/releases/download/knative-v1.0.0/operator.yaml

# k apply -f https://k3d.io/v5.0.0/usage/advanced/calico.yaml