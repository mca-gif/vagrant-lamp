#
# Copyright 2013-2014, Seth Vargo <sethvargo@gmail.com>
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

require 'chef/recipe'
require 'chef/resource'
require 'chef/provider'

class Chef
  module Sugar
    require_relative 'sugar/architecture'
    require_relative 'sugar/cloud'
    require_relative 'sugar/constraints'
    require_relative 'sugar/data_bag'
    require_relative 'sugar/filters'
    require_relative 'sugar/ip'
    require_relative 'sugar/kernel'
    require_relative 'sugar/node'
    require_relative 'sugar/platform'
    require_relative 'sugar/platform_family'
    require_relative 'sugar/ruby'
    require_relative 'sugar/run_context'
    require_relative 'sugar/shell'
    require_relative 'sugar/vagrant'
    require_relative 'sugar/version'
    require_relative 'sugar/virtualization'
  end
end

Chef::Recipe.send(:include, Chef::Sugar::DSL)
Chef::Resource.send(:include, Chef::Sugar::DSL)
Chef::Provider.send(:include, Chef::Sugar::DSL)

Object.send(:include, Chef::Sugar::Kernel)
