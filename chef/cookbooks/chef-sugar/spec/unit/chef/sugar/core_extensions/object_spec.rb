require 'spec_helper'
require 'chef/sugar/core_extensions'

describe Object do
  describe '#blank?' do
    it 'includes the method' do
      expect(described_class).to be_method_defined(:blank?)
    end

    it 'returns true for nil' do
      expect(nil).to be_blank
    end

    it 'returns true for false' do
      expect(false).to be_blank
    end

    it 'returns true for the empty string' do
      expect('').to be_blank
    end

    it 'returns true for the empty array' do
      expect([]).to be_blank
    end

    it 'returns true for the empty hash' do
      expect({}).to be_blank
    end

    it 'returns false for a non-empty string' do
      expect('  ').to_not be_blank
    end

    it 'returns false for a non-empty string with unicode' do
      expect("\u00a0").to_not be_blank
    end

    it 'returns false for a non-empty string with special characters' do
      expect("\n\t").to_not be_blank
    end

    it 'returns false for any object' do
      expect(Object.new).to_not be_blank
    end

    it 'returns false for true' do
      expect(true).to_not be_blank
    end

    it 'returns false for a fixnum' do
      expect(1).to_not be_blank
    end

    it 'returns false for an array with items' do
      expect(['foo']).to_not be_blank
    end

    it 'returns false for an array with items' do
      expect({'foo' => 'bar'}).to_not be_blank
    end
  end
end
