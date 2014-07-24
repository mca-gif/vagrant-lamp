require 'spec_helper'

describe Chef::Sugar::Ruby do
  it_behaves_like 'a chef sugar'

  describe '#ruby_20?' do
    it 'returns true when the ruby version is 2.0' do
      node = { 'languages' => { 'ruby' => { 'version' => '2.0.0' } } }
      expect(described_class.ruby_20?(node)).to be_truthy
    end

    it 'returns true when the ruby version is less than 2.0' do
      node = { 'languages' => { 'ruby' => { 'version' => '1.9.3' } } }
      expect(described_class.ruby_20?(node)).to be_falsey
    end

    it 'returns false when the ruby version is higher than 2.0' do
      node = { 'languages' => { 'ruby' => { 'version' => '3.0.0' } } }
      expect(described_class.ruby_20?(node)).to be_falsey
    end
  end

  describe '#ruby_19?' do
    it 'returns true when the ruby version is 1.9' do
      node = { 'languages' => { 'ruby' => { 'version' => '1.9.1' } } }
      expect(described_class.ruby_19?(node)).to be_truthy
    end

    it 'returns true when the ruby version is less than 1.9' do
      node = { 'languages' => { 'ruby' => { 'version' => '1.8.7' } } }
      expect(described_class.ruby_19?(node)).to be_falsey
    end

    it 'returns false when the ruby version is higher than 1.9' do
      node = { 'languages' => { 'ruby' => { 'version' => '2.0.0' } } }
      expect(described_class.ruby_19?(node)).to be_falsey
    end
  end
end
