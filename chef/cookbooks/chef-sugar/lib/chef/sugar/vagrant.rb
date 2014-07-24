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

class Chef
  module Sugar
    module Vagrant
      extend self

      #
      # Determine if the current node is running in vagrant mode.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #   true if the machine is currently running vagrant, false
      #   otherwise
      #
      def vagrant?(node)
        vagrant_key?(node) || vagrant_domain?(node) || vagrant_user?(node)
      end

      private

      #
      # Check if the +vagrant+ key exists on the +node+ object. This key is no
      # longer populated by vagrant, but it is kept around for legacy purposes.
      #
      # @param (see vagrant?)
      # @return (see vagrant?)
      #
      def vagrant_key?(node)
        node.key?('vagrant')
      end

      #
      # Check if "vagrantup.com" is included in the node's domain. Technically,
      # this would make Chef Sugar falsely detect +vagrant?+ on any of
      # Hashicorp's servers. But if that edge case becomes a serious problem,
      # @mitchellh has my phone number.
      #
      # @param (see vagrant?)
      # @return (see vagrant?)
      #
      def vagrant_domain?(node)
        node['domain'] && node['domain'].include?('vagrantup.com')
      end

      #
      # Check if the system contains a +vagrant+ user.
      #
      # @param (see vagrant?)
      # @return (see vagrant?)
      #
      def vagrant_user?(node)
        node['etc'] && node['etc']['passwd'] && node['etc']['passwd']['vagrant']
      end
    end

    module DSL
      # @see Chef::Sugar::Vagrant#vagrant?
      def vagrant?; Chef::Sugar::Vagrant.vagrant?(node); end
    end
  end
end
