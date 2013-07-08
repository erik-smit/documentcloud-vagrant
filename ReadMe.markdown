# DocumentCloud Vagrant VM

These [Vagrant](http://www.vagrantup.com/) setup provides a development environment for the DocumentCloud platform. [DocumentCloud](http://www.documentcloud.org) itself is a web based platform for uploading, analyzing, annotating and publishing primary source material.

## Requirements
* [Vagrant 1.1.x or higher](http://docs.vagrantup.com/v2/installation/index.html)
* [Vagrant's Host Manager plugin](https://github.com/smdahlen/vagrant-hostmanager): 
	
	``` vagrant plugin install vagrant-hostmanager ```

## Start

* Clone documentcloud repository in this repository folder:

	```git clone https://github.com/documentcloud/documentcloud.git```

* Start VM: ```vagrant up```

* Add the alias **dev.dcloud.org** for the VM running the command: ```vagrant hostmanager```

## Login
* Go to [http://dev.dcloud.org](http://dev.dcloud.org)
* Log in as **admin@dev.dcloud.org** with passsword **admin**

## What is provisioned?
* Uses ***precise64*** Vagrant default box
* Installs PostgreSQL, Nginx, Phusion Passenger
* _home/vagrant/documentcloud_ is linked as default site
* Create datadabase and Start [Crowd Cloud](https://github.com/documentcloud/cloud-crowd);
	- crowd -c config/cloud_crowd/development -e development load_schema
	- rake crowd:server:start crowd:node:start
* Start Solr
	- rake sunspot:solr:start


### Some internal links
* To create Organizations: [https://dev.dcloud.org/admin/signup](https://dev.dcloud.org/admin/signup)
* [https://dev.dcloud.org/admin/featured](https://dev.dcloud.org/admin/featured)	