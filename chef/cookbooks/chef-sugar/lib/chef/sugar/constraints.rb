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
    module Constraints
      extend self

      #
      # Shortcut method for creating a new {Version} object.
      #
      # @param [String] version
      #   the version (as a string) to create
      #
      # @return [Chef::Sugar::Constraints::Version]
      #   the new version object
      #
      def version(version)
        Chef::Sugar::Constraints::Version.new(version)
      end

      #
      # Shortcut method for creating a new {Constraint} object.
      #
      # @param [String, Array<String>] constraints
      #   the list of constraints to use
      #
      # @return [Chef::Sugar::Constraints::Constraint]
      #   the new constraint object
      #
      def constraint(*constraints)
        Chef::Sugar::Constraints::Constraint.new(*constraints)
      end

      #
      # This class is a wrapper around a version requirement that adds a nice
      # DSL for comparing constraints:
      #
      # @example Comparing a single constraint
      #   Constraint.new('~> 1.2.3').satisfied_by?('1.2.7')
      #
      # @example Comparing multiple constraints
      #   Constraint.new('> 1.2.3', '< 2.0.0').satisfied_by?('1.2.7')
      #
      class Constraint
        #
        # Create a new constraint object.
        #
        # @param [String, Array<String>] constraints
        #   the list of constraints
        #
        def initialize(*constraints)
          @requirement = Gem::Requirement.new(*constraints)
        end

        #
        # Determine if the given version string is satisfied by this constraint
        # or group of constraints.
        #
        # @example Given a satisified constraint
        #   Constraint.new('~> 1.2.0').satisfied_by?('1.2.5') #=> true
        #
        # @example Given an unsatisfied constraint
        #   Constraint.new('~> 1.2.0').satisfied_by?('2.0.0') #=> false
        #
        #
        # @param [String] version
        #   the version to compare
        #
        # @return [Boolean]
        #   true if the constraint is satisfied, false otherwise
        #
        def satisfied_by?(version)
          @requirement.satisfied_by?(Gem::Version.new(version))
        end
      end

      #
      # This class exposes a single version constraint object that wraps the
      # string representation of a version string and proved helpful comparator
      # methods.
      #
      # @example Create a new version
      #   Chef::Sugar::Version('1.2.3')
      #
      # @example Compare a version with constraints
      #   Chef::Sugar::Version('1.2.3').satisfies?('~> 1.3.4', '< 2.0.5')
      #
      class Version
        #
        # Create a new version object.
        #
        # @param [String] version
        #   the version to create
        #
        def initialize(version)
          @version = Gem::Version.new(version)
        end

        #
        # Determine if the given constraint is satisfied by this version.
        #
        # @example Given a satisified version
        #   Version.new('1.2.5').satisfies?('~> 1.2.0') #=> true
        #
        # @example Given an unsatisfied version
        #   Version.new('2.0.0').satisfies?('~> 1.2.0') #=> false
        #
        #
        # @param [String, Array<String>] constraints
        #   the constraints to satisfy
        #
        # @return [Boolean]
        #   true if the version satisfies the constraints, false otherwise
        #
        def satisfies?(*constraints)
          Gem::Requirement.new(*constraints).satisfied_by?(@version)
        end
      end
    end

    module DSL
      # @see Chef::Sugar::Constraints#version
      def version(version)
        Chef::Sugar::Constraints::Version.new(version)
      end

      # @see Chef::Sugar::Constraints#constraint
      def constraint(*constraints)
        Chef::Sugar::Constraints.constraint(*constraints)
      end

      #
      # This wrapper/convenience method is only available in the recipe DSL. It
      # creates a new version object from the {Chef::VERSION}.
      #
      # @example Check if Chef 11+
      #   chef_version.satisfies?('>= 11.0.0')
      #
      # @return [Chef::Sugar::Constraints::Version]
      #   a version object, wrapping the current {Chef::VERSION}
      #
      def chef_version
        version(Chef::VERSION)
      end
    end
  end
end
