#
# Cookbook Name:: my_apache2
# Recipe:: default
#
# Copyright 2013, Anagix Corp.
#
# All rights reserved - Do Not Redistribute
#

if (node[:platform] == 'ubuntu' && node[:platform_version] >= '13.10') ||
   (node[:platform] == 'linuxmint' && node[:platform_version] >= '17.1')
  package 'apache2' do
    action :install
  end
  bash 'set apache2 modules' do
    not_if { ::File.exist? 'lbmethd_byrequests.load' }
    user 'root'
    cwd '/etc/apache2/mods-enabled'
    code <<-EOH
       a2enmod proxy
       a2enmod proxy_balancer
       a2enmod proxy_http
       if ! [ -e lbmethd_byrequests.load ]; then ln -s ../mods-available/lbmethod_byrequests.load lbmethd_byrequests.load; fi
       EOH
  end
  conf = '/etc/apache2/conf-enabled/alb_server.conf'
else
  include_recipe 'apache2'
  include_recipe 'apache2::mod_cgi'
  include_recipe 'apache2::mod_log_config'
  include_recipe 'apache2::mod_logio'
  include_recipe 'logrotate'

  case node[:platform]
  when 'ubuntu', 'debian', 'linuxmint'
    conf = '/etc/apache2/conf.d/alb_server.conf'
  when 'centos', 'redhat'
    conf = '/etc/httpd/sites-enabled/alb_server.conf'
end

#  the below does not work
#  template "apache2.conf" do
#    source "apache2.conf.erb"
#    owner "root"
#    group node['apache']['root_group']
#    mode 00644
#  end
end

template conf do
  source 'alb_server.conf'
  owner 'anagix'
  notifies :restart, 'service[apache2]'
end

service 'apache2'
