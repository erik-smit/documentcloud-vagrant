# Ensure nginx is installed
test $DCLOUD_HOME || { echo "DCLOUD_HOME has to be set" >&2; exit 1; }

if [ ! -d /usr/local/nginx ]; then
echo "Installing nginx"	
gem install passenger; 
/usr/local/bin/passenger-install-nginx-module --auto --auto-download \
    --prefix /usr/local/nginx \
    --extra-configure-flags='--with-http_gzip_static_module --with-http_ssl_module --with-http_stub_status_module';
fi

test -e /usr/local/nginx || { echo "nginx not properly installed" >&2; exit 1; }

LINE='export PATH=$PATH:/usr/local/nginx/sbin'
grep -q "$LINE" .bashrc 2>/dev/null || echo "$LINE" >> .bashrc

mkdir -p /usr/local/nginx/conf/sites-enabled /var/log/nginx/
ruby /vagrant/scripts/configure_nginx.rb

cd $DCLOUD_HOME
test -e secrets/keys || { cp -r config/server/keys secrets/ ; }
./script/runner /vagrant/scripts/provision.rb
crowd -c config/cloud_crowd/development -e development load_schema

cp config/server/nginx/nginx.init /etc/init.d/nginx
update-rc.d nginx defaults
service nginx start
