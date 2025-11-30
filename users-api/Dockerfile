# FROM amazoncorretto:8-alpine AS builder
FROM eclipse-temurin:8-jdk AS builder

WORKDIR /app

# Copy Maven wrapper in addition to project files
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
COPY src src

# Fix line endings and Ensure Maven wrapper is executable
RUN sed -i 's/\r$//' mvnw && \
    chmod +x mvnw

# Debug: verify files are copied
# RUN ls -la
# RUN ls -la .mvn/wrapper/
# RUN find . -name "*.jar" -o -name "*.properties"


# Build the project and skip tests
RUN ./mvnw package -DskipTests


FROM eclipse-temurin:8-jre

WORKDIR /app


COPY --from=builder /app/target/*.jar /app/app.jar

# Expose default port
EXPOSE 8083

CMD ["java", "-jar", "app.jar"]
