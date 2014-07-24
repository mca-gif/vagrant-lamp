require 'spec_helper'

describe 'yum-epel::default' do
  context 'yum-epel::default uses default attributes' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['yum']['epel']['managed'] = true
        node.set['yum']['epel-debuginfo']['managed'] = true
        node.set['yum']['epel-source']['managed'] = true
        node.set['yum']['epel-testing']['managed'] = true
        node.set['yum']['epel-testing-debuginfo']['managed'] = true
        node.set['yum']['epel-testing-source']['managed'] = true
      end.converge(described_recipe)
    end

    %w{
      epel
      epel-debuginfo
      epel-source
      epel-testing
      epel-testing-debuginfo
      epel-testing-source
      }.each do |repo|
      it "creates yum_repository[#{repo}]" do
        expect(chef_run).to create_yum_repository(repo)
      end
    end

  end
end
