 FROM tomcat:8.5

 MAINTAINER Tom Eggebraaten

 WORKDIR /usr/local/tomcat/webapps
 COPY target/*.war .
 RUN mv *.war ROOT.war
 RUN rm -rf ROOT
 CMD ["catalina.sh", "run"]