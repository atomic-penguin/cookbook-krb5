name             'krb5'
maintainer       'Chris Gianelloni'
maintainer_email 'wolf31o2@gmail.com'
license          'Apache-2.0'
description      'Installs and configures Kerberos V authentication'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.0'

%w(redhat centos scientific amazon ubuntu debian suse).each do |os|
  supports os
end

depends 'build-essential'
depends 'ntp'

source_url 'https://github.com/atomic-penguin/cookbook-krb5' if
  respond_to?(:source_url)
issues_url 'https://github.com/atomic-penguin/cookbook-krb5/issues' if
  respond_to?(:issues_url)
chef_version '>= 12.15' if
  respond_to?(:chef_version)
