require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
  'fedora' => %w(18 20),
  'redhat' => ['5.9', '6.5'],
  'centos' => ['5.9', '6.5'],
  'freebsd' => ['9.2']
}
#  'arch' =>

describe 'apache2::mod_auth_openid' do
  before do
    stub_command('test -f /var/chef/cache/mod_auth_openid-95043901eab868400937642d9bc55d17e9dd069f/src/.libs/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/lib64/httpd/modules/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/local/libexec/apache22/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/lib/httpd/modules/mod_auth_openid.so').and_return(true)
    stub_command('test -f /usr/lib/apache2/modules/mod_auth_openid.so').and_return(true)

  end
  it_should_behave_like 'an apache2 module', 'authopenid', false, platforms, 'mod_auth_openid.so'
end
