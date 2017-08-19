# Postgres on MapR PACC
#
# VERSION 0.2 - not for production, use at own risk
#

#
# Use a MapR PACC CentOS 7 image as the base
#FROM maprtech/pacc
FROM maprtech/pacc:5.2.0_2.0_centos7

MAINTAINER mkieboom @ mapr.com

# Fix the MapR repositories as they are currently pointing to MapR internal repo's
RUN sed -ie "s|artifactory.devops.lab/artifactory/prestage|package.mapr.com|g" /etc/yum.repos.d/mapr_eco.repo
RUN sed -ie "s|artifactory.devops.lab/artifactory/prestage|package.mapr.com|g" /etc/yum.repos.d/mapr_core.repo

# Install Postgres
RUN yum install -y postgresql-server

# Add the launch script and make it executable
ADD ./launch.sh /launch.sh
RUN chmod +x /launch.sh

# Expose the Postgres server port
EXPOSE 5432

CMD ["start", "/launch.sh"]