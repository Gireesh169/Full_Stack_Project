#!/bin/bash

# Smart City Backend - Docker Compose Deploy Script

set -e

echo "======================================"
echo "  Smart City Full Stack - Docker Compose"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed${NC}"
    echo "Please install Docker Compose from: https://docs.docker.com/compose/install/"
    exit 1
fi

# Build and start services
echo -e "${YELLOW}Building and starting services...${NC}"
docker-compose up -d

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ All services started successfully${NC}"
    echo ""
    echo "Services running:"
    echo "  - Backend API: http://localhost:8080"
    echo "  - Frontend: http://localhost:5173"
    echo "  - MySQL: localhost:3306"
    echo ""
    echo "View logs with: docker-compose logs -f"
    echo "Stop services with: docker-compose down"
else
    echo -e "${RED}❌ Failed to start services${NC}"
    exit 1
fi
