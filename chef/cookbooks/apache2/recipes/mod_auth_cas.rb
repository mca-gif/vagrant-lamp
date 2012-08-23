if node['apache']['mod_auth_cas']['from_source']
  git '/tmp/mod_auth_cas' do
    repository 'git:github.com/Jasig/mod_auth_cas.git'
    notifies :run, 'execute[compile mod_auth_cas]', :immediately
  end

  execute 'compile mod_auth_cas' do
    command './configure && make && make install'
    cwd '/tmp/mod_auth_cas'
    not_if "test -f #{node['apache']['libexecdir']}/mod_auth_cas.so"
  end

  template "#{node['apache']['dir']}/mods-available/auth_cas.load" do
    source 'mods/auth_cas.load.erb'
    owner 'root'
    group node['apache']['root_group']
    mode '0644'
  end
else
  case node['platform']
    when "debian", "ubuntu"
      package "libapache2-mod-auth-cas" do
        action :install
      end
    when "centos", "redhat", "fedora", "amazon", "scientific"
      package "mod_auth_cas" do
        action :install
        notifies :run, resources(:execute => "generate-module-list"), :immediately
      end
  end
end

apache_module 'auth_cas'

directory "#{node['apache']['cache_dir']}/mod_auth_cas" do
  owner node['apache']['user']
  group node['apache']['group']
  mode '0700'
end
