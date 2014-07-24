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
    module Ruby
      extend self

      #
      # Determine if the current Ruby version is 2.0.
      #
      # @return [Boolean]
      #
      def ruby_20?(node)
        version = Gem::Version.new(node['languages']['ruby']['version'])
        Gem::Requirement.new('~> 2.0.0').satisfied_by?(version)
      end

      #
      # Determine if the current Ruby version is 1.9.
      #
      # @return [Boolean]
      #
      def ruby_19?(node)
        version = Gem::Version.new(node['languages']['ruby']['version'])
        Gem::Requirement.new('~> 1.9.0').satisfied_by?(version)
      end
    end

    module DSL
      # @see Chef::Sugar::Ruby#ruby_20?
      def ruby_20?; Chef::Sugar::Ruby.ruby_20?(node); end

      # @see Chef::Sugar::Ruby#ruby_19?
      def ruby_19?; Chef::Sugar::Ruby.ruby_19?(node); end
    end
  end
end
