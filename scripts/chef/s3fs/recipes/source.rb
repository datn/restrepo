include_recipe 'build-essential'

package "gcc"
package "libstdc++-devel"
package "gcc-c++"
package "curl-devel"
package "libxml2-devel"
package "openssl-devel"
package "mailcap"
package "libconfig"

remote_file "/usr/src/fuse-2.9.3.tar.gz" do
  source "http://downloads.sourceforge.net/project/fuse/fuse-2.X/2.9.3/fuse-2.9.3.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ffuse%2Ffiles%2Ffuse-2.X%2F2.9.4%2F&ts=1442899530&use_mirror=iweb"
  user "root"
end

remote_file "/usr/src/s3fs-1.74.tar.gz" do
  source "https://s3fs.googlecode.com/files/s3fs-1.74.tar.gz"
  user "root"
end

src_path_fuse = "/usr/src/fuse-2.9.3"
src_path_s3fs = "/usr/src/s3fs-1.74"

# fuse 
#
execute "untar fuse" do
  user "root"
  command "tar xzf fuse-2.9.3.tar.gz"
  creates src_path_fuse
  cwd "/usr/src"
  not_if do ::File.exists?('/usr/local/bin/fusermount') end
end

execute "configure fuse build" do
  user "root"
  command "./configure --prefix=/usr"
  creates "#{src_path_fuse}/config.log"
  cwd src_path_fuse
  not_if do ::File.exists?('/usr/local/bin/fusermount') end
end

execute "build fuse" do
  user "root"
  command "make"
  creates "#{src_path_fuse}/util/fusermount"
  cwd src_path_fuse
  not_if do ::File.exists?('/usr/local/bin/fusermount') end
end

execute "install fuse" do
  user "root"
  command "make install"
  creates "/usr/bin/fusermount"
  cwd src_path_fuse
  not_if do ::File.exists?('/usr/local/bin/fusermount') end
end

bash "postinst fuse" do
  user "root"
  cwd src_path_fuse
  code <<-EOH
	export PKG_CONFIG_PATH=/usr/lib/pkgconfig
	/sbin/ldconfig
	modprobe fuse
  EOH
  not_if do ::File.exists?('/usr/local/bin/s3fs') end
end

# s3fs
#
execute "untar s3fs" do
  user "root"
  command "tar xzf s3fs-1.74.tar.gz"
  creates src_path_s3fs
  cwd "/usr/src"
  not_if do ::File.exists?('/usr/local/bin/s3fs') end
end

execute "configure s3fs build" do
  user "root"
  command "export PKG_CONFIG_PATH=/usr/lib/pkgconfig; ./configure"
  creates "#{src_path_s3fs}/config.log"
  cwd src_path_s3fs
  not_if do ::File.exists?('/usr/local/bin/s3fs') end
end

execute "build s3fs" do
  user "root"
  command "make"
  creates "#{src_path_s3fs}/src/s3fs"
  cwd src_path_s3fs
  not_if do ::File.exists?('/usr/local/bin/s3fs') end
end

execute "install s3fs" do
  user "root"
  command "make install"
  creates "/usr/bin/s3fs"
  cwd src_path_s3fs
  not_if do ::File.exists?('/usr/local/bin/s3fs') end
end

