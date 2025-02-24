FROM tomcat:10.1-jdk21
COPY survey.war /usr/local/tomcat/webapps/
EXPOSE 8080


