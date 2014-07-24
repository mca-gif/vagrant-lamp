# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "ubuntu/trusty64"

	config.vm.network "forwarded_port", guest: 80, host: 8888
	config.vm.network "forwarded_port", guest:3306, host: 8889

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "htdocs", "/var/www"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  config.vm.provision "chef_solo" do |chef|
		chef.cookbooks_path = "chef/cookbooks"
		chef.roles_path = "chef/roles"
		chef.data_bags_path = "chef/data_bags"

		chef.add_recipe "apt"
		chef.add_recipe "build-essential"
		chef.add_recipe "ubuntu"
		chef.add_recipe "apache2"
		chef.add_recipe "mysql::client"
		chef.add_recipe "mysql::server"
		chef.add_recipe "php"
		chef.add_recipe "php::module_curl"
		chef.add_recipe "php::module_mysql"
		chef.add_recipe "apache2::mod_php5"
		chef.add_recipe "apache2::mod_rewrite"
		chef.add_recipe "lamp"

		# You may also specify custom JSON attributes:
		chef.json = { :mysql_password => "foo" }
	end
end
