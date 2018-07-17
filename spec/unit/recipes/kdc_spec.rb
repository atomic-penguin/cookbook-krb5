require 'spec_helper'

describe 'krb5::kdc' do
  context 'on Centos 6.7 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.7) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(krb5-server krb5-server-ldap).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end

    it 'creates kdc.conf template' do
      expect(chef_run).to create_template('/var/kerberos/krb5kdc/kdc.conf')
    end

    it 'renders file kdc.conf with realm EXAMPLE.COM' do
      expect(chef_run).to render_file('/var/kerberos/krb5kdc/kdc.conf').with_content(
        %r{acl_file\s+=\s+/etc/krb5kdc/kadm5.acl}
      )
    end
  end

  context 'on Ubuntu 14.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: 14.04) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(krb5-kdc krb5-kdc-ldap).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end

    it 'creates kdc.conf template' do
      expect(chef_run).to create_template('/var/lib/krb5kdc/kdc.conf')
    end
  end
end
