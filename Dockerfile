# Postgres on MapR PACC
#
# VERSION 0.2 - not for production, use at own risk
#

#
# Use a MapR PACC CentOS 7 image as the base
FROM maprtech/pacc

MAINTAINER mkieboom @ mapr.com

# Set Postgres environment variables, change to your liking
ENV PGDATA_LOCATION /mapr/demo.mapr.com/postgres
ENV PG_USER mapr
ENV PG_PWD mapr
ENV PG_DB mapr

# Install Postgres
RUN yum install -y postgresql-server

# Add the launch script and make it executable
ADD ./launch.sh /launch.sh
RUN chmod +x /launch.sh

# Expose the Postgres server port
EXPOSE 5432

CMD /launch.sh