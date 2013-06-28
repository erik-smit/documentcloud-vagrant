# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  username      = "vagrant"
  app_root      = "/home/#{username}/documentcloud"
  rails_env     = "development"

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.hostname = "dev.dcloud.org"
  config.ssh.username = username
  
  config.vm.network :private_network, ip: "192.168.33.10"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.aliases = %w(dev.dcloud.org)

  config.vm.synced_folder "./documentcloud/", app_root 
  config.vm.synced_folder "./scripts", "/home/#{username}/scripts"

  script = <<-SHELL
    export USERNAME=#{username};
    export RAILS_ENV=#{rails_env};
    sh /vagrant/scripts/base.sh;
    sh /vagrant/scripts/db.sh;
    sh /vagrant/scripts/app.sh;
SHELL

  config.vm.provision :shell, :inline => script
end
