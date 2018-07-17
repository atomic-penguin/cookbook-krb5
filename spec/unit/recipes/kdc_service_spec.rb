require 'spec_helper'

describe 'krb5::kdc_service' do
  context 'on Centos 6.7 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.7) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'creates krb5kdc service resource, but does not run it' do
      expect(chef_run).to_not start_service('krb5kdc')
    end
  end

  context 'on Ubuntu 14.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: 14.04) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'creates krb5-kdc service resource, but does not run it' do
      expect(chef_run).to_not start_service('krb5-kdc')
    end
  end
end
