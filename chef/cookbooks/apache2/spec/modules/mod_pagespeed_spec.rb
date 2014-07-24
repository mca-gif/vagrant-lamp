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

support_platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4']
}

describe 'apache2::mod_pagespeed' do
  support_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end
        it 'installs package mod_pagespeed' do
          expect(chef_run).to install_package('mod_pagespeed')
          expect(chef_run).to_not install_package('not_mod_pagespeed')
        end
      end
    end
  end
  it_should_behave_like 'an apache2 module', 'pagespeed', true, support_platforms
#  it 'raises an exception' do
#    expect { chef_run }
#       .to raise_error(RuntimeError, "`mac_os_x' is not supported!")
#  end
end
