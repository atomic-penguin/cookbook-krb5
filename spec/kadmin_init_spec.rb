require 'spec_helper'

describe 'krb5::kadmin_init' do
  include_context 'converged default kadmin recipe without principals'

  shared_examples 'creating a kerberos database' do
    it 'logs create-krb5-db to info' do
      expect(chef_run).to write_log('create-krb5-db').with(level: :info)
    end

    it 'executes execute[create-krb5-db] block' do
      expect(chef_run).to run_execute('create-krb5-db')
    end

    it 'executes execute[create-admin-principal] block' do
      expect(chef_run).to run_execute('create-admin-principal')
    end
  end

  context 'CentOS 6.9' do
    before(:each) do
      stub_command('test -e /var/kerberos/krb5kdc/principal').and_return(false)
    end
    let(:node_attributes) do
      { platform: 'centos', version: '6.9', platform_family: 'rhel' }
    end
    it_behaves_like 'creating a kerberos database'
  end

  context 'CentOS 7.4' do
    before(:each) do
      stub_command('test -e /var/kerberos/krb5kdc/principal').and_return(false)
    end
    let(:node_attributes) do
      { platform: 'centos', version: '7.4.1708', platform_family: 'rhel' }
    end
    it_behaves_like 'creating a kerberos database'
  end

  context 'Ubuntu 14.04' do
    before(:each) do
      stub_command('test -e /var/lib/krb5kdc/principal').and_return(false)
    end
    let(:node_attributes) do
      { platform: 'ubuntu', version: '14.04', platform_family: 'debian' }
    end
    it_behaves_like 'creating a kerberos database'
  end

  context 'Ubuntu 16.04' do
    before(:each) do
      stub_command('test -e /var/lib/krb5kdc/principal').and_return(false)
    end
    let(:node_attributes) do
      { platform: 'ubuntu', version: '16.04', platform_family: 'debian' }
    end
    it_behaves_like 'creating a kerberos database'
  end
end
