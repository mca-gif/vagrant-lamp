require 'spec_helper'

# examples at https://github.com/sethvargo/chefspec/tree/master/examples

describe 'apache2::default' do
  before do
    allow(::File).to receive(:symlink?).and_return(false)
  end

  platforms = {
    'ubuntu' => ['12.04', '14.04'],
    'debian' => ['7.0', '7.4'],
    'fedora' => %w(18 20),
    'redhat' => ['5.9', '6.5'],
    'centos' => ['5.9', '6.5'],
    'freebsd' => ['9.2']
  }
  #  'suse' => ['11.3']

  # Test all defaults on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version) do |node|
          end.converge(described_recipe)
        end

        it 'installs package apache2' do
          expect(chef_run).to install_package('apache2')
          expect(chef_run).to_not install_package('not_apache2')
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

        if %w{redhat centos fedora arch suse freebsd}.include?(platform)
          it "creates #{apache_log_dir} directory" do
            expect(chef_run).to create_directory(apache_log_dir).with(
              :mode => '0755'
            )

            expect(chef_run).to_not create_directory(apache_log_dir).with(
              :mode => '0777'
            )
          end

          it "installs package #{apache_perl_pkg}" do
            expect(chef_run).to install_package(apache_perl_pkg)
            expect(chef_run).to_not install_package('perl6')
          end

          it 'creates /usr/local/bin/apache2_module_conf_generate.pl' do
            expect(chef_run).to create_cookbook_file('/usr/local/bin/apache2_module_conf_generate.pl').with(
              :mode =>  '0755',
              :owner => 'root',
              :group => apache_root_group
            )
            expect(chef_run).to_not create_cookbook_file('/usr/bin/apache2_module_conf_generate.pl')
          end

          it 'runs a execute[generate-module-list] with :nothing action' do
            # .with(
            #  command: "/usr/local/bin/apache2_module_conf_generate.pl #{apache_lib_dir} #{apache_dir}/mods-available"
            # )
            execute = chef_run.execute('generate-module-list')
            expect(execute).to do_nothing
          end

          %w(sites-available sites-enabled mods-available mods-enabled).each do |dir|
            it "creates #{apache_dir}/#{dir} directory" do
              expect(chef_run).to create_directory("#{apache_dir}/#{dir}").with(
                :mode => '0755',
                :owner => 'root',
                :group => apache_root_group
              )

              expect(chef_run).to_not create_directory("#{apache_dir}/#{dir}").with(
                :mode => '0777'
              )
            end
          end

          %w(a2ensite a2dissite a2enmod a2dismod).each do |modscript|
            it "creates /usr/sbin/#{modscript}" do
              expect(chef_run).to create_template("/usr/sbin/#{modscript}")
            end
          end

          %w(proxy_ajp auth_pam authz_ldap webalizer ssl welcome).each do |f|
            it "deletes #{apache_dir}/conf.d/#{f}.conf" do
              expect(chef_run).to delete_file("#{apache_dir}/conf.d/#{f}.conf").with(:backup => false)
              expect(chef_run).to_not delete_file("#{apache_dir}/conf.d/#{f}.conf").with(:backup => true)
            end
          end

          it "deletes #{apache_dir}/conf.d/README" do
            expect(chef_run).to delete_file("#{apache_dir}/conf.d/README").with(:backup => false)
            expect(chef_run).to_not delete_file("#{apache_dir}/conf.d/README").with(:backup => true)
          end

          it 'includes the `apache2::mod_deflate` recipe' do
            expect(chef_run).to include_recipe('apache2::mod_deflate')
          end
        end

        it "creates #{apache_conf}" do
          expect(chef_run).to create_template(apache_conf).with(
            :source => 'apache2.conf.erb',
            :owner => 'root',
            :group => apache_root_group,
            :mode =>  '0644'
          )
        end

        let(:template) { chef_run.template(apache_conf) }
        it "notification is triggered by #{apache_conf} template to reload service[apache2]" do
          expect(template).to notify('service[apache2]').to(:reload)
          expect(template).to_not notify('service[apache2]').to(:stop)
        end

        %w(security charset).each do |config|
          it "creates #{apache_dir}/conf.d/#{config}.conf" do
            expect(chef_run).to create_template("#{apache_dir}/conf.d/#{config}.conf").with(
              :source => "#{config}.erb",
              :owner => 'root',
              :group => apache_root_group,
              :mode =>  '0644',
              :backup =>  false
            )
          end

          let(:template) { chef_run.template("#{apache_dir}/conf.d/#{config}.conf") }
          it "notification is triggered by #{apache_dir}/conf.d/#{config}.conf template to reload service[apache2]" do
            expect(template).to notify('service[apache2]').to(:reload)
            expect(template).to_not notify('service[apache2]').to(:stop)
          end
        end

        it "creates #{apache_dir}/ports.conf" do
          expect(chef_run).to create_template("#{apache_dir}/ports.conf").with(
            :source => 'ports.conf.erb',
            :owner => 'root',
            :group => apache_root_group,
            :mode =>  '0644'
          )
        end

        let(:template) { chef_run.template("#{apache_dir}/ports.conf") }
        it "notification is triggered by #{apache_dir}/ports.conf template to reload service[apache2]" do
          expect(template).to notify('service[apache2]').to(:reload)
          expect(template).to_not notify('service[apache2]').to(:stop)
        end

        it "creates #{apache_dir}/sites-available/default" do
          expect(chef_run).to create_template("#{apache_dir}/sites-available/default").with(
            :source => 'default-site.erb',
            :owner => 'root',
            :group => apache_root_group,
            :mode =>  '0644'
          )
        end

        let(:template) { chef_run.template("#{apache_dir}/sites-available/default") }
        it "notification is triggered by #{apache_dir}/sites-available/default template to reload service[apache2]" do
          expect(template).to notify('service[apache2]').to(:reload)
          expect(template).to_not notify('service[apache2]').to(:stop)
        end

        if %w{redhat centos fedora}.include?(platform)
          it 'creates /etc/sysconfig/httpd' do
            expect(chef_run).to create_template('/etc/sysconfig/httpd').with(
              :source => 'etc-sysconfig-httpd.erb',
              :owner => 'root',
              :group => apache_root_group,
              :mode =>  '0644'
            )
          end
        end

        if platform == 'freebsd'
          it "deletes #{apache_dir}/Includes/no-accf.conf" do
            expect(chef_run).to delete_file("#{apache_dir}/Includes/no-accf.conf").with(:backup => false)
            expect(chef_run).to_not delete_file("#{apache_dir}/Includes/no-accf.conf").with(:backup => true)
          end
          it "deletes #{apache_dir}/Includes" do
            expect(chef_run).to delete_directory("#{apache_dir}/Includes")
          end

          %w(
            httpd-autoindex.conf httpd-dav.conf httpd-default.conf httpd-info.conf
            httpd-languages.conf httpd-manual.conf httpd-mpm.conf
            httpd-multilang-errordoc.conf httpd-ssl.conf httpd-userdir.conf
            httpd-vhosts.conf
          ).each do |f|
            it "deletes #{apache_dir}/extra/#{f}" do
              expect(chef_run).to delete_file("#{apache_dir}/extra/#{f}").with(:backup => false)
              expect(chef_run).to_not delete_file("#{apache_dir}/extra/#{f}").with(:backup => true)
            end
          end
          it "deletes #{apache_dir}/extra" do
            expect(chef_run).to delete_directory("#{apache_dir}/extra")
          end
        end
        %W(
          #{apache_dir}/ssl
          #{apache_dir}/conf.d
          #{apache_cache_dir}
        ).each do |path|
          it "creates #{path} directory" do
            expect(chef_run).to create_directory(path).with(
              :mode => '0755',
              :owner => 'root',
              :group => apache_root_group
            )
          end
        end

        apache_default_modules.each do |mod|
          module_recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
          it "includes the `apache2::#{module_recipe_name}` recipe" do
            expect(chef_run).to include_recipe("apache2::#{module_recipe_name}")
          end
        end

        it 'runs a a2dissite default' do
          allow(::File).to receive(:symlink?).with("#{apache_dir}/sites-enabled/default").and_return(true)
          allow(::File).to receive(:symlink?).with("#{apache_dir}/sites-enabled/000-default").and_return(true)
          expect(chef_run).to run_execute('a2dissite default').with(
             :command => '/usr/sbin/a2dissite default'
          )
        end
        it 'does not run a a2dissite default' do
          allow(::File).to receive(:symlink?).with("#{apache_dir}/sites-enabled/default").and_return(false)
          allow(::File).to receive(:symlink?).with("#{apache_dir}/sites-enabled/000-default").and_return(false)
          expect(chef_run).to_not run_execute('a2dissite default').with(
             :command => '/usr/sbin/a2dissite default'
          )
        end

        let(:execute) { chef_run.execute('a2dissite default') }
        it 'notification is triggered by a2dissite to reload service[apache2]' do
          expect(execute).to notify('service[apache2]').to(:reload)
          expect(execute).to_not notify('service[apache2]').to(:stop)
        end

        it 'enables an apache2 service' do
          expect(chef_run).to enable_service('apache2').with(
            :service_name => apache_service_name,
            :restart_command => apache_service_restart_command,
            :reload_command => apache_service_reload_command,
            :supports => { :restart => true, :reload => true, :status => true },
            :action => [:enable, :start]
          )
        end

      end
    end
  end
end
