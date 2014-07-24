require 'spec_helper'
require 'chef/sugar/core_extensions'

describe Array do
  describe '#satisfied_by?' do
    it 'includes the method' do
      expect(described_class).to be_method_defined(:satisfied_by?)
    end
  end
end
