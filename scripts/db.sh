# verify that postgres is loaded properly

test $USERNAME  || { echo "USERNAME has to be set" >&2; exit 1; }
test $RAILS_ENV || { echo "RAILS_ENV has to be set" >&2; exit 1; }
test $DCLOUD_HOME || { echo "DCLOUD_HOME has to be set" >&2; exit 1; }

test -e /etc/postgresql/9.1/main/pg_hba.conf || { echo "Can't find the PostgreSQL 9.1 Client Authentication Configuration File (/etc/postgresql/9.1/main/pg_hba.conf)" >&2; exit 1; }

cd $DCLOUD_HOME

# setup dummy postgres environment so that you can verify rails is working
sudo cp config/server/postgres/pg_hba.conf  /etc/postgresql/9.1/main/pg_hba.conf
service postgresql restart

sudo -u postgres createuser -s $USERNAME
sudo -u postgres createuser -s documentcloud
test $DB_PASSWORD || DB_PASSWORD='documentcloudVirtualMachine'
echo "alter user documentcloud password '$DB_PASSWORD' " | sudo -u postgres psql

# verify that databases don't already exist
DB_NAME="dcloud_development"
if sudo -u postgres psql ${DB_NAME} -c '\q' 2>&1; then
  echo "database ${DB_NAME} already exists"
else
	# create dcloud_#{env} and dcloud_analytics_#{env}
	sudo -u postgres createdb dcloud_analytics_$RAILS_ENV
	sudo -u postgres createdb $DB_NAME
	
	# install hstore for dcloud_#{env}
	echo "CREATE EXTENSION hstore;" | sudo -u postgres psql $DB_NAME
	# import development schema to dcloud_#{env} and analytics schema to dcloud_analytics_#{env}
	sudo -u postgres psql -f db/development_structure.sql $DB_NAME 2>&1|grep ERROR
	sudo -u postgres psql -f db/analytics_structure.sql dcloud_analytics_$RAILS_ENV 2>&1|grep ERROR
fi

rake db:migrate
