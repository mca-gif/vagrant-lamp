class Chef
  module Sugar
    module Filters
      #
      # Evaluate resources at compile time instead of converge time.
      #
      class CompileTime
        def initialize(recipe)
          @recipe = recipe
        end

        def evaluate(&block)
          instance_eval(&block)
        end

        def method_missing(m, *args, &block)
          resource = @recipe.send(m, *args, &block)

          if resource.is_a?(Chef::Resource)
            actions = Array(resource.action)
            resource.action(:nothing)

            actions.each do |action|
              resource.run_action(action)
            end
          end

          resource
        end
      end

      #
      # A top-level class for manipulation the resource collection.
      #
      class Injector
        def initialize(recipe, identifier, placement)
          @recipe              = recipe
          @resource_collection = @recipe.run_context.resource_collection
          @resource            = @resource_collection.lookup(identifier)
          @placement           = placement
        end

        def evaluate(&block)
          instance_eval(&block)
        end

        def insert_before(resource, new_resource)
          @resource_collection.instance_eval do
            # Remove the resource because it's automatically created
            @resources.delete_at(@resources_by_name[new_resource.to_s])
            @resources_by_name.delete(new_resource.to_s)

            index = @resources_by_name[resource.to_s]
            @resources.insert(index, new_resource)
            @resources_by_name[new_resource.to_s] = index
          end
        end

        def insert_after(resource, new_resource)
          @resource_collection.instance_eval do
            # Remove the resource because it's automatically created
            @resources.delete_at(@resources_by_name[new_resource.to_s])
            @resources_by_name.delete(new_resource.to_s)

            index = @resources_by_name[resource.to_s] + 2
            @resources.insert(index, new_resource)
            @resources_by_name[new_resource.to_s] = index
          end
        end

        def method_missing(m, *args, &block)
          new_resource = @recipe.send(m, *args, &block)

          case @placement
          when :before
            insert_before(@resource, new_resource)
          when :after
            insert_after(@resource, new_resource)
          else
            super
          end
        end
      end
    end

    module DSL
      #
      # Dynamically run resources specified in the block during the compilation
      # phase, instead of the convergence phase.
      #
      # @example The old way
      #   package('apache2') do
      #     action :nothing
      #   end.run_action(:install)
      #
      # @example The new way
      #   compile_time do
      #     package('apache2')
      #   end
      #
      # @example Resource actions are run in order
      #   compile_time do
      #     service 'apache2' do
      #       action [:enable, :start] # run_action(:enable), run_action(:start)
      #     end
      #   end
      #
      def compile_time(&block)
        Chef::Sugar::Filters::CompileTime.new(self).evaluate(&block)
      end

      #
      # Dynamically insert resources before an existing resource in the
      # resource_collection.
      #
      # @example Write a custom template before the apache2 service actions
      #          are run
      #   before 'service[apache2]' do
      #     template '/etc/apache2/thing.conf' do
      #       source '...'
      #     end
      #   end
      #
      #
      # @param [String] identifier
      #   the +resource[name]+ identifier string
      #
      def before(identifier, &block)
        Chef::Sugar::Filters::Injector.new(self, identifier, :before).evaluate(&block)
      end

      #
      # Dynamically insert resources after an existing resource in the
      # resource_collection.
      #
      # @example Write a custom template after the apache2 service actions
      #          are run
      #   after 'service[apache2]' do
      #     template '/etc/apache2/thing.conf' do
      #       source '...'
      #     end
      #   end
      #
      #
      # @param [String] identifier
      #   the +resource[name]+ identifier string
      #
      def after(identifier, &block)
        Chef::Sugar::Filters::Injector.new(self, identifier, :after).evaluate(&block)
      end
    end
  end
end
