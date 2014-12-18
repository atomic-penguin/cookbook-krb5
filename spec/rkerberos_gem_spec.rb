require 'spec_helper'

describe 'krb5::rkerberos_gem' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'installs rkerberos chef_gem' do
      expect(chef_run).to install_chef_gem('rkerberos')
    end

    it 'installs krb5-devel package' do
      expect(chef_run).to install_package('krb5-devel')
    end
  end

  context 'on Ubuntu 13.04' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: 13.04) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'installs libkrb5-dev package' do
      expect(chef_run).to install_package('libkrb5-dev')
    end
  end
end
