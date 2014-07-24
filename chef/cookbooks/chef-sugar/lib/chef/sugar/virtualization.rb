#
# Copyright 2014, Joseph J. Nuspl Jr. <nuspl@nvwls.com>
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
    module Virtualization
      extend self

      #
      # Determine if the current node is running in a linux container.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #   true if the machine is currently running in a container, false
      #   otherwise
      #
      def lxc?(node)
        node['virtualization'] && node['virtualization']['system'] == 'lxc'
      end
    end

    module DSL
      # @see Chef::Sugar::Virtualization#lxc?
      def lxc?; Chef::Sugar::Virtualization.lxc?(node); end
    end
  end
end
