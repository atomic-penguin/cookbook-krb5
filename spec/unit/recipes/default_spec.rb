require 'spec_helper'

describe 'krb5::default' do
  context 'on Centos 6.7 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.7) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(krb5-libs krb5-workstation pam pam_krb5 authconfig).each do |krb5_pkg|
      it "installs #{krb5_pkg} package" do
        expect(chef_run).to install_package(krb5_pkg)
      end
    end

    it 'creates the /etc/krb5kdc directory' do
      expect(chef_run).to create_directory('/etc/krb5kdc')
    end

    it 'creates krb5.conf template' do
      expect(chef_run).to create_template('/etc/krb5.conf')
    end

    it 'renders file krb5.conf with realm EXAMPLE.COM' do
      expect(chef_run).to render_file('/etc/krb5.conf').with_content(
        /default_realm\s+=\s+EXAMPLE.COM/
      )
    end

    it 'executes execute[krb5-authconfig] block' do
      expect(chef_run).not_to run_execute('krb5-authconfig')
    end
  end

  context 'on Ubuntu 14.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: 14.04) do |node|
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
