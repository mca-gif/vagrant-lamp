require 'spec_helper'

describe 'chef-sugar::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the chef gem' do
    expect(chef_run).to install_chef_gem('chef-sugar')
  end
end
