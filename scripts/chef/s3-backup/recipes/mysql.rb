#
# Cookbook Name:: s3_backup
# Recipe:: mysql
#
# Copyright 2014, Dan Shick 
#
# also contains work from https://gist.github.com/AntonStoeckl/5443286
#

include_recipe "s3_backup::default"

package "mailx"
package "perl-DBI"
package "perl-JSON"
package "perl-XML-Simple"
package "perl-DBD-MySQL"
package "perl-IO-Socket-SSL"
package "perl-Net-LibIDN"
package "perl-Net-SSLeay"
package "perl-Time-HiRes"
package "libaio"

# where the magic starts

# percona
# had to make this a local file because percona expires their old downloads

remote_file "#{Chef::Config[:file_cache_path]}/percona-toolkit-2.2.15-2.noarch.rpm" do
  source "https://www.percona.com/downloads/percona-toolkit/2.2.15/RPM/percona-toolkit-2.2.15-2.noarch.rpm"
  action :create
  not_if 'rpm -q percona-toolkit'
end

rpm_package "percona-toolkit" do
  source "#{Chef::Config[:file_cache_path]}/percona-toolkit-2.2.15-2.noarch.rpm"
  action :install
  not_if 'rpm -q percona-toolkit'
end

remote_file "#{Chef::Config[:file_cache_path]}/percona-xtrabackup-2.2.12-1.el6.x86_64.rpm" do
  source "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.2.12/binary/redhat/6/x86_64/percona-xtrabackup-2.2.12-1.el6.x86_64.rpm"
  action :create
  not_if 'rpm -q percona-xtrabackup'
end

rpm_package "percona-xtrabackup" do
  source "#{Chef::Config[:file_cache_path]}/percona-xtrabackup-2.2.12-1.el6.x86_64.rpm"
  action :install
  not_if 'rpm -q percona-xtrabackup'
end

template "/usr/local/bin/backup-mysql.sh" do
  source "scripts/backup-mysql.sh.erb"
   mode 0750
  owner "root"
  group "disk"
end

template "/usr/local/bin/restore-mysql.sh" do
  source "scripts/restore-mysql.sh.erb"
   mode 0750
  owner "root"
  group "disk"
end

cookbook_file "/etc/cron.d/backup-mysql" do
  source "cron.d/backup-mysql"
   mode 0640
  owner "root"
  group "root"
end

