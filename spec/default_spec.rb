require 'spec_helper'

describe 'krb5::default' do
  let(:krb5_ubuntu_packages) { %w(libpam-krb5 libpam-runtime libkrb5-3 krb5-user) }
  let(:krb5_centos_packages) { %w(krb5-libs krb5-workstation pam pam_krb5 authconfig) }
  let(:chef_run) { ChefSpec::SoloRunner.new(node_attributes).converge(described_recipe) }

  context 'on Centos 6.9' do
    let(:node_attributes) do
      { platform: 'centos', version: '6.9', domain: 'example.com' }
    end

    it 'installs necessary packages for CentOS' do
      krb5_centos_packages.each do |package|
        expect(chef_run).to install_package(package)
      end
    end

    it 'creates the /etc/krb5kdc directory' do
      expect(chef_run).to create_directory('/etc/krb5kdc')
    end

    it 'creates krb5.conf template' do
      expect(chef_run).to create_template('/etc/krb5.conf')
    end

    it 'renders file krb5.conf with realm EXAMPLE.COM' do
      expect(chef_run).to render_file('/etc/krb5.conf').with_content(/default_realm\s+=\s+EXAMPLE.COM/)
    end

    it 'executes execute[krb5-authconfig] block' do
      expect(chef_run).not_to run_execute('krb5-authconfig')
    end
  end

  context 'on Centos 7.4' do
    let(:node_attributes) do
      { platform: 'centos', version: '7.4.1708', domain: 'example.com' }
    end

    it 'installs necessary packages for CentOS' do
      krb5_centos_packages.each do |package|
        expect(chef_run).to install_package(package)
      end
    end
  end

  context 'on Ubuntu 14.04' do
    let(:node_attributes) do
      { platform: 'ubuntu', version: '14.04', domain: 'example.com' }
    end

    it 'installs necessary packages for CentOS' do
      krb5_ubuntu_packages.each do |package|
        expect(chef_run).to install_package(package)
      end
    end
  end

  context 'on Ubuntu 16.04' do
    let(:node_attributes) do
      { platform: 'ubuntu', version: '16.04', domain: 'example.com' }
    end

    it 'installs necessary packages for CentOS' do
      krb5_ubuntu_packages.each do |package|
        expect(chef_run).to install_package(package)
      end
    end
  end
end
