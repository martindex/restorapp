# Build stage
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Production stage
FROM eclipse-temurin:17-jre

WORKDIR /app

# Install wget for healthcheck
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Copy the JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Create directories
RUN mkdir -p /app/logs

# Expose ports
EXPOSE 8080
EXPOSE 5005

# Environment variables
ENV SPRING_PROFILES_ACTIVE=prod
ENV JAVA_TOOL_OPTIONS=""

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application with optional debug support
# Debug is enabled via JAVA_TOOL_OPTIONS environment variable
ENTRYPOINT ["java", "-jar", "app.jar"]
