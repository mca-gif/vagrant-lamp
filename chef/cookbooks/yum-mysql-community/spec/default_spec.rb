require 'spec_helper'

describe 'yum-mysql-community::connectors' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  it 'creates yum_repository[connectors]' do
    expect(chef_run).to create_yum_repository('mysql-connectors-community')
  end
end

describe 'yum-mysql-community::mysql55' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  it 'creates yum_repository[mysql55]' do
    expect(chef_run).to create_yum_repository('mysql55-community')
  end
end

describe 'yum-mysql-community::mysql56' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  it 'creates yum_repository[mysql56]' do
    expect(chef_run).to create_yum_repository('mysql56-community')
  end
end
