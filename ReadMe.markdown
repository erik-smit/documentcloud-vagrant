# DocumentCloud Vagrant VM

These Vagrant scripts provide a(n ALPHA-STAGE) development environment for the DocumentCloud platform.  [DocumentCloud](http://www.documentcloud.org) itself is a web based platform for uploading, analyzing, annotating and publishing primary source material.

Clone documentcloud repository
	git clone https://github.com/documentcloud/documentcloud.git

To add vm aliases to host (/etc/hosts) (https://github.com/smdahlen/vagrant-hostmanager)
	vagrant plugin install vagrant-hostmanager
	vagrant hostmanager

Create and Start Crowd Cloud
	crowd -c config/cloud_crowd/development -e development load_schema
	rake crowd:server:start crowd:node:start

Start Solr
	rake sunspot:solr:start

Create Admin User
	admin = Account.new(:first_name => "Admin", :last_name => "Istrator", :email => "admin@dev.dcloud.org")
	admin.password=123
	admin.save!

	org = Organization.create(:name => "Dev DCloud", :slug => "dev-dcloud")
	org.add_member(admin, 1)
	org.save!


To create Organizations
	https://dev.dcloud.org/admin/signup

	https://dev.dcloud.org/admin/featured	