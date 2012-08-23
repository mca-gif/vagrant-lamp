# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "192.168.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 80, 8888
  config.vm.forward_port 3306, 8889

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.share_folder "htdocs", "/var/www", "htdocs"

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding 
  # some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
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
	chef.add_recipe "apache2::mod_php5"
	chef.add_recipe "apache2::mod_rewrite"

	chef.json = {
		:apache => {
			:user => "vagrant",
			:group => "vagrant"
		},
		:mysql => {
			:server_root_password => "root",
			:allow_remote_root => true
		}
	}
  end
end
