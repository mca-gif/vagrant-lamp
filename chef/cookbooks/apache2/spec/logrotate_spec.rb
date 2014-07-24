require 'spec_helper'

describe 'apache2::logrotate' do
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

  # Test all defaults on all platforms
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version) do |node|
          end.converge(described_recipe)
        end

        # apache_service = service 'apache2' do
        #   action :nothing
        # end
        it 'includes the `logrotate` recipe' do
          expect(chef_run).to include_recipe('logrotate')
        end
      # logrotate_app apache_service.service_name do
      #   path node['apache']['log_dir']
      # end
      end
    end
  end
end
