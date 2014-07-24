require 'spec_helper'

describe Chef::Sugar::Platform do
  it_behaves_like 'a chef sugar'

  describe '#linux_mint?' do
    it 'returns true when the platform is linux mint' do
      node = { 'platform' => 'linuxmint' }
      expect(described_class.linux_mint?(node)).to be_truthy
    end

    it 'returns false when the platform is not linux mint' do
      node = { 'platform' => 'windows' }
      expect(described_class.linux_mint?(node)).to be_falsey
    end
  end

  describe '#ubuntu?' do
    it 'returns true when the platform is ubuntu' do
      node = { 'platform' => 'ubuntu' }
      expect(described_class.ubuntu?(node)).to be_truthy
    end

    it 'returns false when the platform is not ubuntu' do
      node = { 'platform' => 'windows' }
      expect(described_class.ubuntu?(node)).to be_falsey
    end
  end

  describe '#amazon_linux?' do
    it 'returns true when the platform is amazon linux' do
      node = { 'platform' => 'amazon' }
      expect(described_class.amazon_linux?(node)).to be_truthy
    end

    it 'returns false when the platform is not amazon linux' do
      node = { 'platform' => 'windows' }
      expect(described_class.amazon_linux?(node)).to be_falsey
    end
  end

  describe '#centos?' do
    it 'returns true when the platform is centos' do
      node = { 'platform' => 'centos' }
      expect(described_class.centos?(node)).to be_truthy
    end

    it 'returns false when the platform is not centos' do
      node = { 'platform' => 'windows' }
      expect(described_class.centos?(node)).to be_falsey
    end
  end

  describe '#oracle_linux?' do
    it 'returns true when the platform is oracle linux' do
      node = { 'platform' => 'oracle' }
      expect(described_class.oracle_linux?(node)).to be_truthy
    end

    it 'returns false when the platform is not oracle linux' do
      node = { 'platform' => 'windows' }
      expect(described_class.oracle_linux?(node)).to be_falsey
    end
  end

  describe '#scientific_linux?' do
    it 'returns true when the platform is scientific linux' do
      node = { 'platform' => 'scientific' }
      expect(described_class.scientific_linux?(node)).to be_truthy
    end

    it 'returns false when the platform is not scientific linux' do
      node = { 'platform' => 'windows' }
      expect(described_class.scientific_linux?(node)).to be_falsey
    end
  end

  describe '#redhat_enterprise_linux?' do
    it 'returns true when the platform is redhat enterprise linux' do
      node = { 'platform' => 'enterprise' }
      expect(described_class.redhat_enterprise_linux?(node)).to be_truthy
    end

    it 'returns false when the platform is not redhat enterprise linux' do
      node = { 'platform' => 'windows' }
      expect(described_class.redhat_enterprise_linux?(node)).to be_falsey
    end
  end

  describe '#solaris2?' do
    it 'returns true when the platform is solaris2' do
      node = { 'platform' => 'solaris2' }
      expect(described_class.solaris2?(node)).to be_truthy
    end

    it 'returns false when the platform is not solaris2' do
      node = { 'platform' => 'windows' }
      expect(described_class.solaris2?(node)).to be_falsey
    end
  end

  describe '#aix?' do
    it 'returns true when the platform is aix' do
      node = { 'platform' => 'aix' }
      expect(described_class.aix?(node)).to be_truthy
    end

    it 'returns false when the platform is not aix' do
      node = { 'platform' => 'windows' }
      expect(described_class.aix?(node)).to be_falsey
    end
  end

  context 'dynamic matchers' do
    describe '#ubuntu_after_lucid?' do
      it 'returns true when the version is later than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.10' }
        expect(described_class.ubuntu_after_lucid?(node)).to be_truthy
      end

      it 'returns false when the version is 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04' }
        expect(described_class.ubuntu_after_lucid?(node)).to be_falsey
      end

      it 'returns false when the version is a patch release higher than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04.4' }
        expect(described_class.ubuntu_after_lucid?(node)).to be_falsey
      end

      it 'returns false when the version is less than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '9.10' }
        expect(described_class.ubuntu_after_lucid?(node)).to be_falsey
      end
    end

    describe '#ubuntu_after_or_at_lucid?' do
      it 'returns true when the version is later than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.10' }
        expect(described_class.ubuntu_after_or_at_lucid?(node)).to be_truthy
      end

      it 'returns true when the version is 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04' }
        expect(described_class.ubuntu_after_or_at_lucid?(node)).to be_truthy
      end

      it 'returns true when the version is a patch release higher than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04.4' }
        expect(described_class.ubuntu_after_or_at_lucid?(node)).to be_truthy
      end

      it 'returns false when the version is less than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '9.10' }
        expect(described_class.ubuntu_after_or_at_lucid?(node)).to be_falsey
      end
    end

    describe '#ubuntu_lucid?' do
      it 'returns false when the version is later than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.10' }
        expect(described_class.ubuntu_lucid?(node)).to be_falsey
      end

      it 'returns true when the version is 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04' }
        expect(described_class.ubuntu_lucid?(node)).to be_truthy
      end

      it 'returns true when the version is a patch release higher than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04.4' }
        expect(described_class.ubuntu_lucid?(node)).to be_truthy
      end

      it 'returns false when the version is less than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '9.10' }
        expect(described_class.ubuntu_lucid?(node)).to be_falsey
      end
    end

    describe '#ubuntu_before_lucid?' do
      it 'returns false when the version is later than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.10' }
        expect(described_class.ubuntu_before_lucid?(node)).to be_falsey
      end

      it 'returns false when the version is 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04' }
        expect(described_class.ubuntu_before_lucid?(node)).to be_falsey
      end

      it 'returns false when the version is a patch release higher than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04.4' }
        expect(described_class.ubuntu_before_lucid?(node)).to be_falsey
      end

      it 'returns true when the version is less than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '9.10' }
        expect(described_class.ubuntu_before_lucid?(node)).to be_truthy
      end
    end

    describe '#ubuntu_before_or_at_lucid?' do
      it 'returns false when the version is later than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.10' }
        expect(described_class.ubuntu_before_or_at_lucid?(node)).to be_falsey
      end

      it 'returns true when the version is 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04' }
        expect(described_class.ubuntu_before_or_at_lucid?(node)).to be_truthy
      end

      it 'returns true when the version is a patch release higher than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '10.04.4' }
        expect(described_class.ubuntu_before_or_at_lucid?(node)).to be_truthy
      end

      it 'returns true when the version is less than 10.04' do
        node = { 'platform' => 'ubuntu', 'platform_version' => '9.10' }
        expect(described_class.ubuntu_before_or_at_lucid?(node)).to be_truthy
      end
    end

    describe '#debian_wheezy?' do
      it 'returns true when the version is a subset of the major' do
        node = { 'platform' => 'debian', 'platform_version' => '7.1' }
        expect(described_class.debian_wheezy?(node)).to be_truthy
      end

      it 'returns false when the version is not the major' do
        node = { 'platform' => 'debian', 'platform_version' => '6.1' }
        expect(described_class.debian_wheezy?(node)).to be_falsey
      end
    end

    describe '#debian_before_wheezy?' do
      it 'returns true when the version is a less than the major' do
        node = { 'platform' => 'debian', 'platform_version' => '6.5' }
        expect(described_class.debian_before_wheezy?(node)).to be_truthy
      end

      it 'returns false when the version is not less than the major' do
        node = { 'platform' => 'debian', 'platform_version' => '8.0' }
        expect(described_class.debian_before_wheezy?(node)).to be_falsey
      end
    end
  end
end
