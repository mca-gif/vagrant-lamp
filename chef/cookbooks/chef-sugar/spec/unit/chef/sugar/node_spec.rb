require 'spec_helper'

describe Chef::Node do
  describe '#in?' do
    it 'returns true when the node is in the environment' do
      allow(subject).to receive(:chef_environment).and_return('production')
      expect(subject.in?('production')).to be_truthy
      expect(subject.in?(/production$/)).to be_truthy
    end

    it 'returns false when the node is not in the environment' do
      allow(subject).to receive(:chef_environment).and_return('staging')
      expect(subject.in?('production')).to be_falsey
      expect(subject.in?(/production$/)).to be_falsey
    end
  end

  describe '#deep_fetch' do
    let(:node) { described_class.new }
    before { node.default['apache2']['config']['root'] = '/var/www' }

    it 'fetches a deeply nested attribute' do
      expect(node.deep_fetch('apache2', 'config', 'root')).to eq('/var/www')
    end

    it 'ignores symbols, strings, etc' do
      expect(node.deep_fetch(:apache2, :config, :root)).to eq('/var/www')
    end

    it 'safely returns nil if a key does not exist' do
      expect(node.deep_fetch(:apache2, :not_real, :nested, :yup)).to be_nil
    end
  end

  describe '#deep_fetch!' do
    let(:node) { described_class.new }
    before { node.default['apache2']['config']['root'] = '/var/www' }

    it 'fetches a deeply nested attribute' do
      expect(node.deep_fetch!('apache2', 'config', 'root')).to eq('/var/www')
    end

    it 'ignores symbols, strings, etc' do
      expect(node.deep_fetch!(:apache2, :config, :root)).to eq('/var/www')
    end

    it 'raises an error if a key does not exist' do
      expect {
        node.deep_fetch!(:apache2, :not_real, :nested, :yup)
      }.to raise_error(Chef::Node::AttributeDoesNotExistError)
    end
  end

  describe '#namespace' do
    let(:node) { described_class.new }

    it 'defines the attributes' do
      node.instance_eval do
        namespace 'apache2' do
          namespace 'config' do
            root '/var/www'
          end
        end
      end

      expect(node.default).to eq({
        'apache2' => {
          'config' => { 'root' => '/var/www' }
        }
      })
    end

    it 'accepts multiple attributes' do
      node.instance_eval do
        namespace 'apache2', 'config' do
          root '/var/www'
        end
      end

      expect(node.default).to eq({
        'apache2' => {
          'config' => { 'root' => '/var/www' }
        }
      })
    end

    it 'accepts attribute precedence levels' do
      node.instance_eval do
        namespace 'apache2', precedence: normal do
          namespace 'config', precedence: override do
            root '/var/www'
          end
        end
      end

      expect(node.override).to eq({
        'apache2' => {
          'config' => { 'root' => '/var/www' }
        }
      })
    end
  end

end
