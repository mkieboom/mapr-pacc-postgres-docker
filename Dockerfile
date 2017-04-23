# Postgres on MapR PACC
#
# VERSION 0.1 - not for production, use at own risk
#

#
# Use a blank CentOS 7 image as the base
# Based on the CentOS Postgres Docker image from: https://github.com/CentOS/CentOS-Dockerfiles
FROM centos:centos7

# Location where Postgress can store it's data files on MapR-FS
ENV PGDATA_LOCATION /mapr/demo.mapr.com/postgres

# MapR PACC Specific Details
ENV container docker

RUN yum -y upgrade && yum install -y curl file net-tools openssl sudo syslinux wget which java-1.8.0-openjdk-devel && yum -q clean all

LABEL mapr.os=centos6 mapr.version=5.2.1 mapr.mep_version=3.0

RUN mkdir -p /opt/mapr/installer/docker/ && \
	curl -L -o /opt/mapr/installer/docker/mapr-setup.sh http://package.mapr.com/releases/installer/mapr-setup.sh && \
    chmod +x /opt/mapr/installer/docker/mapr-setup.sh

#COPY mapr-setup.sh /opt/mapr/installer/docker/

RUN /opt/mapr/installer/docker/mapr-setup.sh -r http://package.mapr.com/releases container client 5.2.1 3.0

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

ENTRYPOINT ["/opt/mapr/installer/docker/mapr-setup.sh", "container"]
CMD ["start"]

# Manually launch Postgres server:
# sudo su -
# /launch.sh &

