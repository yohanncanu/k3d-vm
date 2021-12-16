
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  required_plugins = %w( vagrant-env vagrant-hostmanager vagrant-vbguest vagrant-vboxmanage)
  required_plugins.each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
  end

  config.env.enable

  config.vbguest.auto_update = false
  config.vbguest.no_remote = true

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  
  MEMORY= ENV['MEMORY']
  CPU= ENV['CPU']
  MACHINE=ENV['MACHINE']
  IP=ENV['IP']
  VAULT_PASS=ENV['VAULT_PASS']

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "#{MEMORY}"
    vb.cpus = "#{CPU}"
    vb.linked_clone = true
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    vb.customize [ "modifyvm", :id, "--nested-hw-virt", "on" ]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

 

  config.vm.define "#{MACHINE}" do |node|
      node.vm.box = "ubuntu/hirsute64"
      node.vm.network :private_network, ip: "#{IP}"
      # node.vm.network :private_network, ip: "10.0.0.11"
      node.vm.network :forwarded_port, guest: 80, host: 80
      node.vm.network :forwarded_port, guest: 8080, host: 8080
      node.vm.network :forwarded_port, guest: 8081, host: 8081
      node.vm.network :forwarded_port, guest: 6443, host: 6443
      node.vm.network :forwarded_port, guest: 443, host: 443
      node.vm.hostname = "#{MACHINE}"
      node.vm.synced_folder "./sync", "/vagrant"
      node.hostmanager.aliases = %w(k3d-registry.localhost blog.demo3.example.com meteo.demo3.example.com www.demo3.example.com demo3.example.com)
      
      node.vm.provision 'shell', inline: "echo #{VAULT_PASS} > /home/vagrant/.vault-pass", privileged: false
      node.vm.provision 'shell', inline: 'mkdir -p /root/.ssh'
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
      node.vm.provision 'shell', inline: "echo #{ssh_pub_key} >> /root/.ssh/authorized_keys"
      node.vm.provision 'shell', inline: "echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys", privileged: false

      config.vm.provision "file", source: "scripts/.", destination: "/home/vagrant"
      # config.vm.provision "shell", path: "scripts/install.sh", privileged: false

      node.vm.provision "ansible_local" do |ansible|
        ansible.become = true
        ansible.playbook = "/vagrant/vagrant.yml"
        ansible.limit = "extmfsapp01*"
        ansible.galaxy_role_file = "/vagrant/ansible/roles-requirements.yml"
        ansible.galaxy_roles_path = "/etc/ansible/roles"
        ansible.extra_vars = "/vagrant/ansible/dev-extra-vars.yml"
        ansible.vault_password_file = "/home/vagrant/.vault-pass"
        ansible.skip_tags = ["docker_build"]
      end
  end

end

