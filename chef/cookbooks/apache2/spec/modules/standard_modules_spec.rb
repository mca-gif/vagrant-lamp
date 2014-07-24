require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
  'fedora' => %w(18 20),
  'redhat' => ['5.9', '6.5'],
  'centos' => ['5.9', '6.5'],
  'freebsd' => ['9.2'],
  'suse' => ['11.3']
}
#  'arch' =>

# not supported modules: authn_alias authn_anon authn_dbd authn_dbm authn_default authz_dbm authz_ldap authz_owner
aaa_modules_without_config = %w(auth_basic auth_digest authz_default authz_groupfile authz_host authz_user authn_file)
aaa_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# @todo add support for windows
# arch_win32_modules_without_config = %w(isapi win32)
#
# arch_win32_modules_without_config.each do |mod|
#  describe "apache2::mod_#{mod}" do
#    it_should_behave_like 'an apache2 module', mod, false, platforms
#  end
# end

# not supported modules: cache disk_cache file_cache mem_cache
cache_modules_without_config = %w()
cache_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# not supported modules: dbd
database_modules_without_config = %w()
database_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# not supported modules: dav_lock
dav_modules_without_config = %w(dav dav_fs)
dav_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end

# not supported modules: charset_lite ext_filter reqtimeout substitute
filters_modules_without_config = %w(filter)
filters_modules_with_config = %w(include deflate)
filters_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
filters_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: asis cgid suexec
generators_modules_without_config = %w(cgi)
generators_modules_with_config = %w(autoindex status info)
generators_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
generators_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

http_modules_with_config = %w(mime)
http_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: log_forensic
loggers_modules_without_config = %w(log_config logio)
loggers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms.select { |key, value| %w(redhat fedora suse freebsd).include?(key) }
  end
end

# not supported modules: imagemap speling vhost_alias
mappers_modules_without_config = %w(actions rewrite userdir)
mappers_modules_with_config = %w(alias dir negotiation)
mappers_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
mappers_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: cern_meta ident mime_magic unique_id usertrack version
metadata_modules_without_config = %w(env expires headers)
metadata_modules_with_config = %w(setenvif)
metadata_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
metadata_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

# not supported modules: proxy_ftp proxy_scgi
proxy_modules_without_config = %w(proxy_ajp proxy_balancer proxy_connect proxy_http)
proxy_modules_with_config = %w(proxy)
proxy_modules_without_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, false, platforms
  end
end
proxy_modules_with_config.each do |mod|
  describe "apache2::mod_#{mod}" do
    it_should_behave_like 'an apache2 module', mod, true, platforms
  end
end

describe 'apache2::mod_ssl' do

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        apache_dir = '/etc/apache2'
        apache_lib_dir = '/usr/lib/apache2'
        apache_cache_dir = '/var/cache/apache2'
        apache_conf = "#{apache_dir}/apache2.conf"
        apache_perl_pkg = 'perl'
        apache_log_dir = '/var/log/httpd'
        apache_cache_dir = '/var/cache/httpd'
        apache_lib_dir = '/usr/lib/apache2'
        apache_root_group = 'root'
        apache_service_name = nil
        apache_service_restart_command = nil
        apache_service_reload_command = nil
        apache_default_modules = %w(
            status alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex
            dir env mime negotiation setenvif
        )

        if %w(debian ubuntu).include?(platform)
          apache_dir = '/etc/apache2'
          apache_lib_dir = '/usr/lib/apache2'
          apache_cache_dir = '/var/cache/apache2'
          apache_conf = "#{apache_dir}/apache2.conf"
          apache_service_name = 'apache2'
          apache_service_restart_command = '/usr/sbin/invoke-rc.d apache2 restart && sleep 1'
          apache_service_reload_command = '/usr/sbin/invoke-rc.d apache2 reload && sleep 1'
        elsif %w(redhat centos scientific fedora suse amazon oracle).include?(platform)
          apache_dir = '/etc/httpd'
          apache_lib_dir = '/usr/lib64/httpd'
          apache_cache_dir = '/var/cache/httpd'
          apache_conf = "#{apache_dir}/conf/httpd.conf"
          apache_service_name  = 'httpd'
          # If restarted/reloaded too quickly httpd has a habit of failing.
          # This may happen with multiple recipes notifying apache to restart - like
          # during the initial bootstrap.
          apache_service_restart_command = '/sbin/service httpd restart && sleep 1'
          apache_service_reload_command = '/sbin/service httpd reload && sleep 1'
        elsif platform == 'arch'
          apache_service_name = 'httpd'
        elsif platform == 'freebsd'
          apache_dir = '/usr/local/etc/apache22'
          apache_lib_dir = '/usr/local/libexec/apache22'
          apache_log_dir = '/var/log'
          apache_cache_dir = '/var/run/apache22'
          apache_conf = "#{apache_dir}/httpd.conf"
          apache_perl_pkg = 'perl5'
          apache_root_group = 'wheel'
          apache_service_name = 'apache22'
          apache_service_restart_command = nil
          apache_service_reload_command = nil
        else
          apache_dir = '/tmp/bogus'
          apache_lib_dir = '/usr/lib/apache2'
        end

        if %w{redhat centos fedora arch suse}.include?(platform)
          it 'installs package mod_ssl' do
            expect(chef_run).to install_package('mod_ssl')
            expect(chef_run).to_not install_package('not_mod_ssl')
          end
          let(:package) { chef_run.package('mod_ssl') }
          it 'triggers a notification by mod_ssl package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
          it "deletes #{apache_dir}/conf.d/ssl.conf" do
            expect(chef_run).to delete_file("#{apache_dir}/conf.d/ssl.conf").with(:backup => false)
            expect(chef_run).to_not delete_file("#{apache_dir}/conf.d/ssl.conf").with(:backup => true)
          end
        end

        it 'creates /etc/apache2/ports.conf' do
          expect(chef_run).to create_template('ssl_ports.conf').with(
            :path => "#{apache_dir}/ports.conf",
            :source => 'ports.conf.erb',
            :mode => '0644'
         )
        end

        let(:template) { chef_run.template('ssl_ports.conf') }
        it 'triggers a notification by ssl_ports.conf template to restart service[apache2]' do
          expect(template).to notify('service[apache2]').to(:restart)
          expect(template).to_not notify('service[apache2]').to(:stop)
        end
      end
    end
  end

  it_should_behave_like 'an apache2 module', 'ssl', true, platforms
end
