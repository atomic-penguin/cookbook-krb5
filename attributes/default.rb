#
# Cookbook Name:: krb5
# Attributes:: default
#
# Copyright © 2012 Eric G. Wolfe
# Copyright © 2013 Gerald L. Hevener Jr., M.S.
# Copyright © 2014-2016 Cask Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Platform-specific configuration
case node['platform_family']
when 'rhel'
  default['krb5']['packages'] = %w(krb5-libs krb5-workstation pam pam_krb5 authconfig)
  default['krb5']['authconfig'] = 'authconfig --enableshadow --enablemd5 --enablekrb5 --enablelocauthorize --update'
  default['krb5']['conf_dir'] = '/etc/krb5kdc'
  default['krb5']['data_dir'] = '/var/kerberos/krb5kdc'
  default['krb5']['kadmin']['service_name'] = 'kadmin'
  default['krb5']['kadmin']['packages'] = %w(krb5-server)
  default['krb5']['kdc']['service_name'] = 'krb5kdc'
  default['krb5']['kdc']['packages'] = %w(krb5-server krb5-server-ldap)
  default['krb5']['devel']['packages'] = %w(krb5-devel)
when 'debian'
  default['krb5']['packages'] = %w(libpam-krb5 libpam-runtime libkrb5-3 krb5-user)
  default['krb5']['authconfig'] = 'pam-auth-update --package krb5'
  default['krb5']['conf_dir'] = '/etc/krb5kdc'
  default['krb5']['data_dir'] = '/var/lib/krb5kdc'
  default['krb5']['kadmin']['service_name'] = 'krb5-admin-server'
  default['krb5']['kadmin']['packages'] = %w(krb5-admin-server)
  default['krb5']['kdc']['service_name'] = 'krb5-kdc'
  default['krb5']['kdc']['packages'] = %w(krb5-kdc krb5-kdc-ldap)
  default['krb5']['devel']['packages'] = %w(libkrb5-dev)
when 'suse'
  default['krb5']['packages'] = %w(krb5 pam_krb5 pam-config)
  default['krb5']['authconfig'] = 'pam-config --add --krb5'
else
  default['krb5']['packages'] = []
  default['krb5']['authconfig'] = ''
  default['krb5']['kadmin']['packages'] = []
  default['krb5']['kdc']['packages'] = []
  default['krb5']['devel']['packages'] = []
end

default_realm =
  if node['krb5'].key?('krb5_conf') && node['krb5']['krb5_conf'].key?('libdefaults') &&
     node['krb5']['krb5_conf']['libdefaults'].key?('default_realm')
    node['krb5']['krb5_conf']['libdefaults']['default_realm']
  elsif node['domain']
    node['domain'].upcase
  else
    'LOCAL'
  end

# Default location for keytabs generated from LWRP
default['krb5']['keytabs_dir'] = '/etc/security/keytabs'

# Install build-essential at compile time
override['build-essential']['compile_time'] = true

# Include ntp recipe?
default['krb5']['include_ntp'] = true

# Client Packages
default['krb5']['client']['packages'] = node['krb5']['packages']
default['krb5']['client']['authconfig'] = node['krb5']['authconfig']

# logging
default['krb5']['krb5_conf']['logging']['default'] = 'FILE:/var/log/krb5libs.log'
default['krb5']['krb5_conf']['logging']['kdc'] = 'FILE:/var/log/krb5kdc.log'
default['krb5']['krb5_conf']['logging']['admin_server'] = 'FILE:/var/log/kadmind.log'

# libdefaults
default['krb5']['krb5_conf']['libdefaults']['default_realm'] = default_realm
default['krb5']['krb5_conf']['libdefaults']['dns_lookup_realm'] = false
default['krb5']['krb5_conf']['libdefaults']['dns_lookup_kdc'] = true
default['krb5']['krb5_conf']['libdefaults']['forwardable'] = true
default['krb5']['krb5_conf']['libdefaults']['renew_lifetime'] = '24h'
default['krb5']['krb5_conf']['libdefaults']['ticket_lifetime'] = '24h'

# realms
default['krb5']['krb5_conf']['realms']['default_realm'] = default_realm
default['krb5']['krb5_conf']['realms']['default_realm_kdcs'] = []
default['krb5']['krb5_conf']['realms']['default_realm_admin_server'] = ''
default['krb5']['krb5_conf']['realms']['realms'] = [default_realm]

# includedir
default['krb5']['krb5_conf']['includedir'] = []

# appdefaults
default['krb5']['krb5_conf']['appdefaults']['pam']['debug'] = false
default['krb5']['krb5_conf']['appdefaults']['pam']['forwardable'] = node['krb5']['krb5_conf']['libdefaults']['forwardable']
default['krb5']['krb5_conf']['appdefaults']['pam']['renew_lifetime'] = node['krb5']['krb5_conf']['libdefaults']['renew_lifetime']
default['krb5']['krb5_conf']['appdefaults']['pam']['ticket_lifetime'] = node['krb5']['krb5_conf']['libdefaults']['ticket_lifetime']
default['krb5']['krb5_conf']['appdefaults']['pam']['krb4_convert'] = false
