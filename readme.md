# Vagrant LAMP

Want to test a new web app but don't want to affect your current Apache / MySQL / PHP system?
Applications like MAMP are great, but they don't make it easy to maintain multiple, separate
web roots.

If you find yourself needing quick to configure web stack, but also one that is customizable try this Vagrant project

Vagrant allows for Virtual Machines to be quickly setup, and easy to use.

And this project aims to make it very easy to spinup a complete LAMP stack in a matter of minutes.

## Requirements

* VirtualBox <http://www.virtualbox.com>
* Vagrant <http://www.vagrantup.com>
 * [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager) `vagrant plugin install vagrant-hostmanager`

## Usage

Simply copy the file `vagrantfile` to an existing project.

### Startup

	$ git clone http://www.github.com/mattandersen/vagrant-lamp lamp
	$ cd lamp
	$ rm -fr .git
	$ edit vagrantfile # change project_name and ip_address
	$ vagrant up

That is pretty simple.

### Connecting

#### Apache

The Apache server is available at <http://lamp.local/>

#### MySQL

Externally the MySQL server is available at `lamp.local:3306`, and when running on the VM it is available as a socket or at port 3306 as usual.
Username: root
Password: lamp

## Technical Details

* Ubuntu 14.04 LTS 32-bit (for use 64-bit set `VM_ARCH=64`)
* Apache 2
* PHP 5.5 (with apc, memcached, cli, curl, gd, imap, mysql, mcrypt, sqlite, xdebug, xsl, pear)
* MySQL 5.5
* phpmyadmin <http://lamp.local/phpmyadmin/>
* composer

We are using the base Ubuntu 14.04 box from Vagrant. If you don't already have it downloaded
the Vagrantfile has been configured to do it for you. This only has to be done once
for each account on your host computer.

The web root is located in the project directory and you can install your files there.

And like any other vagrant file you have SSH access with:

	$ vagrant ssh

## Default credentials

### General project settings

```ruby
ip_address = "10.10.10.10"
project_name = "lamp" # http://lamp.local
```

### Environment variables

```bash
VM_ARCH=32
VM_MEMORY=512
VM_CORES=1
```
