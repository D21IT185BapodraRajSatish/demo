#
# Build stage
#
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and Maven wrapper to install dependencies first (optional optimization)
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Pre-download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy the rest of the app
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

#
# Runtime stage
#
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy only the built jar from the build image
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Start the app
ENTRYPOINT ["java", "-jar", "app.jar"]
