# React Frontend Integration Guide

## 🔗 Connecting Your React Frontend to Spring Boot Backend

This guide shows how to integrate the Spring Boot backend with your existing React Smart City frontend.

---

## 📋 Prerequisites

1. Backend running on `http://localhost:8080`
2. React frontend running (typically on `http://localhost:5173` for Vite)
3. Axios installed in frontend: `npm install axios`

---

## 🛠️ Step 1: Create API Configuration

Create a new file: `src/config/api.js`

```javascript
import axios from "axios";

// Base API URL
export const API_BASE_URL = "http://localhost:8080/api";

// Create axios instance
const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

// Request interceptor to add JWT token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  },
);

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - redirect to login
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      window.location.href = "/login";
    }
    return Promise.reject(error);
  },
);

export default api;
```

---

## 🔐 Step 2: Create Authentication Service

Create: `src/services/authService.js`

```javascript
import api from "../config/api";

export const authService = {
  // Sign up new user
  signup: async (userData) => {
    const response = await api.post("/auth/signup", userData);
    return response.data;
  },

  // Login user
  login: async (credentials) => {
    const response = await api.post("/auth/login", credentials);
    if (response.data.token) {
      localStorage.setItem("token", response.data.token);
      localStorage.setItem(
        "user",
        JSON.stringify({
          id: response.data.id,
          name: response.data.name,
          email: response.data.email,
          role: response.data.role,
        }),
      );
    }
    return response.data;
  },

  // Logout user
  logout: () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
  },

  // Get current user
  getCurrentUser: () => {
    const user = localStorage.getItem("user");
    return user ? JSON.parse(user) : null;
  },

  // Check if user is authenticated
  isAuthenticated: () => {
    return !!localStorage.getItem("token");
  },

  // Check if user is admin
  isAdmin: () => {
    const user = authService.getCurrentUser();
    return user?.role === "ADMIN";
  },
};
```

---

## 📡 Step 3: Create API Services for Each Module

### Complaints Service

Create: `src/services/complaintService.js`

```javascript
import api from "../config/api";

export const complaintService = {
  // Create new complaint
  createComplaint: async (complaint, userId) => {
    const response = await api.post(`/complaints?userId=${userId}`, complaint);
    return response.data;
  },

  // Get all complaints (Admin only)
  getAllComplaints: async () => {
    const response = await api.get("/complaints");
    return response.data;
  },

  // Get complaints by user ID
  getUserComplaints: async (userId) => {
    const response = await api.get(`/complaints/user/${userId}`);
    return response.data;
  },

  // Get single complaint
  getComplaintById: async (id) => {
    const response = await api.get(`/complaints/${id}`);
    return response.data;
  },

  // Update complaint status (Admin only)
  updateComplaintStatus: async (id, status) => {
    const response = await api.put(`/complaints/${id}/status`, { status });
    return response.data;
  },
};
```

### City News Service

Create: `src/services/newsService.js`

```javascript
import api from "../config/api";

export const newsService = {
  // Get all news
  getAllNews: async () => {
    const response = await api.get("/news");
    return response.data;
  },

  // Get single news
  getNewsById: async (id) => {
    const response = await api.get(`/news/${id}`);
    return response.data;
  },

  // Create news (Admin only)
  createNews: async (newsData) => {
    const response = await api.post("/news", newsData);
    return response.data;
  },

  // Delete news (Admin only)
  deleteNews: async (id) => {
    const response = await api.delete(`/news/${id}`);
    return response.data;
  },
};
```

### Emergency Services Service

Create: `src/services/emergencyService.js`

```javascript
import api from "../config/api";

export const emergencyService = {
  // Get all emergency services
  getAllServices: async () => {
    const response = await api.get("/emergency-services");
    return response.data;
  },

  // Create emergency service (Admin only)
  createService: async (serviceData) => {
    const response = await api.post("/emergency-services", serviceData);
    return response.data;
  },

  // Delete emergency service (Admin only)
  deleteService: async (id) => {
    const response = await api.delete(`/emergency-services/${id}`);
    return response.data;
  },
};
```

### City Services Service

Create: `src/services/cityService.js`

```javascript
import api from "../config/api";

export const cityService = {
  // Get all city services
  getAllServices: async () => {
    const response = await api.get("/city-services");
    return response.data;
  },

  // Create city service (Admin only)
  createService: async (serviceData) => {
    const response = await api.post("/city-services", serviceData);
    return response.data;
  },

  // Delete city service (Admin only)
  deleteService: async (id) => {
    const response = await api.delete(`/city-services/${id}`);
    return response.data;
  },
};
```

### Notifications Service

Create: `src/services/notificationService.js`

```javascript
import api from "../config/api";

export const notificationService = {
  // Get user notifications
  getUserNotifications: async (userId) => {
    const response = await api.get(`/notifications/user/${userId}`);
    return response.data;
  },

  // Send notification (Admin only)
  sendNotification: async (userId, message) => {
    const response = await api.post(`/notifications/${userId}`, { message });
    return response.data;
  },
};
```

---

## 🔄 Step 4: Update Your React Components

### Update Login Component

```javascript
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { authService } from "../services/authService";

function Login() {
  const [credentials, setCredentials] = useState({
    email: "",
    password: "",
  });
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await authService.login(credentials);

      // Redirect based on role
      if (response.role === "ADMIN") {
        navigate("/admin-dashboard");
      } else {
        navigate("/citizen-dashboard");
      }
    } catch (err) {
      setError(err.response?.data?.message || "Login failed");
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {error && <div className="error">{error}</div>}

      <input
        type="email"
        placeholder="Email"
        value={credentials.email}
        onChange={(e) =>
          setCredentials({ ...credentials, email: e.target.value })
        }
        required
      />

      <input
        type="password"
        placeholder="Password"
        value={credentials.password}
        onChange={(e) =>
          setCredentials({ ...credentials, password: e.target.value })
        }
        required
      />

      <button type="submit">Login</button>
    </form>
  );
}

export default Login;
```

### Update Signup Component

```javascript
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { authService } from "../services/authService";

function Signup() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    role: "CITIZEN",
    phone: "",
    address: "",
  });
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await authService.signup(formData);
      alert("Registration successful! Please login.");
      navigate("/login");
    } catch (err) {
      setError(err.response?.data?.message || "Signup failed");
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {error && <div className="error">{error}</div>}

      <input
        type="text"
        placeholder="Full Name"
        value={formData.name}
        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
        required
      />

      <input
        type="email"
        placeholder="Email"
        value={formData.email}
        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
        required
      />

      <input
        type="password"
        placeholder="Password"
        value={formData.password}
        onChange={(e) => setFormData({ ...formData, password: e.target.value })}
        required
      />

      <input
        type="tel"
        placeholder="Phone"
        value={formData.phone}
        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
      />

      <textarea
        placeholder="Address"
        value={formData.address}
        onChange={(e) => setFormData({ ...formData, address: e.target.value })}
      />

      <select
        value={formData.role}
        onChange={(e) => setFormData({ ...formData, role: e.target.value })}
      >
        <option value="CITIZEN">Citizen</option>
        <option value="ADMIN">Admin</option>
      </select>

      <button type="submit">Sign Up</button>
    </form>
  );
}

export default Signup;
```

### Update Report Form Component

```javascript
import { useState } from "react";
import { complaintService } from "../services/complaintService";
import { authService } from "../services/authService";

function ReportForm() {
  const [complaint, setComplaint] = useState({
    title: "",
    description: "",
    category: "",
  });
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const user = authService.getCurrentUser();
      await complaintService.createComplaint(complaint, user.id);
      setSuccess(true);
      setComplaint({ title: "", description: "", category: "" });

      setTimeout(() => setSuccess(false), 3000);
    } catch (error) {
      alert("Failed to submit complaint");
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {success && (
        <div className="success">Complaint submitted successfully!</div>
      )}

      <input
        type="text"
        placeholder="Title"
        value={complaint.title}
        onChange={(e) => setComplaint({ ...complaint, title: e.target.value })}
        required
      />

      <textarea
        placeholder="Description"
        value={complaint.description}
        onChange={(e) =>
          setComplaint({ ...complaint, description: e.target.value })
        }
        required
      />

      <select
        value={complaint.category}
        onChange={(e) =>
          setComplaint({ ...complaint, category: e.target.value })
        }
        required
      >
        <option value="">Select Category</option>
        <option value="Infrastructure">Infrastructure</option>
        <option value="Sanitation">Sanitation</option>
        <option value="Water Supply">Water Supply</option>
        <option value="Electricity">Electricity</option>
        <option value="Other">Other</option>
      </select>

      <button type="submit">Submit Complaint</button>
    </form>
  );
}

export default ReportForm;
```

### Update City News Component

```javascript
import { useState, useEffect } from "react";
import { newsService } from "../services/newsService";

function CityNews() {
  const [news, setNews] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadNews();
  }, []);

  const loadNews = async () => {
    try {
      const data = await newsService.getAllNews();
      setNews(data);
    } catch (error) {
      console.error("Failed to load news:", error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading...</div>;

  return (
    <div className="news-container">
      <h2>City News</h2>
      {news.map((item) => (
        <div key={item.id} className="news-card">
          {item.imageUrl && <img src={item.imageUrl} alt={item.title} />}
          <h3>{item.title}</h3>
          <p>{item.content}</p>
          <small>{new Date(item.createdAt).toLocaleDateString()}</small>
        </div>
      ))}
    </div>
  );
}

export default CityNews;
```

---

## 🛡️ Step 5: Create Protected Route Component

Create: `src/components/ProtectedRoute.jsx`

```javascript
import { Navigate } from "react-router-dom";
import { authService } from "../services/authService";

function ProtectedRoute({ children, adminOnly = false }) {
  const isAuthenticated = authService.isAuthenticated();
  const isAdmin = authService.isAdmin();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (adminOnly && !isAdmin) {
    return <Navigate to="/citizen-dashboard" replace />;
  }

  return children;
}

export default ProtectedRoute;
```

---

## 🗺️ Step 6: Update App Routes

```javascript
import { BrowserRouter, Routes, Route } from "react-router-dom";
import ProtectedRoute from "./components/ProtectedRoute";
import Login from "./components/Login";
import Signup from "./components/Signup";
import CitizenDashboard from "./components/CitizenDashboard";
import AdminDashboard from "./components/AdminDashboard";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />

        <Route
          path="/citizen-dashboard"
          element={
            <ProtectedRoute>
              <CitizenDashboard />
            </ProtectedRoute>
          }
        />

        <Route
          path="/admin-dashboard"
          element={
            <ProtectedRoute adminOnly={true}>
              <AdminDashboard />
            </ProtectedRoute>
          }
        />

        {/* Add more routes */}
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```

---

## 📦 Step 7: Install Required Packages

```bash
npm install axios react-router-dom
```

---

## ✅ Testing Checklist

- [ ] Backend running on http://localhost:8080
- [ ] Frontend running on http://localhost:5173
- [ ] Can register new user
- [ ] Can login and receive JWT token
- [ ] Token is stored in localStorage
- [ ] Protected routes require authentication
- [ ] Can submit complaints
- [ ] Can view city news
- [ ] Admin can access admin dashboard
- [ ] Logout clears token and redirects to login

---

## 🐛 Common Issues & Solutions

### CORS Errors

**Issue:** "Access to XMLHttpRequest blocked by CORS policy"

**Solution:** Backend already has CORS configured for `http://localhost:5173`. If using different port, update `application.properties`:

```properties
cors.allowed.origins=http://localhost:YOUR_PORT
```

### 401 Unauthorized

**Issue:** Getting 401 on protected endpoints

**Solution:**

- Check token is being sent in Authorization header
- Token might be expired (24h validity)
- Login again to get fresh token

### Token Not Persisting

**Issue:** Token lost on page refresh

**Solution:** Ensure you're using `localStorage.setItem()` and `localStorage.getItem()`

---

## 🎉 You're All Set!

Your React frontend is now fully integrated with the Spring Boot backend. Start building amazing features!
