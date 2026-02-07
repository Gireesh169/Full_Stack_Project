# Smart City Backend API

## Overview

Complete Spring Boot REST API backend for Smart City Services application with JWT authentication and role-based access control.

## Tech Stack

- **Java 17+**
- **Spring Boot 3.2.2**
- **Spring Data JPA**
- **Spring Security + JWT**
- **MySQL 8.0+**
- **Maven**
- **Lombok**

## Database Configuration

Database Name: `smart_city_db`

Update the following in `application.properties` if needed:

```properties
spring.datasource.username=root
spring.datasource.password=root
```

## Prerequisites

1. Java 17 or higher
2. Maven 3.6+
3. MySQL 8.0+
4. MySQL running on localhost:3306

## Setup Instructions

### 1. Create MySQL Database

```sql
CREATE DATABASE smart_city_db;
```

### 2. Configure Application

Update `src/main/resources/application.properties` with your MySQL credentials if different from defaults.

### 3. Build the Project

```bash
cd backend
mvn clean install
```

### 4. Run the Application

```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## Project Structure

```
backend/
├── src/main/java/com/smartcity/
│   ├── SmartCityApplication.java (Main class)
│   ├── config/
│   │   └── SecurityConfig.java
│   ├── controller/
│   │   ├── AuthController.java
│   │   ├── UserController.java
│   │   ├── ComplaintController.java
│   │   ├── CityNewsController.java
│   │   ├── EmergencyServiceController.java
│   │   ├── CityServiceController.java
│   │   └── NotificationController.java
│   ├── dto/
│   │   ├── LoginRequest.java
│   │   ├── SignupRequest.java
│   │   ├── JwtResponse.java
│   │   └── MessageResponse.java
│   ├── entity/
│   │   ├── User.java
│   │   ├── Complaint.java
│   │   ├── CityNews.java
│   │   ├── EmergencyService.java
│   │   ├── CityService.java
│   │   └── Notification.java
│   ├── repository/
│   │   ├── UserRepository.java
│   │   ├── ComplaintRepository.java
│   │   ├── CityNewsRepository.java
│   │   ├── EmergencyServiceRepository.java
│   │   ├── CityServiceRepository.java
│   │   └── NotificationRepository.java
│   ├── security/
│   │   ├── JwtUtils.java
│   │   ├── UserDetailsImpl.java
│   │   ├── UserDetailsServiceImpl.java
│   │   ├── AuthTokenFilter.java
│   │   └── AuthEntryPointJwt.java
│   └── service/
│       ├── AuthService.java
│       ├── UserService.java
│       ├── ComplaintService.java
│       ├── CityNewsService.java
│       ├── EmergencyServiceService.java
│       ├── CityServiceService.java
│       └── NotificationService.java
└── pom.xml
```

## API Endpoints

### Authentication

| Method | Endpoint           | Description       | Access |
| ------ | ------------------ | ----------------- | ------ |
| POST   | `/api/auth/signup` | Register new user | Public |
| POST   | `/api/auth/login`  | Login and get JWT | Public |

### Users

| Method | Endpoint          | Description    | Access     |
| ------ | ----------------- | -------------- | ---------- |
| GET    | `/api/users`      | Get all users  | Admin      |
| GET    | `/api/users/{id}` | Get user by ID | Admin/Self |

### Complaints

| Method | Endpoint                        | Description             | Access        |
| ------ | ------------------------------- | ----------------------- | ------------- |
| POST   | `/api/complaints`               | Create complaint        | Citizen       |
| GET    | `/api/complaints`               | Get all complaints      | Admin         |
| GET    | `/api/complaints/user/{userId}` | Get complaints by user  | Citizen/Admin |
| PUT    | `/api/complaints/{id}/status`   | Update complaint status | Admin         |

### City News

| Method | Endpoint         | Description    | Access |
| ------ | ---------------- | -------------- | ------ |
| POST   | `/api/news`      | Create news    | Admin  |
| GET    | `/api/news`      | Get all news   | Public |
| GET    | `/api/news/{id}` | Get news by ID | Public |
| DELETE | `/api/news/{id}` | Delete news    | Admin  |

### Emergency Services

| Method | Endpoint                       | Description      | Access |
| ------ | ------------------------------ | ---------------- | ------ |
| POST   | `/api/emergency-services`      | Add service      | Admin  |
| GET    | `/api/emergency-services`      | Get all services | Public |
| DELETE | `/api/emergency-services/{id}` | Delete service   | Admin  |

### City Services

| Method | Endpoint                  | Description      | Access |
| ------ | ------------------------- | ---------------- | ------ |
| POST   | `/api/city-services`      | Add service      | Admin  |
| GET    | `/api/city-services`      | Get all services | Public |
| DELETE | `/api/city-services/{id}` | Delete service   | Admin  |

### Notifications

| Method | Endpoint                           | Description            | Access        |
| ------ | ---------------------------------- | ---------------------- | ------------- |
| POST   | `/api/notifications/{userId}`      | Send notification      | Admin         |
| GET    | `/api/notifications/user/{userId}` | Get user notifications | Citizen/Admin |

## Request Examples

### 1. Signup

```bash
POST http://localhost:8080/api/auth/signup
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "CITIZEN",
  "phone": "1234567890",
  "address": "123 Main St"
}
```

### 2. Login

```bash
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

Response:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "role": "CITIZEN"
}
```

### 3. Create Complaint (Requires JWT)

```bash
POST http://localhost:8080/api/complaints?userId=1
Authorization: Bearer <your-jwt-token>
Content-Type: application/json

{
  "title": "Street Light Issue",
  "description": "Street light not working on Main St",
  "category": "Infrastructure"
}
```

### 4. Update Complaint Status (Admin)

```bash
PUT http://localhost:8080/api/complaints/1/status
Authorization: Bearer <admin-jwt-token>
Content-Type: application/json

{
  "status": "IN_PROGRESS"
}
```

## User Roles

- **ADMIN**: Can manage all resources, update complaint status, add news/services
- **CITIZEN**: Can submit complaints, view their own complaints, view public content

## Security

- JWT-based authentication
- Role-based access control (RBAC)
- Password encryption using BCrypt
- CORS enabled for frontend integration
- Stateless session management

## CORS Configuration

Default allowed origins:

- `http://localhost:5173` (Vite)
- `http://localhost:3000` (React)

Update in `application.properties` if needed.

## Testing the API

You can test the API using:

- **Postman**
- **cURL**
- **Thunder Client** (VS Code Extension)
- **Your React Frontend**

## Troubleshooting

### MySQL Connection Issues

- Ensure MySQL is running
- Verify database credentials in `application.properties`
- Check if port 3306 is available

### Port Already in Use

Change the port in `application.properties`:

```properties
server.port=8081
```

### JWT Errors

- Ensure proper Authorization header format: `Bearer <token>`
- Check token expiration (default: 24 hours)

## Development

- Hot reload enabled with Spring DevTools
- SQL queries logged in console (set to DEBUG level)
- Hibernate auto-creates tables on startup

## Production Recommendations

1. Change JWT secret key in `application.properties`
2. Set `spring.jpa.hibernate.ddl-auto=validate`
3. Use environment variables for sensitive data
4. Enable HTTPS
5. Add rate limiting
6. Implement proper logging and monitoring

## License

MIT License
