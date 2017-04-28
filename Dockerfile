# Postgres on MapR PACC
#
# VERSION 0.1 - not for production, use at own risk
#

#
# Use a MapR PACC 5.2.0 on CentOS 7 image as the base
# Based on the CentOS Postgres Docker image from: https://github.com/CentOS/CentOS-Dockerfiles
#FROM maprtech/pacc:5.2.1_3.0_centos7
FROM maprtech/pacc:5.2.0_2.0_centos7

# Location where Postgress can store it's data files on MapR-FS
ENV PGDATA_LOCATION /mapr/demo.mapr.com/postgres


# Fix the MapR repositories as they are currently pointing to MapR internal repo's
RUN sed -ie "s|artifactory.devops.lab/artifactory/prestage|package.mapr.com|g" /etc/yum.repos.d/mapr_eco.repo
RUN sed -ie "s|artifactory.devops.lab/artifactory/prestage|package.mapr.com|g" /etc/yum.repos.d/mapr_core.repo


# POSTGRES SPECIFIC DETAILS

# Install prerequisites
RUN yum -y install postgresql-server postgresql postgresql-contrib supervisor pwgen; yum clean all

ADD ./postgresql-setup /usr/bin/postgresql-setup
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./start_postgres.sh /start_postgres.sh
ADD ./postgresql.conf /postgresql.conf
ADD ./launch.sh /launch.sh

#Sudo requires a tty. fix that.
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers
RUN chmod +x /usr/bin/postgresql-setup
RUN chmod +x /start_postgres.sh
RUN chmod +x /launch.sh

# Set Postgres data location using env ${PGDATA_LOCATION}
RUN sed -ie "s|/var/lib/pgsql/data|${PGDATA_LOCATION}|g" /etc/supervisord.conf
RUN sed -ie "s|/var/lib/pgsql/data|${PGDATA_LOCATION}|g" /var/lib/pgsql/.bash_profile
RUN sed -ie "s|/var/lib/pgsql/data|${PGDATA_LOCATION}|g" /usr/lib/systemd/system/postgresql.service
RUN sed -ie "s|/var/lib/pgsql/data|${PGDATA_LOCATION}|g" /usr/bin/postgresql-setup
RUN sed -ie "s|/var/lib/pgsql/data|${PGDATA_LOCATION}|g" /launch.sh


EXPOSE 5432

CMD ["start", "/launch.sh"]