#
# Cookbook Name:: php-redis
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "#{Chef::Config[:file_cache_path]}/phpredis" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

git "#{Chef::Config[:file_cache_path]}/phpredis" do                            
    repository node[:php_redis][:repository]
    revision "master"                                  
    action :sync                                     
    user node[:php_redis][:user]
end


execute "build & install php-redis" do
  cwd "#{Chef::Config[:file_cache_path]}/phpredis"
  command "phpize && ./configure && make && make install"
  user node[:php_redis][:user]
end

execute "enable php-redis" do
  command "echo 'extension=redis.so' > #{node[:php_fpm][:dir]}/conf.d/phpredis.ini"
  user node[:php_redis][:user]
end