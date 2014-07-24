require 'spec_helper'

describe 'build-essential::_freebsd' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'freebsd', version: '9.1')
      .converge(described_recipe)
  end

  it 'installs the correct packages' do
    expect(chef_run).to install_package('gmake')
    expect(chef_run).to install_package('autoconf')
    expect(chef_run).to install_package('m4')
  end
end
