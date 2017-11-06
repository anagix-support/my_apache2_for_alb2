name 'my_apache2_for_alb2'
maintainer       "Anagix Corportion"
maintainer_email "Seijiro Moriyama"
license          "All rights reserved"
description      "Installs/Configures my_apache2"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.7"
depends 'apache2'
depends 'logrotate'
