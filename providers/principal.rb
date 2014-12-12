#
# Cookbook Name:: krb5
# Provider:: principal
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
  begin
    kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
    randkey = new_resource.randkey
    mypass = if new_resource.password.nil?
               'placeholder12345'
             else
               new_resource.password
               randkey = false
             end
    if kadm5_find_principal(kadm5, new_resource.principal).nil?
      if randkey
        Chef::Log.info("Creating #{new_resource.principal} principal with random key")
      else
        Chef::Log.info("Creating #{new_resource.principal} principal with user-provided password")
      end
      kadm5.create_principal(new_resource.principal, mypass)
      kadm5.generate_random_key(new_resource.principal) if randkey
    end
  ensure
    kadm5.close
  end
end

action :delete do
  krb5_load_gem
  krb5_verify_admin
  begin
    kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
    unless kadm5_find_principal(kadm5, new_resource.principal).nil?
      Chef::Log.info("Removing #{new_resource.principal} principal from Kerberos")
      kadm5.delete_principal(new_resource.principal)
    end
  ensure
    kadm5.close
  end
end