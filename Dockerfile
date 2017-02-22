FROM tomcat:7.0.73-jre8
MAINTAINER Jeremie Lesage <jeremie.lesage@gmail.com>

ARG WAR_FILE

# Default Port 9080
COPY server.xml /usr/local/tomcat/conf/server.xml
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

RUN rm -r /usr/local/tomcat/webapps/docs \
    && rm -r /usr/local/tomcat/webapps/examples


COPY $WAR_FILE /usr/local/tomcat/webapps/
