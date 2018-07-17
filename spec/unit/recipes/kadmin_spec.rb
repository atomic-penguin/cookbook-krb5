require 'spec_helper'

describe 'krb5::kadmin' do
  context 'on Centos 6.7 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.7) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command('test -e /var/kerberos/krb5kdc/principal').and_return(false)
        stub_command("kadmin.local -q 'list_principals' | grep -e ^admin/admin").and_return(false)
      end.converge(described_recipe)
    end

    %w(krb5-server).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end

    it 'creates kadm5.acl template' do
      expect(chef_run).to create_template('/etc/krb5kdc/kadm5.acl')
    end

    it 'renders file kadm5.acl with realm EXAMPLE.COM' do
      expect(chef_run).to render_file('/etc/krb5kdc/kadm5.acl').with_content(
        %r{.*/admin@EXAMPLE.COM\t.*}
      )
    end
  end

  context 'on Ubuntu 14.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: 14.04) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command('test -e /var/lib/krb5kdc/principal').and_return(false)
        stub_command("kadmin.local -q 'list_principals' | grep -e ^admin/admin").and_return(false)
      end.converge(described_recipe)
    end

    %w(krb5-admin-server).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end
  end
end
