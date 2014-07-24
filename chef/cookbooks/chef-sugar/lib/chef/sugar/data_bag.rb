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
    module DataBag
      class EncryptedDataBagSecretNotGiven < StandardError
        def initialize
          super <<-EOH
You did not set your `encrypted_data_bag_secret'! In order to use the
`encrypted_data_bag_item' helper, you must load your encrypted data bag secret
into the `Chef::Config'.

Alternatively, you can pass the secret key as the last parameter to the method
call. For more information, please see
http://docs.opscode.com/chef/essentials_data_bags.html#access-from-recipe.
EOH
        end
      end

      extend self

      #
      # Helper method for loading an encrypted data bag item in a similar
      # syntax/recipe DSL method.
      #
      # @param [String] bag
      #   the name of the encrypted data bag
      # @param [String] id
      #   the id of the encrypted data bag
      # @param [String] secret
      #   the encrypted data bag secret raw value
      #
      # @return [Hash]
      #
      def encrypted_data_bag_item(bag, id, secret = nil)
        Chef::Log.debug "Loading encrypted data bag item #{bag}/#{id}"

        if secret.nil? && Chef::Config[:encrypted_data_bag_secret].nil?
          raise EncryptedDataBagSecretNotGiven.new
        end

        secret ||= File.read(Chef::Config[:encrypted_data_bag_secret]).strip
        Chef::EncryptedDataBagItem.load(bag, id, secret)
      end

      #
      # This algorithm attempts to find the data bag entry for the current
      # node's Chef environment. If there are no environment-specific
      # values, the "default" bucket is used. The data bag must follow the
      # schema:
      #
      #   {
      #     "default": {...},
      #     "environment_name": {...},
      #     "other_environment": {...},
      #   }
      #
      # @param [Node] node
      #   the current Chef node
      # @param [String] bag
      #   the name of the encrypted data bag
      # @param [String] id
      #   the id of the encrypted data bag
      # @param [String] secret
      #   the encrypted data bag secret (default's to the +Chef::Config+ value)
      #
      # @return [Hash]
      #
      def encrypted_data_bag_item_for_environment(node, bag, id, secret = nil)
        data = encrypted_data_bag_item(bag, id, secret)

        if data[node.chef_environment]
          Chef::Log.debug "Using #{node.chef_environment} as the key"
          data[node.chef_environment]
        else
          Chef::Log.debug "#{node.chef_environment} key does not exist, using `default`"
          data['default']
        end
      end
    end

    module DSL
      # @see Chef::Sugar::DataBag#encrypted_data_bag_item
      def encrypted_data_bag_item(bag, id, secret = nil)
        Chef::Sugar::DataBag.encrypted_data_bag_item(bag, id, secret)
      end

      # @see Chef::Sugar::DataBag#encrypted_data_bag_item_for_environment
      def encrypted_data_bag_item_for_environment(bag, id, secret = nil)
        Chef::Sugar::DataBag.encrypted_data_bag_item_for_environment(node, bag, id, secret)
      end
    end
  end
end
