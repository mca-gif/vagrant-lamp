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

describe 'apache2::mod_php5' do
  before do
    stub_command('which php').and_return(false)
  end

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        if %w{redhat centos fedora arch}.include?(platform)
          pkg = 'php'
          pkg = 'php53' if version.to_f < 6.0
          it "installs package #{pkg}" do
            expect(chef_run).to install_package(pkg)
            expect(chef_run).to_not install_package("not_#{pkg}")
          end
          let(:package) { chef_run.package(pkg) }
          it "triggers a notification by #{pkg} package install to execute[generate-module-list]" do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w{suse}.include?(platform)
          it 'installs package php' do
            expect(chef_run).to install_package('php')
            expect(chef_run).to_not install_package('not_php')
          end
          let(:package) { chef_run.package('php') }
          it 'triggers a notification by php package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w{debian ubuntu}.include?(platform)
          it 'installs package libapache2-mod-php5' do
            expect(chef_run).to install_package('libapache2-mod-php5')
            expect(chef_run).to_not install_package('not_libapache2-mod-php5')
          end
        end

        apache_dir = '/etc/apache2'

        if %w(debian ubuntu).include?(platform)
          apache_dir = '/etc/apache2'
        elsif %w(redhat centos scientific fedora suse amazon oracle).include?(platform)
          apache_dir = '/etc/httpd'
        elsif platform == 'freebsd'
          apache_dir = '/usr/local/etc/apache22'
        else
          apache_dir = '/tmp/bogus'
          apache_lib_dir = '/usr/lib/apache2'
        end

        it "deletes #{apache_dir}/conf.d/php.conf" do
          expect(chef_run).to delete_file("#{apache_dir}/conf.d/php.conf").with(:backup => false)
          expect(chef_run).to_not delete_file("#{apache_dir}/conf.d/php.conf").with(:backup => true)
        end
      end
    end
  end

  it_should_behave_like 'an apache2 module', 'php5', true, platforms, 'libphp5.so'
end
