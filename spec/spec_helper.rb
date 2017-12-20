require 'chefspec'
require 'chefspec/berkshelf'

at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |config|
  config.color = true
end

shared_context 'converged default recipe' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(node_attributes) do |node|
      node.automatic['domain'] = 'example.com'
    end.converge(described_recipe)
  end
end

shared_context 'converged default kadmin recipe without principals' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(node_attributes) do |node|
      node.automatic['domain'] = 'example.com'
      stub_command("kadmin.local -q 'list_principals' | grep -e ^admin/admin").and_return(false)
    end.converge(described_recipe)
  end
end
