#
# Cookbook Name:: ubuntu
# Attribute File:: default
#
# Copyright 2011, Opscode, Inc.
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

default['ubuntu']['archive_url']  = 'http://us.archive.ubuntu.com/ubuntu'
default['ubuntu']['security_url'] = 'http://security.ubuntu.com/ubuntu'
default['ubuntu']['include_source_packages'] = true
default['ubuntu']['components'] = 'main restricted universe multiverse'
default['ubuntu']['codename'] = node['lsb']['codename']

# If you want to limit the repositories to a specifc arch set this to an array of archs
default['ubuntu']['architectures'] = nil

default['ubuntu']['locale'] = nil
