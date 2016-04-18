#!/bin/bash

apache_config_file="/etc/apache2/envvars"
apache_vhost_file="/etc/apache2/sites-available/vagrant_vhost.conf"
php_config_file="/etc/php5/apache2/php.ini"
xdebug_config_file="/etc/php5/mods-available/xdebug.ini"
mysql_config_file="/etc/mysql/my.cnf"
default_apache_index="/var/www/html/index.html"
project_web_root="src"

# Credential Variable
MYSQL_PW='root'
PHPMYADMIN_PW='root'

# This function is called at the very bottom of the file
main() {
	repositories_go
	update_go
	network_go
	tools_go
	apache_go
	mysql_go
	php_go
	#phpmyadmin_go
	autoremove_go
}

repositories_go() {
	echo "NOOP"
}

update_go() {
	# Update the server
	apt-get update
	# apt-get -y upgrade
}

autoremove_go() {
	apt-get -y autoremove
}

network_go() {
	IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
	sed -i "s/^${IPADDR}.*//" /etc/hosts
	echo ${IPADDR} ubuntu.localhost >> /etc/hosts			# Just to quiet down some error messages
}

tools_go() {
	# Install basic tools
	apt-get -y install build-essential binutils-doc git subversion
}

apache_go() {
	# Install Apache
	apt-get -y install apache2

	sed -i "s/^\(.*\)www-data/\1vagrant/g" ${apache_config_file}
	chown -R vagrant:vagrant /var/log/apache2

	if [ ! -f "${apache_vhost_file}" ]; then
		cat << EOF > ${apache_vhost_file}
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /vagrant/${project_web_root}
    LogLevel debug

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined

    <Directory /vagrant/${project_web_root}>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
	fi

	a2dissite 000-default
	a2ensite vagrant_vhost

	a2enmod rewrite

	service apache2 reload
	update-rc.d apache2 enable
}

php_go() {
	apt-get -y install php5 php5-curl php5-mysql php5-sqlite php5-xdebug php5-pear

	sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file}
	sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file}

	if [ ! -f "{$xdebug_config_file}" ]; then
		cat << EOF > ${xdebug_config_file}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_host=10.0.2.2
EOF
	fi

	service apache2 reload

	# Install latest version of Composer globally
	if [ ! -f "/usr/local/bin/composer" ]; then
		curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
	fi

	# Install PHP Unit 4.8 globally
	if [ ! -f "/usr/local/bin/phpunit" ]; then
		curl -O -L https://phar.phpunit.de/phpunit-old.phar
		chmod +x phpunit-old.phar
		mv phpunit-old.phar /usr/local/bin/phpunit
	fi
}

mysql_go() {
	# Install MySQL
	echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
	apt-get -y install mysql-client mysql-server

	sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${mysql_config_file}

	# Allow root access from any host
	echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" | mysql -u root --password=$MYSQL_PW
	echo "GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION" | mysql -u root --password=$MYSQL_PW

	if [ -d "/vagrant/provision-sql" ]; then
		echo "Executing all SQL files in /vagrant/provision-sql folder ..."
		echo "-------------------------------------"
		for sql_file in /vagrant/provision-sql/*.sql
		do
			echo "EXECUTING $sql_file..."
	  		time mysql -u root --password=$MYSQL_PW < $sql_file
	  		echo "FINISHED $sql_file"
	  		echo ""
		done
	fi

	service mysql restart
	update-rc.d apache2 enable
}

phpmyadmin_go() {
	# Install PHPMyAdmin
	echo "Install PHPMyAdmin"
	apt-get -y install php5-mcrypt

	ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available/mcrypt.ini
	php5enmod mcrypt

	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PW" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $PHPMYADMIN_PW" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PW" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

	apt-get -y install phpmyadmin

	service apache2 reload
}

main
exit 0
