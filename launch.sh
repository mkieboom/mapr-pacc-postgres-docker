#!/bin/bash

echo $PG_CONFDIR
export PG_CONFDIR="/var/lib/pgsql/data"
echo $PG_CONFDIR

# Following commands probably need late running (eg: after MapR-FS is reachable)
/usr/bin/postgresql-setup initdb
\cp /postgresql.conf $PG_CONFDIR/
chown postgres:postgres $PG_CONFDIR/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" >> $PGDATA_LOCATION/pg_hba.conf

# Launch Postgres
/bin/bash /start_postgres.sh

