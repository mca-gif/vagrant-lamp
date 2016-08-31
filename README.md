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
* VirtualBox <http://www.virtualbox.org>
* Vagrant <http://www.vagrantup.com>
* Git <http://git-scm.com/>

Usage
-----

### Startup

1. Download one of the releases available [https://github.com/mattandersen/vagrant-lamp/releases](https://github.com/mattandersen/vagrant-lamp/releases)
2. Extract the ZIP file.
3. From the command-line:
```
$ cd vagrant-lamp-release
$ vagrant up
```
That is pretty simple.

### Connecting

#### Apache
The Apache server is available at <http://localhost:8888>

#### MySQL
Externally the MySQL server is available at port 8889, and when running on the VM it is available as a socket or at port 3306 as usual.
Username: root
Password: root
Password can be modified through `MYSQL_PW` variable defined in top of provision.sh.

#### PHPMyAdmin
By default PHPMyAdmin is not part of provisioning. If you want it, uncomment the line containing `phpmyadmin_go` in the main function (top of provision.sh). The username is root and the default password id root. Password can be modified through `PHPMYADMIN_PW` variable defined in top of provision.sh.


Technical Details
-----------------
* Ubuntu 14.04 64-bit
* Apache 2.4
* PHP 5.5
* MySQL 5.5
* XDebug
* PHPUnit 4.8
* Composer

We are using the base Ubuntu 14.04 box from Vagrant. If you don't already have it downloaded
the Vagrantfile has been configured to do it for you. This only has to be done once
for each account on your host computer.

The web root is located in the project directory at `src/` and you can install your files there

And like any other vagrant file you have SSH access with
```
$ vagrant ssh
```
