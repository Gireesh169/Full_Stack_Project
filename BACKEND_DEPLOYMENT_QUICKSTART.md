# Backend Deployment Checklist & Quick Start Guide

## 🚀 Quick Start - Choose Your Deployment Method

### Option 1: Docker (Recommended for Local Development)

```bash
# Navigate to backend folder
cd backend

# Build Docker image
docker build -t smart-city-backend:1.0.0 .

# Run with MySQL
docker run -d \
  --name smart-city-api \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://host.docker.internal:3306/smart_city_db \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=root \
  smart-city-backend:1.0.0
```

### Option 2: Docker Compose (Full Stack)

```bash
# Run from project root
cd /Users/apple/Desktop/Full_Stack_Project-main

# Start all services (MySQL, Backend, Frontend)
docker-compose up -d

# View logs
docker-compose logs -f backend
```

### Option 3: Railway.app (Cloud Deployment)

1. **Connect Repository**
   - Go to railway.app/dashboard
   - Click "New Project" → "Deploy from GitHub"
   - Select `Full_Stack_Project` repository
   - Select backend folder as root

2. **Add MySQL Service**
   - Click "New Service" → "MySQL"
   - Railway creates database automatically

3. **Set Environment Variables**
   - Go to Variables tab
   - Add from `.env.example`:
     ```
     SPRING_DATASOURCE_URL=mysql://root:password@host:port/smart_city_db
     SPRING_DATASOURCE_USERNAME=root
     SPRING_DATASOURCE_PASSWORD=your_password
     ```

4. **Deploy**
   - Push to main branch
   - Railway auto-deploys
   - Get public URL from Railway dashboard

### Option 4: Heroku

```bash
# Login
heroku login

# Create app
heroku create your-app-name

# Add MySQL addon
heroku addons:create cleardb:ignite

# Set environment variables
heroku config:set \
  SPRING_DATASOURCE_URL=mysql://user:pass@host/db \
  SPRING_DATASOURCE_USERNAME=user \
  SPRING_DATASOURCE_PASSWORD=pass

# Deploy
git push heroku main
```

---

## ✅ Pre-Deployment Checklist

- [ ] Maven build successful: `mvn clean package`
- [ ] All tests pass: `mvn test`
- [ ] Docker image builds: `docker build -t smart-city-backend .`
- [ ] Environment variables configured
- [ ] Database created and accessible
- [ ] Backend runs locally: `java -jar target/smart-city-backend-1.0.0.jar`
- [ ] API endpoints responding (test with curl or Postman)
- [ ] CORS configured for frontend URL
- [ ] Database backups created
- [ ] Application logs reviewed

---

## 📋 Configuration Checklist

### Database Setup

```sql
-- Create database
CREATE DATABASE smart_city_db;

-- Create user (if needed)
CREATE USER 'smartcity'@'%' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON smart_city_db.* TO 'smartcity'@'%';
FLUSH PRIVILEGES;
```

### Environment Variables Required

```
SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/smart_city_db
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=root
PORT=8080
```

### Optional Configuration

```
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_JPA_SHOW_SQL=false
LOGGING_LEVEL_COM_SMARTCITY=DEBUG
```

---

## 🔍 Testing Deployment

### Check if Backend is Running

```bash
# Test API endpoint
curl http://localhost:8080/api/auth/health

# Expected response:
# {"status":"UP"}
```

### View Docker Logs

```bash
docker logs -f smart-city-api
```

### View Docker Compose Logs

```bash
docker-compose logs -f backend
```

### Test with Postman

- Import: `backend/Smart_City_API.postman_collection.json`
- Test endpoints with sample data
- Verify responses

---

## 🌐 Frontend Integration

After backend deployment, update frontend:

### File: `frontend/src/api.js`

```javascript
// Local development
const API_BASE_URL = process.env.VITE_API_URL || "http://localhost:8080/api";

// Production (Railway/Heroku)
// const API_BASE_URL = 'https://your-deployed-backend-url/api';
```

### File: `frontend/.env.production`

```
VITE_API_URL=https://your-railway-url/api
```

---

## 📊 Monitoring & Logs

### Docker Monitoring

```bash
# View container status
docker ps

# View logs
docker logs smart-city-api

# Tail logs (live)
docker logs -f smart-city-api

# View resource usage
docker stats smart-city-api
```

### Railway Monitoring

- Logs: Dashboard → Logs tab
- Metrics: Dashboard → Metrics tab
- Deployments: View deployment history

### Performance Checks

```bash
# Check response time
time curl http://localhost:8080/api/auth/health

# Load testing (if needed)
# Use: Apache JMeter, Locust, or k6
```

---

## 🔧 Troubleshooting

### Common Issues

**Port Already in Use**

```bash
# Find process using port 8080
lsof -i :8080

# Kill process
kill -9 <PID>
```

**Database Connection Failed**

- Check MySQL is running: `mysql -u root -p`
- Verify credentials in environment variables
- Check database exists: `SHOW DATABASES;`

**Docker Build Fails**

```bash
# Clean and rebuild
docker system prune -a
docker build --no-cache -t smart-city-backend:1.0.0 .
```

**Container Crashes**

```bash
# Check logs
docker logs smart-city-api

# Verify environment variables
docker inspect smart-city-api | grep -A 20 "Env"
```

**CORS Issues**

- Update `SecurityConfig.java` with frontend URL
- Ensure `@CrossOrigin` annotations are correct

---

## 📞 Support Resources

- **Postman Collection**: `backend/Smart_City_API.postman_collection.json`
- **API Documentation**: Check controller comments
- **Setup Guide**: `backend/COMPLETE_SETUP_GUIDE.md`
- **Docker Docs**: https://docs.docker.com
- **Railway Docs**: https://docs.railway.app
- **Spring Boot Docs**: https://spring.io/projects/spring-boot

---

## 🎯 Success Indicators

✅ Backend deployment is successful when:

- API responds to health check endpoint
- Database operations work correctly
- Frontend can communicate with backend
- No 500 errors in logs
- Response times are acceptable (<500ms)
- All endpoints return expected data

---

## Next Steps

1. Choose deployment method (Docker/Railway/Heroku)
2. Follow the quick start for your choice
3. Test API with Postman collection
4. Update frontend API endpoint
5. Deploy frontend
6. Monitor application health

Good luck with your deployment! 🚀
