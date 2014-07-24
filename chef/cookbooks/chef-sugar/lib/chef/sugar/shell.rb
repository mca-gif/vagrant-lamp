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

require 'mixlib/shellout'
require 'pathname'

class Chef
  module Sugar
    module Shell
      extend self

      #
      # Finds a command in $PATH
      #
      # @param [String] cmd
      #   the command to find
      #
      # @return [String, nil]
      #
      def which(cmd)
        if Pathname.new(cmd).absolute?
          File.executable?(cmd) ? cmd : nil
        else
          paths = ENV['PATH'].split(::File::PATH_SEPARATOR) + %w(/bin /usr/bin /sbin /usr/sbin)

          paths.each do |path|
            possible = File.join(path, cmd)
            return possible if File.executable?(possible)
          end

          nil
        end
      end

      #
      # The platform-specific output path to +/dev/null+.
      #
      # @return [String]
      #
      def dev_null(node)
        Chef::Sugar::PlatformFamily.windows?(node) ? 'NUL' : '/dev/null'
      end

      #
      # Boolean method to check if a command line utility is installed.
      #
      # @param [String] cmd
      #   the command to find
      #
      # @return [Boolean]
      #   true if the command is found in the path, false otherwise
      #
      def installed?(cmd)
        !which(cmd).nil?
      end

      #
      # Checks if the given binary is installed and exists at the given
      # version. Also see {version_for}.
      #
      # @param [String] cmd
      #   the command to check
      # @param [String] version
      #   the version to check
      # @param [String] flag
      #   the flag to use to check the version of the binary
      #
      # @return [Boolean]
      #   true if the command exists and is at the given version, false
      #   otherwise
      #
      def installed_at_version?(cmd, version, flag = '--version')
        which(cmd) && if version.is_a?(Regexp)
                        version_for(cmd, flag) =~ version
                      else
                        version_for(cmd, flag).include?(version)
                      end
      end

      #
      # The version for a given command. This method does NOT check if the
      # command exists! It is assumed the command existence has been
      # checked with +which+ or similar. To simply check if an installed
      # version is acceptable, please see {installed_at_version}.
      #
      # Assumptions:
      #   1. The command exists.
      #   2. The command outputs version information to +$stdout+ or +$stderr+.
      #      Did you know that java outputs its version to $stderr?
      #
      #
      # @param [String] cmd
      #   the command to find the version for
      # @param [String] flag
      #   the flag to use to get the version
      #
      # @return [String]
      #   the entire output of the version command (stderr and stdout)
      #
      def version_for(cmd, flag = '--version')
        cmd = Mixlib::ShellOut.new("#{cmd} #{flag}")
        cmd.run_command
        cmd.error!
        [cmd.stdout.strip, cmd.stderr.strip].join("\n")
      end
    end

    module DSL
      # @see Chef::Sugar::Shell#which
      def which(cmd); Chef::Sugar::Shell.which(cmd); end

      # @see Chef::Sugar::Shell#dev_null
      def dev_null; Chef::Sugar::Shell.dev_null(node); end

      # @see Chef::Sugar::Shell#installed?
      def installed?(cmd); Chef::Sugar::Shell.installed?(cmd); end

      # @see Chef::Sugar::Shell#installed_at_version?
      def installed_at_version?(cmd, version, flag = '--version')
        Chef::Sugar::Shell.installed_at_version?(cmd, version, flag)
      end

      # @see Chef::Sugar::Shell#version_for
      def version_for(cmd, flag = '--version')
        Chef::Sugar::Shell.version_for(cmd, flag)
      end
    end
  end
end
