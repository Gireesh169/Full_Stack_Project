# Smart City Full Stack - Running Backend & Frontend Separately

## 📁 Project Structure

```
Full_Stack_Project-main/
├── backend/                 # Spring Boot API Server (Port 8080)
├── src/                     # React Frontend (Port 5173)
└── START_SERVERS.md         # This file
```

---

## 🚀 Quick Start Guide

### Option 1: Using VS Code Split Terminal (Recommended)

1. **Open VS Code**
   - Open the main project folder: `/Users/apple/Downloads/Full_Stack_Project-main`

2. **Open Terminal 1 (Backend)**

   ```bash
   # In VS Code Terminal
   cd backend
   export JAVA_HOME=$(/usr/libexec/java_home -v 17)
   java -jar target/smart-city-backend-1.0.0.jar
   ```

   - ✅ Backend will start on: **http://localhost:8080**
   - ✅ API endpoints available at: **http://localhost:8080/api**

3. **Open Terminal 2 (Frontend)**
   - Click "+" icon next to terminal to create new terminal
   ```bash
   # Keep in main project folder
   npm run dev
   ```

   - ✅ Frontend will start on: **http://localhost:5173** or **http://localhost:5174** (if 5173 is in use)

---

## 📋 Terminal Commands Reference

### Backend (Terminal 1)

```bash
# Navigate to backend folder
cd /Users/apple/Downloads/Full_Stack_Project-main/backend

# Set Java 17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Run the server
java -jar target/smart-city-backend-1.0.0.jar

# Expected output:
# Started SmartCityApplication in X seconds
# Tomcat started on port 8080 (http)
```

### Frontend (Terminal 2)

```bash
# Navigate to main project folder
cd /Users/apple/Downloads/Full_Stack_Project-main

# Install dependencies (first time only)
npm install

# Start development server
npm run dev

# Expected output:
# Local: http://localhost:5173 (or 5174)
# Network: use --host to expose
```

---

## 🔗 API Endpoints

- **Base URL**: `http://localhost:8080/api`
- **Auth Signup**: `POST /auth/signup`
- **Auth Login**: `POST /auth/login`
- **Complaints**: `GET/POST /complaints`
- **News**: `GET/POST /news`
- **Emergency Services**: `GET /emergency-services`
- **City Services**: `GET /city-services`

---

## ✅ Verification Checklist

- [ ] Backend running on port 8080
- [ ] Frontend running on port 5173 or 5174
- [ ] Can access login page at frontend URL
- [ ] Can create new account
- [ ] Can login and see dashboard
- [ ] Backend logs show API requests

---

## 🐛 Troubleshooting

### Backend won't start

```bash
# Check if port 8080 is in use
lsof -i :8080

# If port is in use, kill the process
kill -9 <PID>

# Or change the port in application.properties
nano backend/src/main/resources/application.properties
# Change: server.port=8080
```

### Frontend won't start

```bash
# Check if node_modules exists
ls node_modules

# If not, install dependencies
npm install

# Clear npm cache and try again
npm cache clean --force
npm install
npm run dev
```

### Database connection error

- Ensure MySQL is running
- Check database credentials in `backend/src/main/resources/application.properties`

---

## 💡 Pro Tips

- Keep both terminals visible side-by-side for easier debugging
- Backend logs show API requests - useful for debugging
- Frontend console (F12) shows client-side errors
- Use Ctrl+C to stop any server

---

## 📞 Need Help?

Check the server logs in both terminals for error messages. They usually indicate what's wrong!
