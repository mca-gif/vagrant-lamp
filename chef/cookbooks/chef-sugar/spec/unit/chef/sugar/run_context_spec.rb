require 'spec_helper'

describe Chef::Sugar::RunContext do
  it_behaves_like 'a chef sugar'

  describe '#includes_recipe?' do
    let(:node) { double(Chef::Node) }

    it 'returns true when the recipe exists' do
      allow(node).to receive(:recipe?).and_return(true)
      expect(described_class.includes_recipe?(node, 'foo')).to be_truthy
    end

    it 'returns false when the recipe does not exist' do
      allow(node).to receive(:recipe?).and_return(false)
      expect(described_class.includes_recipe?(node, 'bar')).to be_falsey
    end
  end
end
