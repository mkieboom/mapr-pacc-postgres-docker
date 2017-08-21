# mapr-pacc-postgres-docker

##### Clone the project
```
git clone https://github.com/mkieboom/mapr-pacc-postgres-docker  
cd mapr-pacc-postgres-docker  
```

##### Modify the Postgres variables
By modifying the Dockerfile, eg:  
```
vi Dockerfile
PGDATA_LOCATION=/mapr/demo.mapr.com/postgres
PG_USER=mapr
PG_PWD=mapr
PG_DB=mapr
```
Or by providing them as command line arguments in the below docker run commands, eg:  
```
-e PGDATA_LOCATION=/mapr/demo.mapr.com/postgres \
-e PG_USER=mapr \
-e PG_PWD=mapr \
-e PG_DB=mapr \
```

##### Create the Postgres data directory  
```
# Manually create the MapR volume for the Postgress Data Location
# eg: in case of PGDATA_LOCATION=/mapr/demo.mapr.com/postgres:
maprcli volume create -name postgres -path /postgres
```
##### Build the container  
```
docker build -t mkieboom/mapr-pacc-postgres-docker .
```

##### Launch the container 
```
# Change the MapR specific command line parameters to reflect your MapR cluster 
  
docker run -it \
--cap-add SYS_ADMIN \
--cap-add SYS_RESOURCE \
--device /dev/fuse \
-e MAPR_CLUSTER=demo.mapr.com \
-e MAPR_CLDB_HOSTS=MAPRN01 \
-e MAPR_CONTAINER_USER=mapr \
-e MAPR_CONTAINER_GROUP=mapr \
-e MAPR_CONTAINER_UID=5000 \
-e MAPR_CONTAINER_GID=5000 \
-e MAPR_MOUNT_PATH=/mapr \
-p 5432:5432 \
mkieboom/mapr-pacc-postgres-docker
```
##### Launch container as deamon with auto restart  
```
# Change the MapR specific command line parameters to reflect your MapR cluster 
  
docker run -d \
--restart always \  
--cap-add SYS_ADMIN \
--cap-add SYS_RESOURCE \
--device /dev/fuse \
-e MAPR_CLUSTER=demo.mapr.com \
-e MAPR_CLDB_HOSTS=MAPRN01 \
-e MAPR_CONTAINER_USER=mapr \
-e MAPR_CONTAINER_GROUP=mapr \
-e MAPR_CONTAINER_UID=5000 \
-e MAPR_CONTAINER_GID=5000 \
-e MAPR_MOUNT_PATH=/mapr \
-p 5432:5432 \
mkieboom/mapr-pacc-postgres-docker
```

##### Use psql to connect  
```
# Install psql client on any other machine  
yum install -y postgresql
```

##### Connect to remote database  
```
psql -U mapr -h maprn01 -p 5432
```

##### Basic SQL testing
```
CREATE SCHEMA test;
CREATE TABLE test.test (coltest varchar(20));
insert into test.test (coltest) values ('It works!');
SELECT * from test.test;
```
