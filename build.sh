#!/bin/bash

echo "Building Java application..."
cd users-api
./mvnw clean package -DskipTests
cd ..

echo "Starting application with Docker Compose..."
docker-compose up -d --build

echo "Application is starting up. Please wait..."
sleep 30

echo "Checking service status..."
docker-compose ps