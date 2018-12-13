#
# Cookbook Name:: krb5
# Recipe:: host_keytab
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

node['krb5']['default_principals'].each do |princ|
  krb5_principal princ do
    action :create
  end
end

krb5_keytab '/etc/krb5.keytab' do
  principals [*node['krb5']['default_principals']]
end
