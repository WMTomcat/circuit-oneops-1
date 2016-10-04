# rubocop:disable LineLength
###############################################################################
# Cookbook Name:: tomcat_8-5
# Recipe:: add_repo
# Purpose:: This recipe is used to install the Tomcat binaries onto the server.
#
# Copyright 2010, Opscode, Inc.
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
###############################################################################

###############################################################################
# Tomcat Download
#   This installed the Tomcat binaries from the repo specified in the cloud's
#   Mirror.
#   1 - Create listof package names based on OS
#   2 - Clean up metadata if OS = rhel
#   3 - If OS is not fedora|redhat|centos, OneOps will check for a lock file.
#     OneOps will retry until lock is gone of it hits 20 retries.
#     Package will install on fedora|redhat|centos and on other OSs once lock
#       is gone.
###############################################################################

# create context root of repo path
#tarball = "tomcat/tomcat-8/v#{node['tomcat']['global']['version']}/bin/apache-tomcat-#{node['tomcat']['global']['version']}.tar.gz"
Chef::Log.debug("context root of repo path is: #{node['tomcat']['tarball']}")

# create parent dir (keep ownership as root) if doesnt exist
Chef::Log.debug("making #{node['tomcat']['config_dir']} directory")
directory node['tomcat']['config_dir'] do
  action :create
  owner "#{node['tomcat']['global']['tomcat_user']}"
  group "#{node['tomcat']['global']['tomcat_group']}"
  not_if "test -d #{node['tomcat']['config_dir']}"
end

source_url="http://repos.walmart.com/mirrored-assets/apache.mirrors.pair.com"
source_list="#{source_url}/#{node['tomcat']['tarball']}"
shared_download_http source_list do
  path "#{node['tomcat']['download_destination']}"
  action :create
end


execute "tar --exclude='*webapps/examples*' --exclude='*webapps/ROOT*' --exclude='*webapps/docs*' --exclude='*webapps/manager*' --exclude='*webapps/host-manager*' -zxf #{node['tomcat']['download_destination']}" do
  cwd node['tomcat']['config_dir']
end

execute "chown -R #{node['tomcat']['global']['tomcat_user']}:#{node['tomcat']['global']['tomcat_group']} #{node['tomcat']['instance_dir']}"
execute "rm -fr #{node['tomcat']['download_destination']}"

###############################################################################
# End of add_repo.rb
###############################################################################