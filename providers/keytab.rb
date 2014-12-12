#
# Cookbook Name:: krb5
# Provider:: keytab
#
# Copyright © 2014 Cask Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  krb5_load_gem
  krb5_verify_admin
  Chef::Application.fatal!('You myst specify at least one principal') if new_resource.principals.empty?
  begin
    kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
    keytab = keytab_init("FILE:#{new_resource.path}")

    directory File::Dirname(new_resource.path) do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end

    principals.each do |princ|
      kt = keytab_find_principal(keytab, princ)
      sv = kadm5_find_principal(kadm5, princ)
      if sv.nil?
        Chef::Application.fatal!("Principal #{princ} not found on KDC! Perhaps, you need to create it with krb5_principal, first.")
      elsif kt.nil?
        Chef::Log.info("Principal #{princ} found on server but missing from keytab")
      end
    end
  ensure
    keytab.close
  end

  # keytab_dir = node['krb5']['keytabs_dir']
end
