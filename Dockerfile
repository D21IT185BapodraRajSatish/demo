# Build stage: Use Maven with OpenJDK 24
FROM maven:3.9.6-eclipse-temurin-24 AS build

WORKDIR /app

# Copy pom, Maven wrapper files & download dependencies
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
RUN ./mvnw dependency:go-offline -B

# Copy source code and build the app (skip tests for faster build)
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Run stage: Use OpenJDK 24 JRE image
FROM eclipse-temurin:24-jre-alpine

WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
