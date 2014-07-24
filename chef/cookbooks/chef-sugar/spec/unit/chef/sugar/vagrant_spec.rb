require 'spec_helper'

describe Chef::Sugar::Vagrant do
  it_behaves_like 'a chef sugar'

  describe '#vagrant?' do
    it 'returns true when the machine is on vagrant' do
      node = { 'vagrant' => {} }
      expect(described_class.vagrant?(node)).to be_truthy
    end

    it 'returns true when the domain is vagrantup.com' do
      node = { 'domain' => 'bacon.vagrantup.com' }
      expect(described_class.vagrant?(node)).to be_truthy
    end

    it 'returns true when the vagrant user exists on the system' do
      node = { 'etc' => { 'passwd' => { 'vagrant' => {} } } }
      expect(described_class.vagrant?(node)).to be_truthy
    end

    it 'returns false when the machine is not on vagrant' do
      node = {}
      expect(described_class.vagrant?(node)).to be_falsey
    end
  end
end
