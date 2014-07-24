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
  class Node
    class AttributeDoesNotExistError < StandardError
      def initialize(keys)
        hash = keys.map { |key| "['#{key}']" }

        super <<-EOH
No attribute `node#{hash.join}' exists on
the current node. Please make sure you have spelled everything correctly.
EOH
      end
    end
    #
    # Determine if the current node is in the given Chef environment
    # (or matches the given regular expression).
    #
    # @param [String, Regex] environment
    #
    # @return [Boolean]
    #
    def in?(environment)
      environment === chef_environment
    end

    #
    # Safely fetch a deeply nested attribute by specifying a list of keys,
    # bypassing Ruby's Hash notation. This method swallows +NoMethodError+
    # exceptions, avoiding the most common error in Chef-land.
    #
    # This method will return +nil+ if any deeply nested key does not exist.
    #
    # @see [Node#deep_fetch!]
    #
    def deep_fetch(*keys)
      deep_fetch!(*keys)
    rescue NoMethodError, AttributeDoesNotExistError
      nil
    end

    #
    # Deeply fetch a node attribute by specifying a list of keys, bypassing
    # Ruby's Hash notation.
    #
    # This method will raise any exceptions, such as
    # +undefined method `[]' for nil:NilClass+, just as if you used the native
    # attribute notation. If you want a safely vivified hash, see {deep_fetch}.
    #
    # @example Fetch a deeply nested key
    #   node.deep_fetch(:foo, :bar, :zip) #=> node['foo']['bar']['zip']
    #
    # @param [Array<String, Symbol>] keys
    #   the list of keys to kdeep fetch
    #
    # @return [Object]
    #
    def deep_fetch!(*keys)
      keys.map!(&:to_s)

      keys.inject(attributes.to_hash) do |hash, key|
        hash[key]
      end
    rescue NoMethodError
      raise AttributeDoesNotExistError.new(keys)
    end

    #
    # Dynamically define the current namespace. Multiple namespaces may be
    # nested.
    #
    # @example Define a simple namespace
    #
    #   namespace 'apache2' do
    #     # ...
    #   end
    #
    # @example Define a nested namespace
    #
    #   namespace 'apache2', 'config' do
    #     # ...
    #   end
    #
    # @example Define a complex nested namespace
    #
    #   namespace 'apache2' do
    #     namespace 'config' do
    #       # ...
    #     end
    #   end
    #
    # @example Define a namespace with a custom precedence level
    #
    #   namespace 'apache2', precedence: normal do
    #     # Attributes here will use the "normal" level
    #   end
    #
    # @example Define different nested precedence levels
    #
    #   namespace 'apache2', precedence: normal do
    #     # Attributes defined here will use the "normal" level
    #
    #     namespace 'config', precedence: override do
    #       # Attributes defined  here will use the "override" level
    #     end
    #   end
    #
    #
    # @param [Array] args
    #   the list of arguments (such as the namespace and precedence levels)
    #   the user gave
    # @param [Proc] block
    #   the nested evaluation context
    #
    # @return [nil]
    #   to prevent accidential method chaining if the block isn't closed
    #
    def namespace(*args, &block)
      @namespace_options = namespace_options.merge(args.last.is_a?(Hash) ? args.pop : {})

      keys = args.map(&:to_s)

      @current_namespace = current_namespace + keys
      instance_eval(&block)
      @current_namespace = current_namespace - keys

      nil
    end

    alias_method :old_method_missing, :method_missing
    #
    # Provide a nice DSL for defining attributes. +method_missing+ is called
    # on all the attribute names. For more information on how to use the DSL,
    # see the class-level documentation.
    #
    # @return [nil]
    #   to prevent accidential method chaining if the block isn't closed
    #
    def method_missing(m, *args, &block)
      old_method_missing(m, *args, &block)
    rescue NoMethodError
      vivified[m.to_s] = args.size == 1 ? args.first : args
      nil
    end

    private

    #
    # The namespace options.
    #
    # @return [Hash]
    #
    def namespace_options
      @namespace_options ||= {
        precedence: default
      }
    end

    #
    # The current namespace. This is actually a reverse-ordered array that
    # vivifies the correct hash.#
    #
    # @return [Array<String>]
    #
    def current_namespace
      @current_namespace ||= []
    end

    #
    # The vivified (fake-filled) hash. It is assumed that the default value
    # for non-existent keys in the hash is a new, empty hash.
    #
    # @return [Hash<String, Hash>]
    #
    def vivified
      current_namespace.inject(namespace_options[:precedence]) do |hash, item|
        hash[item] ||= {}
        hash[item]
      end
    end
  end
end
