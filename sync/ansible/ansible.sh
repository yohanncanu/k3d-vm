
cd /vagrant && sudo ansible-playbook provision.yml \
    -i ansible/inventory  \
    --verbose  \
    --vault-id ~/.vault-pass