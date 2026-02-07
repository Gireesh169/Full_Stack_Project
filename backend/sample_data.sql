-- Smart City Database - Sample Data
-- Run this AFTER the application has created the tables

USE smart_city_db;

-- Sample Emergency Services
INSERT INTO emergency_services (service_name, contact_number, description) VALUES
('Fire Department', '911', 'Emergency fire and rescue services'),
('Police Department', '911', 'Emergency police services'),
('Ambulance', '911', 'Emergency medical services'),
('Hospital Emergency', '(555) 100-1000', '24/7 emergency medical care'),
('City Helpline', '311', 'General city services and information'),
('Disaster Management', '(555) 200-2000', 'Natural disaster and emergency response');

-- Sample City Services
INSERT INTO city_services (name, description, department) VALUES
('Waste Management', 'Weekly garbage collection and recycling services. Collection days: Monday and Thursday', 'Sanitation Department'),
('Water Supply', '24/7 water supply and maintenance services', 'Water Department'),
('Street Maintenance', 'Road repair and street cleaning services', 'Public Works'),
('Public Transport', 'City bus services covering all major routes', 'Transportation'),
('Building Permits', 'Construction and renovation permit services', 'Development Authority'),
('Parks & Recreation', 'Maintenance of public parks and recreational facilities', 'Parks Department');

-- Sample City News (You can add these after creating an admin user)
-- INSERT INTO city_news (title, content, image_url, created_at) VALUES
-- ('New Community Center Opening', 'A new state-of-the-art community center will open next month with modern facilities including a gym, library, and meeting spaces.', 'https://example.com/community-center.jpg', NOW()),
-- ('Road Construction Alert', 'Main Street will undergo repairs from next week. Alternative routes are suggested during construction period.', null, NOW()),
-- ('Free Health Camp', 'Free health checkup camp organized by City Health Department on Sunday at Central Park from 9 AM to 5 PM.', 'https://example.com/health-camp.jpg', NOW());

-- Sample Admin User (password: admin123 - BCrypt encoded)
-- You should create this via the API signup endpoint instead
-- INSERT INTO users (name, email, password, role, phone, address) VALUES
-- ('Admin User', 'admin@smartcity.com', '$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'ADMIN', '9876543210', 'City Hall');

-- Sample Citizen User (password: citizen123 - BCrypt encoded)  
-- You should create this via the API signup endpoint instead
-- INSERT INTO users (name, email, password, role, phone, address) VALUES
-- ('John Citizen', 'citizen@example.com', '$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'CITIZEN', '1234567890', '123 Main Street');

-- Sample Complaints (Create these via API after creating users)
-- INSERT INTO complaints (title, description, category, status, created_at, updated_at, user_id) VALUES
-- ('Street Light Not Working', 'The street light on Main Street corner has been out for 3 days', 'Infrastructure', 'PENDING', NOW(), NOW(), 2),
-- ('Garbage Not Collected', 'Garbage has not been collected in our area for the past 2 weeks', 'Sanitation', 'PENDING', NOW(), NOW(), 2);

-- Verify data insertion
SELECT 'Emergency Services:', COUNT(*) FROM emergency_services;
SELECT 'City Services:', COUNT(*) FROM city_services;
-- SELECT 'City News:', COUNT(*) FROM city_news;
-- SELECT 'Users:', COUNT(*) FROM users;
-- SELECT 'Complaints:', COUNT(*) FROM complaints;

SELECT '✅ Sample data inserted successfully!' AS message;
