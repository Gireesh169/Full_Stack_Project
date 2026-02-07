#!/bin/bash
# Simple complaint creation test

echo "🔍 Testing Complaint API..."

# Login
echo "1. Logging in..."
LOGIN_RESP=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}')

TOKEN=$(echo "$LOGIN_RESP" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
USER_ID=$(echo "$LOGIN_RESP" | grep -o '"id":[0-9]*' | cut -d':' -f2)

echo "✅ Token obtained (first 30 chars): ${TOKEN:0:30}..."
echo "✅ User ID: $USER_ID"

# Create complaint
echo -e "\n2. Creating a complaint..."
COMPLAINT_RESP=$(curl -s -X POST "http://localhost:8080/api/complaints?userId=$USER_ID" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Street Light Issue",
    "description": "Street light not working on Main Street",
    "category": "Infrastructure"
  }')

echo "Response (first 500 chars):"
echo "$COMPLAINT_RESP" | head -c 500
echo -e "\n..."

# Check if response has infinite loop
RESP_SIZE=$(echo "$COMPLAINT_RESP" | wc -c)
echo -e "\n📊 Response size: $RESP_SIZE bytes"

if [ "$RESP_SIZE" -gt 100000 ]; then
  echo "❌ ERROR: Response is too large ($RESP_SIZE bytes) - likely circular reference issue!"
else
  echo "✅ Response size is normal"
  
  # Extract complaint ID
  COMPLAINT_ID=$(echo "$COMPLAINT_RESP" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
  if [ -n "$COMPLAINT_ID" ]; then
    echo "✅ Complaint created with ID: $COMPLAINT_ID"
  else
    echo "⚠️ Could not extract complaint ID from response"
  fi
fi

echo -e "\n3. Checking database..."
mysql -u root -p9491490888 -e "USE smartcity; SELECT COUNT(*) as total_complaints FROM complaints;" 2>/dev/null | tail -1
