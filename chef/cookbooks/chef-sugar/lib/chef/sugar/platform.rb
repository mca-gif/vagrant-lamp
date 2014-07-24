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
    module Platform
      extend self

      PLATFORM_VERSIONS = {
        'debian' => {
          'squeeze' => '6',
          'wheezy'  => '7',
          'jessie'  => '8',
        },
        'linuxmint' => {
          'petra'  => '16',
          'olivia' => '15',
          'nadia'  => '14',
          'maya'   => '13',
          'lisa'   => '12',
        },
        'mac_os_x' => {
          'lion'          => '10.7',
          'mountain_lion' => '10.8',
          'mavericks'     => '10.9',
          'yosemite'      => '10.10',
        },
        'ubuntu' => {
          'lucid'    => '10.04',
          'maverick' => '10.10',
          'natty'    => '11.04',
          'oneiric'  => '11.10',
          'precise'  => '12.04',
          'quantal'  => '12.10',
          'raring'   => '13.04',
          'saucy'    => '13.10',
          'trusty'   => '14.04',
        },
      }

      COMPARISON_OPERATORS = {
        'after'        => ->(a, b) { a > b },
        'after_or_at'  => ->(a, b) { a >= b },
        ''             => ->(a, b) { a == b },
        'before'       => ->(a, b) { a < b },
        'before_or_at' => ->(a, b) { a <= b },
      }

      # Dynamically define custom matchers at runtime in a matrix. For each
      # Platform, we create a map of named versions to their numerical
      # equivalents (e.g. debian_before_squeeze?).
      PLATFORM_VERSIONS.each do |platform, versions|
        versions.each do |name, version|
          COMPARISON_OPERATORS.each do |operator, block|
            method_name = "#{platform}_#{operator}_#{name}?".squeeze('_').to_sym
            define_method(method_name) do |node|
              # Find the highest precedence that we actually care about based
              # off of what was given to us in the list.
              length = version.split('.').size
              check  = node['platform_version'].split('.')[0...length].join('.')

              # Calling #to_f will ensure we only check major versions since
              # '10.04.4'.to_f #=> 10.04.
              node['platform'] == platform && block.call(check.to_f, version.to_f)
            end
          end
        end
      end

      #
      # Determine if the current node is linux mint.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def linux_mint?(node)
        node['platform'] == 'linuxmint'
      end
      alias_method :mint?, :linux_mint?

      #
      # Determine if the current node is ubuntu.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def ubuntu?(node)
        node['platform'] == 'ubuntu'
      end

      #
      # Determine if the current node is amazon linux.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def amazon_linux?(node)
        node['platform'] == 'amazon'
      end
      alias_method :amazon?, :amazon_linux?

      #
      # Determine if the current node is centos.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def centos?(node)
        node['platform'] == 'centos'
      end

      #
      # Determine if the current node is oracle linux.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def oracle_linux?(node)
        node['platform'] == 'oracle'
      end
      alias_method :oracle?, :oracle_linux?

      #
      # Determine if the current node is scientific linux.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def scientific_linux?(node)
        node['platform'] == 'scientific'
      end
      alias_method :scientific?, :scientific_linux?

      #
      # Determine if the current node is redhat enterprise.
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def redhat_enterprise_linux?(node)
        node['platform'] == 'enterprise'
      end
      alias_method :redhat_enterprise?, :redhat_enterprise_linux?

      #
      # Determine if the current node is solaris2
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def solaris2?(node)
        node['platform'] == 'solaris2'
      end
      alias_method :solaris?, :solaris2?

      #
      # Determine if the current node is aix
      #
      # @param [Chef::Node] node
      #
      # @return [Boolean]
      #
      def aix?(node)
        node['platform'] == 'aix'
      end

    end

    module DSL
      Chef::Sugar::Platform.instance_methods.each do |name|
        define_method(name) do
          Chef::Sugar::Platform.send(name, node)
        end
      end
    end
  end
end
