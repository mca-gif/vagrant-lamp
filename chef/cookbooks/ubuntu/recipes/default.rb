#
# Cookbook Name:: ubuntu
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

template '/etc/apt/sources.list' do
  mode 00644
  variables(
    :architectures => node['ubuntu']['architectures'],
    :code_name => node['ubuntu']['codename'],
    :security_url => node['ubuntu']['security_url'],
    :archive_url => node['ubuntu']['archive_url'],
    :include_source_packages => node['ubuntu']['include_source_packages'],
    :components => node['ubuntu']['components']
    )
  notifies :run, 'execute[apt-get update]', :immediately
  source 'sources.list.erb'
end

include_recipe 'apt'

if node['ubuntu']['locale']

  %w{ LC_ALL LANG }.each do |envvar|
    execute "set_locale_#{envvar.downcase}" do
      command "update-locale #{envvar}=#{node['ubuntu']['locale']}"
      action :run
      not_if "grep #{envvar}=#{node['ubuntu']['locale']} /etc/default/locale"
    end
  end

end
