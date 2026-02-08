# Smart City Backend - Deployment Guide

This guide covers deploying the backend to various platforms.

## Table of Contents

- [Railway.app](#railwayapp-deployment)
- [Docker](#docker-deployment)
- [Heroku](#heroku-deployment)
- [Environment Variables](#environment-variables)

---

## Railway.app Deployment

### Prerequisites

- Railway.app account (https://railway.app)
- GitHub repository connected to Railway
- MySQL database (Railway provides MySQL service)

### Steps

1. **Connect Repository**
   - Go to railway.app/dashboard
   - Click "New Project"
   - Select "Deploy from GitHub Repo"
   - Select your `Full_Stack_Project` repository
   - Select the `backend` folder as the root directory

2. **Add MySQL Database**
   - In Railway dashboard, click "New Service"
   - Select "MySQL"
   - Railway will create a database automatically

3. **Configure Environment Variables**

   In Railway, go to "Variables" and set:

   ```
   SPRING_DATASOURCE_URL=mysql://root:password@host:port/smart_city_db
   SPRING_DATASOURCE_USERNAME=root
   SPRING_DATASOURCE_PASSWORD=your_password
   PORT=8080
   ```

4. **Deploy**
   - Railway automatically deploys on each push to main
   - Monitor logs in the Railway dashboard

### Get Your Backend URL

- After deployment, Railway assigns a public URL
- Share this URL with your frontend team
- Update frontend API endpoint in `frontend/src/api.js`

---

## Docker Deployment

### Local Docker Testing

```bash
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

### Docker Compose Setup

Create `docker-compose.yml`:

```yaml
version: "3.8"

services:
  mysql:
    image: mysql:8.0
    container_name: smart-city-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: smart_city_db
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  backend:
    build: ./backend
    container_name: smart-city-api
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/smart_city_db
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root
    depends_on:
      - mysql

volumes:
  mysql_data:
```

Run with:

```bash
docker-compose up -d
```

---

## Heroku Deployment

### Prerequisites

- Heroku CLI installed
- Heroku account

### Steps

1. **Login to Heroku**

   ```bash
   heroku login
   heroku create your-app-name
   ```

2. **Add MySQL Add-on**

   ```bash
   heroku addons:create cleardb:ignite
   ```

3. **Set Environment Variables**

   ```bash
   heroku config:set \
     SPRING_DATASOURCE_URL=mysql://user:pass@host/db \
     SPRING_DATASOURCE_USERNAME=user \
     SPRING_DATASOURCE_PASSWORD=pass
   ```

4. **Create Procfile** in backend folder:

   ```
   web: java -jar target/smart-city-backend-1.0.0.jar -Dserver.port=$PORT
   ```

5. **Deploy**
   ```bash
   git push heroku main
   ```

---

## Environment Variables

### Required Variables

| Variable                     | Description             | Example                                |
| ---------------------------- | ----------------------- | -------------------------------------- |
| `SPRING_DATASOURCE_URL`      | Database connection URL | `mysql://localhost:3306/smart_city_db` |
| `SPRING_DATASOURCE_USERNAME` | Database user           | `root`                                 |
| `SPRING_DATASOURCE_PASSWORD` | Database password       | `secure_password`                      |
| `PORT`                       | Server port             | `8080`                                 |

### Optional Variables

| Variable                        | Description            | Default  |
| ------------------------------- | ---------------------- | -------- |
| `spring.jpa.hibernate.ddl-auto` | Hibernate DDL strategy | `update` |
| `spring.jpa.show-sql`           | Show SQL logs          | `false`  |

---

## Frontend Integration

After deploying backend, update `frontend/src/api.js`:

```javascript
const API_BASE_URL =
  process.env.REACT_APP_API_URL || "http://localhost:8080/api";
```

Set environment variable in frontend:

```
REACT_APP_API_URL=https://your-deployed-backend-url/api
```

---

## Troubleshooting

### 502 Bad Gateway

- Check database connection
- Verify environment variables are set correctly
- Check application logs

### Connection Refused

- Ensure database is accessible
- Verify database credentials
- Check firewall rules

### Slow Response

- Check database query performance
- Monitor server resources
- Review application logs

---

## Monitoring

### Railway Monitoring

- Check "Metrics" tab for CPU, memory usage
- Monitor "Logs" for errors
- Set up alerts for deployment failures

### Docker Logs

```bash
docker logs smart-city-api
```

### Heroku Logs

```bash
heroku logs --tail
```

---

## Next Steps

1. ✅ Deploy backend to Railway/Docker/Heroku
2. ✅ Configure database
3. ✅ Update frontend API endpoint
4. ✅ Test API endpoints with Postman
5. ✅ Deploy frontend
6. ✅ Monitor application

For more help, check the backend README or contact the development team.
