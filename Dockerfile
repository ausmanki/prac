# Build stage (using a vulnerable Maven version)
FROM debricked/vulnerable-functionality-maven:v0.5.0 AS builder
WORKDIR /app

# Create the tomcat user
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

# Copy only necessary files for a more efficient build
COPY pom.xml .
COPY src .

# Build the application with Maven
RUN mvn clean package

# Final stage (using a vulnerable Tomcat image)
FROM consol/tomcat-7.0:latest

# Create the tomcat user in the final stage as well
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

# Copy the WAR file from the builder stage to the Tomcat image
COPY --from=builder /app/target/Web1.war /usr/local/tomcat/webapps/

# Run as a non-root user (adjust if the base image uses a different user)
USER tomcat

# Expose the servlet container's port
EXPOSE 8080

# Note: This Dockerfile uses images with known vulnerabilities for educational/testing purposes.
# It is NOT recommended for production or sensitive environments.
