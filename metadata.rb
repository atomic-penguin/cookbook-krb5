name             'krb5'
maintainer       'Chris Gianelloni'
maintainer_email 'wolf31o2@gmail.com'
license          'Apache-2.0'
description      'Installs and configures Kerberos V authentication'
chef_version '~> 13.0' if respond_to?(:chef_version)
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.3.0'

source_url 'https://github.com/atomic-penguin/cookbook-krb5/issues'
issues_url 'https://github.com/atomic-penguin/cookbook-krb5'

%w(redhat centos scientific amazon ubuntu debian suse).each do |os|
  supports os
end

depends 'apt'
depends 'build-essential'
depends 'ntp'
