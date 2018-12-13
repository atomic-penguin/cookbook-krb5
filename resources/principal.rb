#
# Cookbook Name:: krb5
# Resource:: principal
#
# Copyright © 2014 Cask Data, Inc.
# Copyright © 2018 Chris Gianelloni
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

property :password, [NilClass, String], default: nil
property :principal, String, name_property: true
property :randkey, [TrueClass, FalseClass], default: true

action :create do
  include_recipe 'krb5::rkerberos_gem'
  krb5_load_gem
  krb5_verify_admin
  begin
    kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
    randkey = new_resource.randkey
    if new_resource.password.nil?
      mypass = 'placeholder12345'
    else
      mypass = new_resource.password
      randkey = false
    end
    if kadm5_find_principal(kadm5, new_resource.name).nil?
      Chef::Log.info("Creating #{new_resource.name} principal with #{randkey ? 'random key' : 'user-provided password'}")
      converge_by "create-principal-#{new_resource.name}" do
        kadm5.create_principal(new_resource.name, mypass)
        kadm5.generate_random_key(new_resource.name) if randkey
      end
    end
  ensure
    kadm5.close unless kadm5.nil?
  end
end

action :delete do
  krb5_load_gem
  krb5_verify_admin
  begin
    kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
    unless kadm5_find_principal(kadm5, new_resource.name).nil?
      Chef::Log.info("Removing #{new_resource.name} principal from Kerberos")
      converge_by "delete-principal-#{new_resource.name}" do
        kadm5.delete_principal(new_resource.name)
      end
    end
  ensure
    kadm5.close unless kadm5.nil?
  end
end

action_class do
  include Krb5::Helpers
end
