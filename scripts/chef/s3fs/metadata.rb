name             's3fs'
maintainer       'datn'
maintainer_email 'd@n.gheex.com'
description      's3fs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'
%w{ yum}.each do |x|
	depends x
end
