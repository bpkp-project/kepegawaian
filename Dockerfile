# Stage 1: Build JAR menggunakan Maven
FROM maven:3.9.11-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
# Create dummy GraphQL schema to avoid plugin error
RUN mkdir -p src/main/resources/graphql-client && \
    echo "query DummyQuery { _dummy }" > src/main/resources/graphql-client/dummy.graphql
RUN mvn clean package -DskipTests

# Stage 2: Jalankan aplikasi dengan JDK 21 (lebih kecil)
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]