 FROM tomcat:8.5

 MAINTAINER Tom Eggebraaten

 WORKDIR /usr/local/tomcat/webapps
 COPY chickendash/target/chickendash-0.1.war /usr/local/tomcat/webapps/chickendash.war
 RUN rm -rf chickendash
 EXPOSE 8080
 CMD ["catalina.sh", "run"]