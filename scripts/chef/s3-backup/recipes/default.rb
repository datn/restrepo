#
# Cookbook Name:: s3_backup
# Recipe:: default
#
# Copyright 2013, Dan Shick 
#

node.set[:s3fs][:mountpoint]="/backups"
node.set[:s3fs][:bucket]="yerbucket"

backupdir="#{node[:s3fs][:mountpoint]}"

package "pigz"

include_recipe "s3fs::default"

directory node[:s3fs][:mountpoint] do
  owner "root"
  group "root"
  mode 0755
  action :create
  not_if "[ -d #{backupdir} ]"
end

cookbook_file "/usr/local/bin/mount-s3.sh" do
  source "scripts/mount-s3.sh"
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "/usr/local/bin/umount-s3.sh" do
  source "scripts/umount-s3.sh"
  mode 0755
  owner "root"
  group "root"
end

service "rsyslog" do
  action :nothing
end

cookbook_file "/etc/rsyslog.d/s3_backup.conf" do
  source "s3_backup.rsyslog"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, "service[rsyslog]"
end


cookbook_file "/etc/logrotate.d/s3_backup" do
  source "s3_backup.logrotate"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/etc/updatedb.conf" do
  source "s3_backup.updatedb.conf"
  mode 0644
  owner "root"
  group "root"
end

