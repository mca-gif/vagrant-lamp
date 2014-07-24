require 'spec_helper'

describe Chef::Sugar::IP do
  it_behaves_like 'a chef sugar'

  let(:node)  { { 'ipaddress' => '1.2.3.4' } }
  let(:other) { { 'ipaddress' => '5.6.7.8' } }

  context 'when not on a cloud' do
    it 'returns the default IP address' do
      expect(described_class.best_ip_for(node, other)).to eq(other['ipaddress'])
    end
  end

  context 'when the target is on the cloud' do
    before do
      other['cloud'] = {}
      other['cloud']['provider']    = 'ec2'
      other['cloud']['local_ipv4']  = '9.10.11.12'
      other['cloud']['public_ipv4'] = '13.14.15.16'

      node['cloud'] = nil
    end

    context 'when the current node is not on the cloud' do
      it 'uses the public ipv4' do
        expect(described_class.best_ip_for(node, other)).to eq('13.14.15.16')
      end
    end

    context 'when the current node is on a different cloud' do
      before do
        node['cloud'] = {}
        node['cloud']['provider'] = 'rackspace'
      end

      it 'uses the public ipv4' do
        expect(described_class.best_ip_for(node, other)).to eq('13.14.15.16')
      end
    end

    context 'when the current node is on the same cloud' do
      before do
        node['cloud'] = {}
        node['cloud']['provider'] = 'ec2'
      end

      it 'uses the local ipv4' do
        expect(described_class.best_ip_for(node, other)).to eq('9.10.11.12')
      end
    end
  end
end
