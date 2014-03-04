php_config_file = "/etc/php5/apache2/php.ini"
xdebug_config_file = "/etc/php5/conf.d/xdebug.ini"

php_pear "xdebug" do
  # Specify that xdebug.so must be loaded as a zend extension
  zend_extensions ['xdebug.so']
  action :install
end

# enable display startup errors
execute "display-startup-errors" do
  not_if "cat #{php_config_file} | grep 'display_startup_errors = On'"
  command "sed -i 's/display_startup_errors = Off/display_startup_errors = On/g' #{php_config_file}"
end
 
# enable display errors
execute "display-errors" do
  not_if "cat #{php_config_file} | grep 'display_errors = On'"
  command "sed -i 's/display_errors = Off/display_errors = On/g' #{php_config_file}"
end
 
# enable xdebug remote
execute "xdebug-remote" do
  not_if "cat #{xdebug_config_file} | grep 'xdebug.remote_enable=On'"
  command "echo 'xdebug.remote_enable=On' >> #{xdebug_config_file}"
end
 
# enable xdebug remote connect back
execute "xdebug-remote-connect-back" do
  not_if "cat #{xdebug_config_file} | grep 'xdebug.remote_connect_back=On'"
  command "echo 'xdebug.remote_connect_back=On' >> #{xdebug_config_file}"
end
 
service "apache2" do
  action :reload
end
