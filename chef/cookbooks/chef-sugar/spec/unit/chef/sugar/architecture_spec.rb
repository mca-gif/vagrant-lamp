require 'spec_helper'

describe Chef::Sugar::Architecture do
  it_behaves_like 'a chef sugar'

  describe '#_64_bit?' do
    it 'returns true when the system is 64 bit' do
      node = { 'kernel' => { 'machine' => 'x86_64' } }
      expect(described_class._64_bit?(node)).to be_truthy
    end

    it 'returns false when the system is not 64 bit' do
      node = { 'kernel' => { 'machine' => 'i386' } }
      expect(described_class._64_bit?(node)).to be_falsey
    end
  end

  describe '#_32_bit?' do
    it 'returns true when the system is 32 bit' do
      node = { 'kernel' => { 'machine' => 'i386' } }
      expect(described_class._32_bit?(node)).to be_truthy
    end

    it 'returns false when the system is not 32 bit' do
      node = { 'kernel' => { 'machine' => 'x86_64' } }
      expect(described_class._32_bit?(node)).to be_falsey
    end
  end
end
