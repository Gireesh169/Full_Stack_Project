#!/bin/bash

# Smart City Backend Runner Script

echo "======================================"
echo "  Smart City Backend - Startup Script"
echo "======================================"
echo ""

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Error: Java is not installed!"
    echo "Please install Java 17 or higher"
    exit 1
fi

echo "✅ Java version:"
java -version
echo ""

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Error: Maven is not installed!"
    echo "Please install Maven"
    exit 1
fi

echo "✅ Maven version:"
mvn -version | head -1
echo ""

# Check MySQL connection
echo "📊 Checking MySQL connection..."
if ! mysql -u root -proot -e "SELECT 1" &> /dev/null; then
    echo "⚠️  Warning: Cannot connect to MySQL with default credentials"
    echo "Make sure MySQL is running and credentials in application.properties are correct"
    echo ""
fi

# Ask user what to do
echo "Select an option:"
echo "1) Clean build and run"
echo "2) Just run (skip build)"
echo "3) Build only"
echo "4) Exit"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        echo ""
        echo "🔨 Building project..."
        mvn clean install -DskipTests
        if [ $? -eq 0 ]; then
            echo ""
            echo "🚀 Starting application..."
            echo "API will be available at: http://localhost:8080"
            echo "Press Ctrl+C to stop"
            echo ""
            mvn spring-boot:run
        else
            echo "❌ Build failed!"
            exit 1
        fi
        ;;
    2)
        echo ""
        echo "🚀 Starting application..."
        echo "API will be available at: http://localhost:8080"
        echo "Press Ctrl+C to stop"
        echo ""
        mvn spring-boot:run
        ;;
    3)
        echo ""
        echo "🔨 Building project..."
        mvn clean install -DskipTests
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ Build successful!"
        else
            echo "❌ Build failed!"
            exit 1
        fi
        ;;
    4)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac
