dcloud_home = ENV['DCLOUD_HOME'] || abort("DCLOUD_HOME environment variable should be set.")

Organization.transaction do

	admin_email = "admin@dev.dcloud.org"
	if Account.find_by_email(admin_email).nil?
		admin = Account.new(:first_name => "Admin", :last_name => "Istrator", :email => admin_email)
		password="admin"
		admin.password=password
		admin.save!
		puts "Created Testing Organization: #{admin_email}/#{password}"
	end

	org_slug = "dev-dcloud"
	if Organization.find_by_slug( org_slug ).nil?
		org = Organization.create(:name => "Dev DCloud", :slug => org_slug)
		org.add_member(admin, Account::ADMINISTRATOR)
		org.id=1
		org.save!
		puts "Created Testing Organization: #{org_slug}"
	end  
end