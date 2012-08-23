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

	$ git clone http://www.github.com/mattandersen/vagrant-lamp
	$ cd vagrant-lamp
	$ vagrant up

That is pretty simple.

Technical Details
-----------------
* Ubuntu 12.04 (Precise Pangolin)
* Apache 2
* PHP 5.3
* MySQL 5.5

* HTTP port: 8888 (i.e. <http://localhost:8888>)
* MySQL port: 8889

I am using the base Ubuntu 12.04 box from Vagrant. If you don't already have it downloaded
the Vagrantfile has been configured to do it for you. This only has to be done once
for each account on your host computer.

The web root is located in the project directory at `htdocs` and you can install your files there

And like any other vagrant file you have SSH access with

	$ vagrant ssh
