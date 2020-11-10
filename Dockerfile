 FROM tomcat
 WORKDIR /usr/local/tomcat/webapps
 COPY '${{ github.workspace }}/target/*.war' .
 RUN mv *.war ROOT.war
 RUN rm -rf ROOT
 CMD ["catalina.sh", "run"]