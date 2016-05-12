name             's3_backup'
maintainer       'datn'
maintainer_email 'd@n.gheex.com'
description      'various backup utilities'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.6'
%w{ yum s3fs}.each do |x|
	depends x
end
