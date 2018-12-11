#
# Cookbook Name:: krb5
# Recipe:: kdc_init
#
# Copyright © 2018 Chris Gianelloni
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

include_recipe 'krb5::default'
include_recipe 'krb5::kadmin'

default_realm = node['krb5']['krb5_conf']['libdefaults']['default_realm'].upcase

log 'create-krb5-db' do
  message 'Creating Kerberos Database... this may take a while...'
  level :info
  not_if "test -e #{node['krb5']['kdc_conf']['realms'][default_realm]['database_name']}"
end

execute 'create-krb5-db' do # ~FC009
  command "{ echo '#{node['krb5']['master_password']}'; echo '#{node['krb5']['master_password']}'; } | kdb5_util -r #{default_realm} create -s"
  not_if "test -e #{node['krb5']['kdc_conf']['realms'][default_realm]['database_name']}"
  sensitive true if respond_to?(:sensitive)
  creates node['krb5']['kdc_conf']['realms'][default_realm]['database_name']
end
