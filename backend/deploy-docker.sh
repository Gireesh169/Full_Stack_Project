#!/bin/bash

# Smart City Backend - Docker Build & Deploy Script

set -e

echo "======================================"
echo "  Smart City Backend - Docker Deploy"
echo "======================================"
echo ""

# Configuration
IMAGE_NAME="smart-city-backend"
IMAGE_TAG="1.0.0"
CONTAINER_NAME="smart-city-api"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Build Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} \
             -t ${IMAGE_NAME}:latest \
             .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker image built successfully${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi

# Stop existing container if running
if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo -e "${YELLOW}Stopping existing container...${NC}"
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
fi

# Run container
echo -e "${YELLOW}Starting container...${NC}"
docker run -d \
    --name ${CONTAINER_NAME} \
    -p 8080:8080 \
    -e SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL:-jdbc:mysql://host.docker.internal:3306/smart_city_db} \
    -e SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME:-root} \
    -e SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD:-root} \
    -e PORT=8080 \
    --restart unless-stopped \
    ${IMAGE_NAME}:${IMAGE_TAG}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Container started successfully${NC}"
    echo ""
    echo "Backend is running at: http://localhost:8080"
    echo ""
    echo "View logs with: docker logs -f ${CONTAINER_NAME}"
else
    echo -e "${RED}❌ Failed to start container${NC}"
    exit 1
fi
