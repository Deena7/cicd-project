# Use Java 17 base image
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy built jar from target/
COPY target/cicd-demo-0.0.1-SNAPSHOT.jar app.jar

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]

