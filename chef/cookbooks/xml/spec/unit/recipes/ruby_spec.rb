require 'spec_helper'

describe 'xml::ruby' do
  let(:chef_run) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe) }

  it 'should set NOKOGIRI_USE_SYSTEM_LIBRARIES env variable' do
    chef_run
    expect(ENV['NOKOGIRI_USE_SYSTEM_LIBRARIES']).to eq('true')
  end

  it 'installs nokogiri' do
    expect(chef_run).to install_chef_gem('nokogiri')
  end
end
