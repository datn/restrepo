#
# Cookbook Name:: s3_backup
# Recipe:: dirs
#
# Copyright 2014, Dan Shick 
#
include_recipe "s3_backup::default"

template "/usr/local/bin/backup-dirs.sh" do
  source "scripts/backup-dirs.sh.erb"
   mode 0750
  owner "root"
  group "root"
end

cookbook_file "/etc/cron.d/backup-dirs" do
  source "cron.d/backup-dirs"
  mode 0640
  owner "root"
  group "root"
end
