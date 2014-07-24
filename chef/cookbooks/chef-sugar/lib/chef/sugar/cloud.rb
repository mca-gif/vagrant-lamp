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
    module Cloud
      extend self

      #
      # Return true if the current current node is in "the cloud".
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def cloud?(node)
        node.key?('cloud')
      end

      #
      # Return true if the current current node is in EC2
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def ec2?(node)
        node.key?('ec2')
      end

      #
      # Return true if the current current node is in GCE
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def gce?(node)
        node.key?('gce')
      end

      #
      # Return true if the current current node is in Rackspace
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def rackspace?(node)
        node.key?('rackspace')
      end

      #
      # Return true if the current current node is in Eucalyptus
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def eucalyptus?(node)
        node.key?('eucalyptus')
      end
      alias_method :euca?, :eucalyptus?

      #
      # Return true if the current current node is in Linode
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def linode?(node)
        node.key?('linode')
      end

      #
      # Return true if the current current node is in Openstack
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def openstack?(node)
        node.key?('openstack')
      end

      #
      # Return true if the current current node is in Cloudstack
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def cloudstack?(node)
        node.key?('cloudstack')
      end

      #
      # Return true if the current current node is in Azure
      #
      # @param [Chef::Node] node
      #   the node to check
      #
      # @return [Boolean]
      #
      def azure?(node)
        node.key?('azure')
      end
    end

    module DSL
      # @see Chef::Sugar::Cloud#cloud?
      def cloud?; Chef::Sugar::Cloud.cloud?(node); end

      # @see Chef::Sugar::Cloud#ec2?
      def ec2?; Chef::Sugar::Cloud.ec2?(node); end

      # @see Chef::Sugar::Cloud#gce?
      def gce?; Chef::Sugar::Cloud.gce?(node); end

      # @see Chef::Sugar::Cloud#rackspace?
      def rackspace?; Chef::Sugar::Cloud.rackspace?(node); end

      # @see Chef::Sugar::Cloud#eucalyptus?
      def eucalyptus?; Chef::Sugar::Cloud.eucalyptus?(node); end
      alias_method :euca?, :eucalyptus?

      # @see Chef::Sugar::Cloud#linode?
      def linode?; Chef::Sugar::Cloud.linode?(node); end

      # @see Chef::Sugar::Cloud#openstack?
      def openstack?; Chef::Sugar::Cloud.openstack?(node); end

      # @see Chef::Sugar::Cloud#cloudstack?
      def cloudstack?; Chef::Sugar::Cloud.cloudstack?(node); end

      # @see Chef::Sugar::Cloud#azure?
      def azure?; Chef::Sugar::Cloud.azure?(node); end
    end
  end
end
