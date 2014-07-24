#
# Cookbook Name:: freebsd
# Recipe:: portsnap
#
# Copyright 2013, Opscode, Inc.
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

non_interactive_portsnap = File.join(Chef::Config[:file_cache_path], 'portsnap')

# The sed forces portsnap to run non-interactively
# fetch downloads a ports snapshot, extract puts them on disk (long)
# update will update an existing ports tree
script 'create non-interactive portsnap' do
  interpreter 'sh'
  code <<-EOS
    set -e # ensure we exit at first non-zero
    sed -e 's/\\[ ! -t 0 \\]/false/' /usr/sbin/portsnap > #{non_interactive_portsnap}
    chmod +x #{non_interactive_portsnap}
  EOS
  not_if { File.exist?(non_interactive_portsnap) }
end

# Ensure we have a ports tree
unless File.exist?('/usr/ports/.portsnap.INDEX')
  execute "#{non_interactive_portsnap} fetch extract"
end

execute "#{non_interactive_portsnap} update"
