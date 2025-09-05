#
# Build stage
#
FROM maven:3.9.6-eclipse-temurin-24 as build

WORKDIR /app

# Copy only files needed to download dependencies first
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Download dependencies (cacheable layer)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

#
# Runtime stage
#
FROM eclipse-temurin:24-jre-alpine

WORKDIR /app

# Copy jar file from build stage (replace `demo` with your actual jar name)
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
