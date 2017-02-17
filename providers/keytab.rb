#
# Cookbook Name:: krb5
# Provider:: keytab
#
# Copyright © 2014-2016 Cask Data, Inc.
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
include Krb5::Helpers
# TODO: guards for whyrun_supported?

action :create do
  krb5_load_gem
  krb5_verify_admin
  begin
    kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
    keytab = keytab_init("FILE:#{new_resource.path}")

    # Should we use @current_resource.exists here instead?
    unless ::File.exist?(new_resource.path)

      directory ::File.dirname(new_resource.path) do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      new_resource.principals.each do |princ|
        sv = kadm5_find_principal(kadm5, princ)
        next unless sv.nil?
        Chef::Application.fatal!("Principal #{princ} not found on KDC! Perhaps you need to create it with krb5_principal, first.")
      end

      principals = principal_list(new_resource.principals)

      execute 'kinit as configured admin principal' do # ~FC009
        command "echo #{node['krb5']['admin_password']} | kinit #{node['krb5']['admin_principal']}"
        not_if "test -e #{new_resource.path}"
        action :run
        sensitive true if respond_to?(:sensitive)
      end

      execute "create #{new_resource.path}" do # ~FC009
        command "kadmin -w #{node['krb5']['admin_password']} -q 'xst -kt #{new_resource.path} #{principals}'"
        not_if "test -e #{new_resource.path}"
        action :run
        creates new_resource.path
        sensitive true if respond_to?(:sensitive)
      end

      file new_resource.path do
        owner new_resource.owner
        group new_resource.group
        mode  new_resource.mode
        action :create
      end
    end
  ensure
    keytab.close unless keytab.nil?
  end
end

action :delete do
  if ::File.exist?(new_resource.path)
    Chef::Log.info("Removing #{new_resource.name} keytab file")
    file new_resource.path do
      action :delete
    end
  end
end
