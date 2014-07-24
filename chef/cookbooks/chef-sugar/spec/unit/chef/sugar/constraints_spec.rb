require 'spec_helper'

describe Chef::Sugar::Constraints do
  # it_behaves_like 'a chef sugar'

  describe '#version' do
    let(:version) { described_class.version('1.2.3') }

    it 'returns a new version object' do
      expect(version).to be_a(Chef::Sugar::Constraints::Version)
    end

    it 'returns true with the version is satisifed' do
      expect(version).to be_satisfies('~> 1.2.0')
    end

    it 'returns false when the version is not satisfed' do
      expect(version).to_not be_satisfies('~> 2.0.0')
    end
  end

  describe '#constraint' do
    let(:constraint) { described_class.constraint('~> 1.2.0') }

    it 'returns a new constraint object' do
      expect(constraint).to be_a(Chef::Sugar::Constraints::Constraint)
    end

    it 'returns true when the constraint is satisfied' do
      expect(constraint).to be_satisfied_by('1.2.3')
    end

    it 'returns false when the constraint is not satisfied' do
      expect(constraint).to_not be_satisfied_by('2.0.0')
    end
  end

  describe '#chef_version' do
    it 'is a DSL method' do
      expect(Chef::Sugar::DSL).to be_method_defined(:chef_version)
    end
  end
end
