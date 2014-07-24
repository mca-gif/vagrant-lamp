require 'spec_helper'

describe Chef::Sugar::PlatformFamily do
  it_behaves_like 'a chef sugar'

  describe '#arch_linux?' do
    it 'returns true when the platform_family is arch linux' do
      node = { 'platform_family' => 'arch' }
      expect(described_class.arch_linux?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not arch linux' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.arch_linux?(node)).to be_falsey
    end
  end

  describe '#debian?' do
    it 'returns true when the platform_family is debian' do
      node = { 'platform_family' => 'debian' }
      expect(described_class.debian?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not debian' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.debian?(node)).to be_falsey
    end
  end

  describe '#fedora?' do
    it 'returns true when the platform_family is fedora' do
      node = { 'platform_family' => 'fedora' }
      expect(described_class.fedora?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not fedora' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.fedora?(node)).to be_falsey
    end
  end

  describe '#freebsd?' do
    it 'returns true when the platform_family is freebsd' do
      node = { 'platform_family' => 'freebsd' }
      expect(described_class.freebsd?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not freebsd' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.freebsd?(node)).to be_falsey
    end
  end

  describe '#gentoo?' do
    it 'returns true when the platform_family is gentoo' do
      node = { 'platform_family' => 'gentoo' }
      expect(described_class.gentoo?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not gentoo' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.gentoo?(node)).to be_falsey
    end
  end

  describe '#mac_os_x?' do
    it 'returns true when the platform_family is mac_os_x' do
      node = { 'platform_family' => 'mac_os_x' }
      expect(described_class.mac_os_x?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not mac_os_x' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.mac_os_x?(node)).to be_falsey
    end
  end

  describe '#openbsd?' do
    it 'returns true when the platform_family is openbsd' do
      node = { 'platform_family' => 'openbsd' }
      expect(described_class.openbsd?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not openbsd' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.openbsd?(node)).to be_falsey
    end
  end

  describe '#rhel?' do
    it 'returns true when the platform_family is rhel' do
      node = { 'platform_family' => 'rhel' }
      expect(described_class.rhel?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not rhel' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.rhel?(node)).to be_falsey
    end
  end

  describe '#slackware?' do
    it 'returns true when the platform_family is slackware' do
      node = { 'platform_family' => 'slackware' }
      expect(described_class.slackware?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not slackware' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.slackware?(node)).to be_falsey
    end
  end

  describe '#suse?' do
    it 'returns true when the platform_family is suse' do
      node = { 'platform_family' => 'suse' }
      expect(described_class.suse?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not suse' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.suse?(node)).to be_falsey
    end
  end

  describe '#windows?' do
    it 'returns true when the platform_family is windows' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.windows?(node)).to be_truthy
    end

    it 'returns false when the platform_family is not windows' do
      node = { 'platform_family' => 'debian' }
      expect(described_class.windows?(node)).to be_falsey
    end
  end

  describe '#linux?' do
    it 'returns true when the platform_family is Debian' do
      node = { 'platform_family' => 'debian' }
      expect(described_class.linux?(node)).to be_truthy
    end

    it 'returns true when the platform_family is RedHat' do
      node = { 'platform_family' => 'rhel' }
      expect(described_class.linux?(node)).to be_truthy
    end

    it 'returns false when the platform_family is Windows' do
      node = { 'platform_family' => 'windows' }
      expect(described_class.linux?(node)).to be_falsey
    end

    it 'returns false when the platform_family is OSX' do
      node = { 'platform_family' => 'mac_os_x' }
      expect(described_class.linux?(node)).to be_falsey
    end

    it 'returns false when the platform_family is OpenBSD' do
      node = { 'platform_family' => 'openbsd' }
      expect(described_class.linux?(node)).to be_falsey
    end
  end
end
