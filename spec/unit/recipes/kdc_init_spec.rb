require 'spec_helper'

describe 'krb5::kdc_init' do
  context 'on Centos 6.7 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.7) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command('test -e /var/kerberos/krb5kdc/principal').and_return(false)
        stub_command("kadmin.local -q 'list_principals' | grep -e ^admin/admin").and_return(false)
      end.converge(described_recipe)
    end

    it 'logs create-krb5-db to info' do
      expect(chef_run).to write_log('create-krb5-db').with(level: :info)
    end

    it 'executes execute[create-krb5-db] block' do
      expect(chef_run).to run_execute('create-krb5-db')
    end
  end
end
