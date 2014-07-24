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

# require_relative '../constraints'

class String
  #
  # Treat strings as version objects.
  #
  # @see Chef::Sugar::Constraints::Version
  #
  # @example Using pure string objects like versions
  #   '1.2.3'.satisfies?('~> 1.2.0')
  #
  # @param [String, Array<String>] constraints
  #   the list of constraints to satisfy
  #
  def satisfies?(*constraints)
    Chef::Sugar::Constraints::Version.new(dup).satisfies?(*constraints)
  end unless method_defined?(:satisfies?)

  #
  # Treat strings as version constraints.
  #
  # @see Chef::Sugar::Constraints::Constraint
  #
  # @example Using pure string objects like constraints
  #   '~> 1.2.0'.satisfied_by?('1.2.3')
  #
  # @param [String] version
  #   the version to check if it is satisfied
  #
  def satisfied_by?(version)
    Chef::Sugar::Constraints::Constraint.new(dup).satisfied_by?(version)
  end unless method_defined?(:satisfied_by?)

  #
  # Left-flush a string based off of the number of whitespace characters on the
  # first line. This is especially useful for heredocs when whitespace matters.
  #
  # @example Remove leading whitespace and flush
  #   <<-EOH.flush
  #     def method
  #       'This is a string!'
  #     end
  #   EOH #=>"def method\n  'This is a string!'\nend"
  #
  # @return [String]
  #
  def flush
    gsub(/^#{self[/\A\s*/]}/, '').chomp
  end unless method_defined?(:flush)
end
