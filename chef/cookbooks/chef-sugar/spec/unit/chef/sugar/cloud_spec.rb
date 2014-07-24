require 'spec_helper'

describe Chef::Sugar::Cloud do
  it_behaves_like 'a chef sugar'

  describe '#cloud?' do
    it 'is true when the node is on cloud' do
      node = { 'cloud' => nil }
      expect(described_class.cloud?(node)).to be_truthy
    end

    it 'is false when the node is not on cloud' do
      node = {}
      expect(described_class.cloud?(node)).to be_falsey
    end
  end

  describe '#ec2?' do
    it 'is true when the node is on ec2' do
      node = { 'ec2' => nil }
      expect(described_class.ec2?(node)).to be_truthy
    end

    it 'is false when the node is not on ec2' do
      node = {}
      expect(described_class.ec2?(node)).to be_falsey
    end
  end

  describe '#gce?' do
    it 'is true when the node is on gce' do
      node = { 'gce' => nil }
      expect(described_class.gce?(node)).to be_truthy
    end

    it 'is false when the node is not on gce' do
      node = {}
      expect(described_class.gce?(node)).to be_falsey
    end
  end

  describe '#rackspace?' do
    it 'is true when the node is on rackspace' do
      node = { 'rackspace' => nil }
      expect(described_class.rackspace?(node)).to be_truthy
    end

    it 'is false when the node is not on rackspace' do
      node = {}
      expect(described_class.rackspace?(node)).to be_falsey
    end
  end

  describe '#eucalyptus?' do
    it 'is true when the node is on eucalyptus' do
      node = { 'eucalyptus' => nil }
      expect(described_class.eucalyptus?(node)).to be_truthy
    end

    it 'is false when the node is not on eucalyptus' do
      node = {}
      expect(described_class.eucalyptus?(node)).to be_falsey
    end
  end

  describe '#euca?' do
    it 'is true when the node is on eucalyptus' do
      node = { 'eucalyptus' => nil }
      expect(described_class.euca?(node)).to be_truthy
    end

    it 'is false when the node is not on eucalyptus' do
      node = {}
      expect(described_class.euca?(node)).to be_falsey
    end
  end

  describe '#linode?' do
    it 'is true when the node is on linode' do
      node = { 'linode' => nil }
      expect(described_class.linode?(node)).to be_truthy
    end

    it 'is false when the node is not on linode' do
      node = {}
      expect(described_class.linode?(node)).to be_falsey
    end
  end

  describe '#openstack?' do
    it 'is true when the node is on openstack' do
      node = { 'openstack' => nil }
      expect(described_class.openstack?(node)).to be_truthy
    end

    it 'is false when the node is not on openstack' do
      node = {}
      expect(described_class.openstack?(node)).to be_falsey
    end
  end

  describe '#cloudstack?' do
    it 'is true when the node is on cloudstack' do
      node = { 'cloudstack' => nil }
      expect(described_class.cloudstack?(node)).to be_truthy
    end

    it 'is false when the node is not on cloudstack' do
      node = {}
      expect(described_class.cloudstack?(node)).to be_falsey
    end
  end

  describe '#azure?' do
    it 'is true when the node is on azure' do
      node = { 'azure' => nil }
      expect(described_class.azure?(node)).to be_truthy
    end

    it 'is false when the node is not on azure' do
      node = {}
      expect(described_class.azure?(node)).to be_falsey
    end
  end
end
