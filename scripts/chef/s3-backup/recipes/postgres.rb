#
# Cookbook Name:: s3_backup
# Recipe:: postgres
#
# Copyright 2013, Dan Shick 
#

include_recipe "s3_backup::default"

template "/usr/local/bin/backup-postgres.sh" do
   source "scripts/backup-postgres.sh.erb"
   mode 0750
  owner "postgres"
  group "disk"
end

cookbook_file "/etc/cron.d/backup-postgres" do
  source "cron.d/backup-postgres"
   mode 0640
  owner "root"
  group "root"
end


