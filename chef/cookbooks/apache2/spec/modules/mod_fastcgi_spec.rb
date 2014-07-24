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

describe 'apache2::mod_fastcgi' do
  before do
    stub_command('test -f /usr/lib/httpd/modules/mod_auth_openid.so').and_return(true)
    stub_command('test -f /etc/httpd/mods-available/fastcgi.conf').and_return(true)
  end

  it_should_behave_like 'an apache2 module', 'fastcgi', true, platforms
end
