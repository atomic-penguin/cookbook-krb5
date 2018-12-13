require 'spec_helper'

describe 'krb5::host_keytab' do
  context 'on Centos 6.7 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.7) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'creates host principal' do
      expect(chef_run).to create_krb5_principal('host/fauxhai.local')
    end

    it 'creates /etc/krb5.keytab' do
      expect(chef_run).to create_krb5_keytab('/etc/krb5.keytab').with(
        principals: ['host/fauxhai.local']
      )
    end
  end
end
