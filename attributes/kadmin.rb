#
# Cookbook Name:: krb5
# Attributes:: kadmin
#
# Copyright 2012, Eric G. Wolfe
# Copyright 2013, Gerald L. Hevener Jr., M.S.
# Copyright 2014, Continuuity, Inc.
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

# Admin Server packages
case node['platform_family']
when 'rhel'
  default['krb5']['kadmin']['packages'] = %w(krb5-server)
  kdc_dir = "/var/kerberos/krb5kdc"
  etc_dir = kdc_dir
when 'debian'
  default['krb5']['kadmin']['packages'] = %w(krb5-admin-server)
  kdc_dir = "/var/lib/krb5kdc"
  etc_dir = "/etc/krb5kdc"
else
  default['krb5']['kadmin']['packages'] = []
end

# Master password
default['krb5']['master_password'] = 'password'

# kadm5.acl
default['krb5']['kadm5_acl'] = {
  "*/admin@#{node['krb5']['krb5_conf']['libdefaults']['default_realm'].upcase}" => [ "*" ]
}
