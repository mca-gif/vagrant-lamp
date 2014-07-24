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
    module Kernel
      class ChefGemLoadError < StandardError
        def initialize(name)
          super <<-EOH
Chef could not load the gem `#{name}'! You may need to install the gem manually
with `gem install #{name}', or include a recipe before you can use this
resource. Please consult the documentation for this cookbook for proper usage.
EOH
        end
      end

      #
      # Require a gem that should have been installed by Chef, such as in a
      # recipes as a +chef_gem+. This method will gracefully degrade if the
      # gem cannot be loaded.
      #
      # @param [String] name
      #   the name of the gem to install
      #
      # @return [Boolean]
      #   true if the require is successful and false if the gem is already
      #   loaded
      #
      def require_chef_gem(name)
        require(name)
      rescue LoadError
        raise ChefGemLoadError.new(name)
      end
    end
  end
end
