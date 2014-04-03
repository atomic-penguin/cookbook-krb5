#
# Cookbook Name:: krb5
# Recipe:: kadmin
#
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

include_recipe 'krb5::kdc'

node['krb5']['kadmin']['packages'].each do |krb5_package|
  package krb5_package
end

case node['platform_family']
when 'rhel'
  kdc_dir = "/var/kerberos/krb5kdc"
  etc_dir = kdc_dir
  kadm_svc = "kadmin"
when 'debian'
  kdc_dir = "/var/lib/krb5kdc"
  etc_dir = "/etc/krb5kdc"
  kadm_svc = "krb5-admin-server"
end

template "#{etc_dir}/kadm5.acl" do
  owner 'root'
  group 'root'
  mode '0644'
end

execute "create-krb5-db" do
  command "echo '#{node['krb5']['master_password']}\n#{node['krb5']['master_password']}\n' | kdb5_util create -s"
  not_if "test -e #{kdc_dir}/principal"
end

execute "create-admin-principal" do
  command "echo #{node['krb5']['admin_password']} | kadmin.local -q 'addprinc #{node['krb5']['admin_principal']}'"
end

service kadm_svc do
  action :nothing
end
