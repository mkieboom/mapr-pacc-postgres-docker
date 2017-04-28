#!/bin/bash

echo "Mounting Postgres data location at:"
export PG_CONFDIR="/var/lib/pgsql/data"
echo $PG_CONFDIR
echo ""

# Following commands probably need late running (eg: after MapR-FS is reachable)
sudo /usr/bin/postgresql-setup initdb
sudo \cp /postgresql.conf $PG_CONFDIR/
sudo chown postgres:postgres $PG_CONFDIR/postgresql.conf
sudo echo "host    all             all             0.0.0.0/0               md5" >> $PG_CONFDIR/pg_hba.conf

# Launch Postgres
sudo /bin/bash /start_postgres.sh
