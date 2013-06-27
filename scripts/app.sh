# Ensure nginx is installed
test -e /usr/local/nginx || {sudo gem install passenger; sudo /usr/local/bin/passenger-install-nginx-module --auto --auto-download \
    --prefix /usr/local/nginx --extra-configure-flags='--with-http_gzip_static_module --with-http_ssl_module --with-http_stub_status_module'}

test -e /usr/local/nginx || { echo "nginx not properly installed" >&2; exit 1; }

LINE='export PATH=$PATH:/usr/local/nginx/sbin'
grep -q "$LINE" .bashrc 2>/dev/null || echo "$LINE" >> .bashrc

sudo mkdir -p /usr/local/nginx/conf/sites-enabled /var/log/nginx/
sudo ruby /home/vagrant/scripts/configure_nginx.rb

cd /home/vagrant/documentcloud
test -e secrets/keys || { cp -r config/server/keys secrets/ ; }

sudo cp config/server/nginx/nginx.init /etc/init.d/nginx
sudo update-rc.d nginx defaults
sudo /etc/init.d/nginx start
