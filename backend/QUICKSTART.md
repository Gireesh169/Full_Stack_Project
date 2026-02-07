# Smart City Backend - Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

### Step 1: Prerequisites Check

```bash
# Check Java version (must be 17+)
java -version

# Check Maven
mvn -version

# Check MySQL
mysql --version
```

### Step 2: Database Setup

```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE smart_city_db;
exit;
```

### Step 3: Configure Application

```bash
cd backend

# Edit application.properties if your MySQL password is different
# File: src/main/resources/application.properties
# Change: spring.datasource.password=YOUR_PASSWORD
```

### Step 4: Build & Run

```bash
# Build the project
mvn clean install

# Run the application
mvn spring-boot:run
```

The API will be available at: **http://localhost:8080**

---

## 🧪 Testing the API

### Option 1: Using Postman

1. Import `Smart_City_API.postman_collection.json` into Postman
2. Set the `base_url` variable to `http://localhost:8080`
3. Start with Authentication → Signup to create users

### Option 2: Using cURL

#### 1. Create an Admin User

```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Admin User",
    "email": "admin@example.com",
    "password": "admin123",
    "role": "ADMIN",
    "phone": "9876543210",
    "address": "Admin Office"
  }'
```

#### 2. Create a Citizen User

```bash
curl -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Citizen",
    "email": "citizen@example.com",
    "password": "password123",
    "role": "CITIZEN",
    "phone": "1234567890",
    "address": "123 Main St"
  }'
```

#### 3. Login

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "admin123"
  }'
```

Save the JWT token from the response!

#### 4. Create a Complaint (Citizen)

```bash
curl -X POST "http://localhost:8080/api/complaints?userId=2" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Street Light Not Working",
    "description": "The street light on Main Street has been out for 3 days",
    "category": "Infrastructure"
  }'
```

#### 5. Get All Complaints (Admin)

```bash
curl -X GET http://localhost:8080/api/complaints \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

#### 6. Update Complaint Status (Admin)

```bash
curl -X PUT http://localhost:8080/api/complaints/1/status \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "IN_PROGRESS"
  }'
```

---

## 📊 Database Tables Created

The application automatically creates these tables:

- `users` - User accounts (Admin/Citizen)
- `complaints` - Citizen complaints
- `city_news` - News articles
- `emergency_services` - Emergency contacts
- `city_services` - City service information
- `notifications` - User notifications

You can view them:

```sql
USE smart_city_db;
SHOW TABLES;
```

---

## 🔑 Default Test Accounts

After signup, use these for testing:

**Admin Account:**

- Email: `admin@example.com`
- Password: `admin123`
- Can: Add news, services, update complaints

**Citizen Account:**

- Email: `citizen@example.com`
- Password: `password123`
- Can: Submit complaints, view own complaints

---

## 🔗 Connecting Frontend

Update your React frontend API base URL to:

```javascript
const API_BASE_URL = "http://localhost:8080/api";
```

Store JWT token after login:

```javascript
localStorage.setItem("token", response.data.token);
```

Add token to requests:

```javascript
axios.get(`${API_BASE_URL}/complaints`, {
  headers: {
    Authorization: `Bearer ${token}`,
  },
});
```

---

## ❓ Troubleshooting

### Port 8080 already in use?

Change in `application.properties`:

```properties
server.port=8081
```

### MySQL Connection Failed?

- Check MySQL is running: `sudo service mysql status`
- Verify credentials in `application.properties`
- Check database exists: `SHOW DATABASES;`

### JWT Token Expired?

- Token expires in 24 hours by default
- Login again to get a new token

### CORS Issues?

Add your frontend URL in `application.properties`:

```properties
cors.allowed.origins=http://localhost:5173,http://localhost:3000,YOUR_URL
```

---

## 📚 API Documentation

Complete API documentation available in `README.md`

## 🎯 Next Steps

1. ✅ Create Admin and Citizen users
2. ✅ Add some test data (news, services)
3. ✅ Submit test complaints
4. ✅ Connect your React frontend
5. ✅ Test the complete flow

---

## 🆘 Need Help?

Check the main `README.md` for:

- Complete API endpoint list
- Detailed request/response examples
- Security configuration
- Production deployment tips
