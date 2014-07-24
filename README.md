Vagrant LAMP
============

Want to test a new web app but don't want to affect your current Apache / MySQL / PHP system?
Applications like MAMP are great, but they don't make it easy to maintain multiple, separate
web roots.

If you find yourself needing quick to configure web stack, but also one that is customizable try this Vagrant project

Vagrant allows for Virtual Machines to be quickly setup, and easy to use.

And this project aims to make it very easy to spinup a complete LAMP stack in a matter of minutes.

Requirements
------------
* VirtualBox <http://www.virtualbox.com>
* Vagrant <http://www.vagrantup.com>
* Git <http://git-scm.com/>

Usage
-----

### Startup
	$ git clone http://www.github.com/mattandersen/vagrant-lamp
	$ cd vagrant-lamp
	$ vagrant up

That is pretty simple.

### Connecting

#### Apache
The Apache server is available at <http://localhost:8888>

#### MySQL
Externally the MySQL server is available at port 8889, and when running on the VM it is available as a socket or at port 3306 as usual.
Username: root
Password: root

Technical Details
-----------------
* Ubuntu 14.04 64-bit
* Apache 2
* PHP 5.5
* MySQL 5.5

We are using the base Ubuntu 14.04 box from Vagrant. If you don't already have it downloaded
the Vagrantfile has been configured to do it for you. This only has to be done once
for each account on your host computer.

The web root is located in the project directory at `htdocs` and you can install your files there

And like any other vagrant file you have SSH access with

	$ vagrant ssh

Maintenance
-----------
### Included Chef Cookbooks
- https://github.com/onehealth-cookbooks/apache2
- https://github.com/opscode-cookbooks/apt
- https://github.com/opscode-cookbooks/build-essential
- https://github.com/opscode-cookbooks/php
- https://github.com/opscode-cookbooks/mysql
- https://github.com/opscode-cookbooks/ubuntu

### Included To Satisfy Dependancies
The new cookbooks have a lot more required dependancies, and Chef will fail if they are not present. They are included to make installation go smoothly, and because editing out the dependancies would make maintenance more difficult.
- https://github.com/cookbooks/logrotate
- https://github.com/cookbooks/pacman
- https://github.com/opscode-cookbooks/chef_handler
- https://github.com/opscode-cookbooks/freebsd
- https://github.com/opscode-cookbooks/iis
- https://github.com/opscode-cookbooks/iptables
- https://github.com/opscode-cookbooks/windows
- https://github.com/opscode-cookbooks/xml
- https://github.com/opscode-cookbooks/yum
- https://github.com/opscode-cookbooks/yum-epel
- https://github.com/opscode-cookbooks/yum-mysql-community
- https://github.com/sethvargo/chef-sugar
