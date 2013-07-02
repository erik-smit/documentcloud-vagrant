require 'fileutils'
require 'erb'

here = File.dirname(__FILE__)
rails_env = ENV['RAILS_ENV'] || "development"
nginx_home = ENV['NGINX_HOME'] || "/usr/local/nginx"
dcloud_home = ENV['DCLOUD_HOME'] || abort("DCLOUD_HOME environment variable should be set.")

File.open "#{nginx_home}/conf/nginx.conf", "w" do |nginx_conf|
  passenger_root      = `passenger-config --root`
  nginx_conf_template = File.open(File.join(here, "erb", "nginx.conf.erb")).read
  nginx_conf.puts ERB.new(nginx_conf_template).result(binding)
end

File.open "#{nginx_home}/conf/sites-enabled/#{rails_env}.conf", "w" do |site_conf|
  certpath = "/home/vagrant/documentcloud/secrets/keys/dev.dcloud.org.crt"
  keypath  = "/home/vagrant/documentcloud/secrets/keys/dev.dcloud.org.key"

  site_conf_template = File.open(File.join(here, "erb", "site.conf.erb")).read
  site_conf.puts ERB.new(site_conf_template).result(binding)
end

File.open "#{nginx_home}/conf/documentcloud.conf", "w" do |dc_conf|
  server_name = "dev.dcloud.org"
  app_root    = "#{dcloud_home}/public"

  dc_conf_template = File.open(File.join(here, "erb", "documentcloud.conf.erb")).read
  dc_conf.puts ERB.new(dc_conf_template).result(binding)
end
