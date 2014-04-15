name 'krb5'
maintainer 'Eric G. Wolfe'
maintainer_email 'eric.wolfe@gmail.com'
license 'Apache 2.0'
description 'Installs and configures krb5 authentication'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

%w(redhat centos scientific amazon ubuntu debian suse).each do |os|
  supports os
end

depends 'ntp'
