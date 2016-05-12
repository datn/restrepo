#
# Cookbook Name:: s3fs
# Recipe:: default
#
# Copyright 2013, Dan Shick 
#

include_recipe "s3fs::source"

s3fsdata = data_bag_item("credentials", "s3fs")
iamkey = s3fsdata['AWS_ACCESS_KEY_ID']
iamseckey = s3fsdata['AWS_SECRET_ACCESS_KEY']

template "/etc/passwd-s3fs" do
  source "passwd-s3fs"
  owner "root"
  group "root"
  mode "0640"
  variables ({:iamkey => iamkey, :iamseckey => iamseckey })
end

directory node[:s3fs][:mountpoint] do
  mode 0755
  owner "root"
  group "root"
  not_if "mount | grep -q #{node[:s3fs][:mountpoint]}"
end

bucket = node[:s3fs][:bucket]
mountpoint = node[:s3fs][:mountpoint]
mountoptions = node[:s3fs][:mountoptions]

mount node[:s3fs][:mountpoint] do
  device "s3fs\##{bucket}"
  fstype "fuse"
  options node[:s3fs][:mountoptions]
  action :enable
  not_if @bucket == ""
end

