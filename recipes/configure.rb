#
# Cookbook Name:: keepalived
# Recipe:: configure
#
# Copyright 2009, Chef Software, Inc.
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

if node['keepalived']['shared_address']
  include_recipe 'sysctl'

  sysctl_param 'net.ipv4.ip_nonlocal_bind' do
    value 1
  end
end

conf_mode = node['keepalived']['configuration_mode']

template 'keepalived.conf' do
  path '/etc/keepalived/keepalived.conf'
  source 'keepalived.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  only_if { conf_mode == 'attributes' }
end

directory '/etc/keepalived/conf.d' do
  only_if { conf_mode == 'resources' }
end

file '/etc/keepalived/keepalived.conf' do
  content 'include /etc/keepalived/conf.d/*.conf'
  owner 'root'
  group 'root'
  mode '0640'
  only_if { conf_mode == 'resources' }
end
