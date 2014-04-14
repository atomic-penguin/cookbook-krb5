require 'spec_helper'

describe 'krb5::default' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(krb5-libs krb5-workstation pam pam_krb5 authconfig).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end

    it 'creates krb5.conf template' do
      expect(chef_run).to create_template('/etc/krb5.conf')
    end

    it 'renders file krb5.conf with realm EXAMPLE.COM' do
      expect(chef_run).to render_file('/etc/krb5.conf').with_content(
        /default_realm\s+=\s+EXAMPLE.COM/
      )
    end
  end

  context 'on Ubuntu 13.04' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: 13.04) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(libpam-krb5 libpam-runtime libkrb5-3 krb5-user).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end
  end
end
