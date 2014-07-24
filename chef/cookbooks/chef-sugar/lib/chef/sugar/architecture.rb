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
    module Architecture
      extend self

      #
      # Determine if the current architecture is 64-bit
      #
      # @return [Boolean]
      #
      def _64_bit?(node)
        node['kernel']['machine'] == 'x86_64'
      end

      #
      # Determine if the current architecture is 32-bit
      #
      # @todo Make this more than "not 64-bit"
      #
      # @return [Boolean]
      #
      def _32_bit?(node)
        !_64_bit?(node)
      end
      alias_method :i386?, :_32_bit?
    end

    module DSL
      # @see Chef::Sugar::Architecture#_64_bit?
      def _64_bit?; Chef::Sugar::Architecture._64_bit?(node); end

      # @see Chef::Sugar::Architecture#_32_bit?
      def _32_bit?; Chef::Sugar::Architecture._32_bit?(node); end
      alias_method :i386?, :_32_bit?
    end
  end
end
