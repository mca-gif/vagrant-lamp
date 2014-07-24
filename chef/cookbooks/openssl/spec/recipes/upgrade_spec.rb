require_relative '../spec_helper'

describe 'openssl::upgrade' do
  context 'notify restart on upgrade' do
    let(:chef_run) do
      ChefSpec::Runner.new(
        :platform => 'debian',
        :version => '7.4'
      ) do |node|
        node.set['openssl']['packages'] = ['openssl']
        node.set['openssl']['restart_services'] = ['httpd']
      end.converge('test::httpd', described_recipe)
    end

    let(:package) { chef_run.package('openssl') }

    it 'restart httpd when upgrading openssl' do
      expect(package).to notify('service[httpd]').to(:restart)
    end

  end
  context 'ubuntu_before_or_at_lucid' do
    let(:chef_run) do
      ChefSpec::Runner.new(
        :platform => 'ubuntu',
        :version => '10.04'
      ).converge(described_recipe)
    end

    it 'will upgrade the libssl0.9.8 package' do
      expect(chef_run).to upgrade_package('libssl0.9.8')
    end

    it 'will upgrade the openssl package' do
      expect(chef_run).to upgrade_package('openssl')
    end

  end

  context 'ubuntu_after_or_at_precise' do
    let(:chef_run) do
      ChefSpec::Runner.new(
        :platform => 'ubuntu',
        :version => '12.04'
      ).converge(described_recipe)
    end

    it 'will upgrade the libssl1.0.0 package' do
      expect(chef_run).to upgrade_package('libssl1.0.0')
    end

    it 'will upgrade the openssl package' do
      expect(chef_run).to upgrade_package('openssl')
    end
  end

  context 'redhat_enterprise' do
    let(:chef_run) do
      ChefSpec::Runner.new(
        :platform => 'redhat',
        :version => '6.5'
      ).converge(described_recipe)
    end
    it 'will upgrade the openssl package' do
      expect(chef_run).to upgrade_package('openssl')
    end
  end
end
