#!/bin/bash

# Test script to verify complaint creation
echo "Testing Complaint API..."

# First, login to get a token
echo -e "\n1. Logging in..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}')

echo "Login Response: $LOGIN_RESPONSE"

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
USER_ID=$(echo $LOGIN_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [ -z "$TOKEN" ]; then
  echo "❌ Failed to get token. Creating test user..."
  
  # Create a test user
  SIGNUP_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/signup \
    -H "Content-Type: application/json" \
    -d '{"name": "Test User", "email": "test@example.com", "password": "password123", "role": "CITIZEN"}')
  
  echo "Signup Response: $SIGNUP_RESPONSE"
  
  # Try login again
  LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email": "test@example.com", "password": "password123"}')
  
  TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
  USER_ID=$(echo $LOGIN_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
fi

if [ -z "$TOKEN" ]; then
  echo "❌ Still failed to get token. Exiting."
  exit 1
fi

echo -e "\n✅ Token: ${TOKEN:0:20}..."
echo "✅ User ID: $USER_ID"

# Create a complaint
echo -e "\n2. Creating a complaint..."
COMPLAINT_RESPONSE=$(curl -s -X POST "http://localhost:8080/api/complaints?userId=$USER_ID" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Test Complaint",
    "description": "This is a test complaint to verify database connectivity",
    "category": "Water Supply"
  }')

echo "Complaint Response: $COMPLAINT_RESPONSE"

# Check if complaint was created
if echo "$COMPLAINT_RESPONSE" | grep -q '"id"'; then
  echo -e "\n✅ Complaint created successfully!"
  COMPLAINT_ID=$(echo $COMPLAINT_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
  echo "Complaint ID: $COMPLAINT_ID"
else
  echo -e "\n❌ Failed to create complaint"
  echo "Response: $COMPLAINT_RESPONSE"
fi

# Get all complaints by user
echo -e "\n3. Fetching user complaints..."
USER_COMPLAINTS=$(curl -s -X GET "http://localhost:8080/api/complaints/user/$USER_ID" \
  -H "Authorization: Bearer $TOKEN")

echo "User Complaints: $USER_COMPLAINTS"

echo -e "\n✅ Test completed!"
