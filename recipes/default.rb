# encoding: utf-8
#
# Cookbook Name:: denyhosts
# Recipe:: default
#
# Copyright (C) 2014, Darron Froese <darron@froese.org>
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

directory '/var/lib/denyhosts/' do
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

# It's important that this is installed before the package is installed.
# If not, it locks you out on a TestKitchen run.
template '/var/lib/denyhosts/allowed-hosts' do
  source 'allowed-hosts.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  action :create
end

package 'denyhosts'

service 'denyhosts' do
  supports :restart => true # rubocop:disable HashSyntax
  action [:enable, :start]
end

file '/etc/denyhosts.conf' do
  owner  'root'
  group  'root'
  action :create
  notifies :restart, 'service[denyhosts]', :immediately
end


