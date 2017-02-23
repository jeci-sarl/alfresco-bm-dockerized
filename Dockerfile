FROM tomcat:7.0.73-jre8
MAINTAINER Jeremie Lesage <jeremie.lesage@gmail.com>

ARG WAR_FILE
ARG APP_NAME

# Default Port 9080
COPY server.xml /usr/local/tomcat/conf/server.xml
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

ENV CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Dfile.encoding=UTF-8 "

COPY $WAR_FILE /usr/local/tomcat/webapps/

RUN rm -r /usr/local/tomcat/webapps/docs \
    && rm -r /usr/local/tomcat/webapps/examples \
    && rm -r /usr/local/tomcat/webapps/ROOT \
    && unzip -q /usr/local/tomcat/webapps/$WAR_FILE -d /usr/local/tomcat/webapps/$APP_NAME \
    && rm /usr/local/tomcat/webapps/$WAR_FILE
