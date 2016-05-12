#
# Cookbook Name:: s3fs
# Recipe:: example
#
# Copyright 2014, Dan Shick 
#
#
include_recipe "s3fs::default"
node.set[:s3fs][:mountpoint]="/path/to/shared/data"
node.set[:s3fs][:bucket]="bucket-name"
node.set[:s3fs][:mountoptions]="nonempty,allow_other,use_cache=/tmp"
