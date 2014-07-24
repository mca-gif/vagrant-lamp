require 'spec_helper'

describe Chef::Sugar::Kernel do
  describe '.require_chef_gem' do
    it 'raises an exception when the gem is not installed' do
      expect {
        described_class.require_chef_gem('bacon')
      }.to raise_error(Chef::Sugar::Kernel::ChefGemLoadError)
    end

    it 'loads the gem' do
      allow(Chef::Sugar::Kernel).to receive(:require).and_return(true)
      expect(described_class.require_chef_gem('bacon')).to be_truthy
    end
  end
end
