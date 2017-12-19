name             'krb5'
maintainer       'Chris Gianelloni'
maintainer_email 'wolf31o2@gmail.com'
license          'Apache 2.0'
description      'Installs and configures Kerberos V authentication'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.2'

%w(redhat centos scientific amazon ubuntu debian suse).each do |os|
  supports os
end

depends 'apt'
depends 'build-essential'
depends 'ntp'
