# Use the official Tomcat image as the base image
FROM tomcat:10.1.13-jdk17

# Set metadata for the image
LABEL author="Akin"
LABEL project="jendarey-voting-app-project"

# Remove the default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the .war file into the Tomcat webapps directory
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 for the application
EXPOSE 8080

# Define the default command to start Tomcat
CMD ["catalina.sh", "run"]

# docker build . -t jendaredocker/jendarey-voting-app-two
# docker run -d -p 11000:8080 --name=voting-app-two jendaredocker/jendarey-voting-app-two:latest

# Please you use tomcat 10.1.13
# download tomcat 10.1.13-jdk17
# copy the .war file to the `webapps` directory in tomcat:10.1.13-jdk17
# cp target/a23-webpage.war tomcat:10.1.13-jdk17:/usr/local/tomcat/webapps/
# Start the Tomcat container
# EveryThing looks good edit

# Docker me me
# docker-compose up
# docker exec -it ac7 bash 
# ls /usr/local/tomcat/logs
# cat /usr/local/tomcat/logs
# docker logs jendarey-tech-mongo-1

# docker run -it -p 8080:8080 tomcat:10.1.13-jdk17
# docker compose up
# docker exec -it ac7 bash 
# /usr/local/tomcat/logs#
# docker logs jendarey-tech-mongo-1
