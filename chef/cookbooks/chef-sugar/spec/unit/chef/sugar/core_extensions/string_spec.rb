require 'spec_helper'
require 'chef/sugar/core_extensions'

describe String do
  describe '#satisfies?' do
    it 'includes the method' do
      expect(described_class).to be_method_defined(:satisfies?)
    end
  end

  describe '#satisfied_by?' do
    it 'includes the method' do
      expect(described_class).to be_method_defined(:satisfied_by?)
    end
  end

  describe '#flush' do
    context 'when given a single-line string' do
      it 'strips trailing whitespace' do
        string = <<-EOH
          This is a string
        EOH
        expect(string.flush).to eq('This is a string')
      end
    end

    context 'when given a multi-line string' do
      it 'removes the leading number of whitespaces' do
        string = <<-EOH
          def method
            "This is a string!"
          end
        EOH
        expect(string.flush).to eq(%Q(def method\n  "This is a string!"\nend))
      end

      it 'leaves a newline when given' do
        string = <<-EOH
          def method
            "This is a string!"
          end

        EOH
        expect(string.flush).to eq(%Q(def method\n  "This is a string!"\nend\n))
      end
    end
  end
end
