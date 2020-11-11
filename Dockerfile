 FROM tomcat:8.5

 MAINTAINER Tom Eggebraaten

 WORKDIR /usr/local/tomcat/webapps
 COPY target/chickendash.war .
 RUN rm -rf chickendash
 CMD ["catalina.sh", "run"]