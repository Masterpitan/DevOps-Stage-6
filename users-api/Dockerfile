FROM eclipse-temurin:11-jdk AS builder

WORKDIR /app
COPY . .
RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:11-jre

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8083
CMD ["java", "-jar", "app.jar"]