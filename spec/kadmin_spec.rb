require 'spec_helper'

describe 'krb5::kadmin' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(krb5-server).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end

    it 'renders file kadm5.acl with realm EXAMPLE.COM' do
      expect(chef_run).to render_file('/var/kerberos/krb5kdc/kadm5.acl').with_content(
        /\*\/admin@EXAMPLE.COM\t\*/
      )
    end

    it 'creates principal database' do
      expect(chef_run).to render_file('/var/kerberos/krb5kdc/principal')
    end
  end

  context 'on Ubuntu 13.04' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: 13.04) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(krb5-admin-server).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end
  end
end
