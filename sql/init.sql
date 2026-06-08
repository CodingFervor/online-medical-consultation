CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY, username VARCHAR(50) UNIQUE NOT NULL, password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL, phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'patient' CHECK (role IN ('admin','doctor','patient')),
    status VARCHAR(20) DEFAULT 'active', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE departments (
    id BIGSERIAL PRIMARY KEY, name VARCHAR(50) NOT NULL, code VARCHAR(20) UNIQUE NOT NULL, icon VARCHAR(100)
);

CREATE TABLE doctors (
    id BIGSERIAL PRIMARY KEY, user_id BIGINT UNIQUE NOT NULL REFERENCES users(id),
    name VARCHAR(100) NOT NULL, title VARCHAR(30) DEFAULT 'attending',
    department_id BIGINT NOT NULL REFERENCES departments(id), specialty VARCHAR(100),
    hospital VARCHAR(200), rating DECIMAL(3,2) DEFAULT 5.00,
    consult_count INT DEFAULT 0, fee DECIMAL(10,2) DEFAULT 0,
    is_online BOOLEAN DEFAULT FALSE, bio TEXT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','inactive','suspended'))
);

CREATE TABLE patients (
    id BIGSERIAL PRIMARY KEY, user_id BIGINT UNIQUE NOT NULL REFERENCES users(id),
    name VARCHAR(100) NOT NULL, gender VARCHAR(10), age INT,
    phone VARCHAR(20), id_card VARCHAR(30), blood_type VARCHAR(5),
    allergies TEXT, medical_history TEXT
);

CREATE TABLE schedules (
    id BIGSERIAL PRIMARY KEY, doctor_id BIGINT NOT NULL REFERENCES doctors(id),
    date DATE NOT NULL, start_time TIME NOT NULL, end_time TIME NOT NULL,
    max_patients INT DEFAULT 20, booked INT DEFAULT 0,
    type VARCHAR(10) DEFAULT 'video' CHECK (type IN ('video','text'))
);

CREATE INDEX idx_schedules_doctor ON schedules(doctor_id, date);

CREATE TABLE appointments (
    id BIGSERIAL PRIMARY KEY, patient_id BIGINT NOT NULL REFERENCES patients(id),
    doctor_id BIGINT NOT NULL REFERENCES doctors(id), schedule_id BIGINT REFERENCES schedules(id),
    type VARCHAR(10) DEFAULT 'video' CHECK (type IN ('video','text')),
    symptom TEXT, status VARCHAR(20) DEFAULT 'booked' CHECK (status IN ('booked','cancelled','completed','no_show')),
    appointment_time TIMESTAMP, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);

CREATE TABLE consultations (
    id BIGSERIAL PRIMARY KEY, appointment_id BIGINT REFERENCES appointments(id),
    patient_id BIGINT NOT NULL, doctor_id BIGINT NOT NULL,
    type VARCHAR(10) DEFAULT 'video', status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','ended')),
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, end_time TIMESTAMP,
    duration_minutes INT DEFAULT 0, diagnosis TEXT, advice TEXT
);

CREATE TABLE consult_messages (
    id BIGSERIAL PRIMARY KEY, consultation_id BIGINT NOT NULL REFERENCES consultations(id),
    sender_type VARCHAR(10) NOT NULL CHECK (sender_type IN ('doctor','patient','system')),
    sender_id BIGINT NOT NULL, content TEXT NOT NULL,
    type VARCHAR(10) DEFAULT 'text' CHECK (type IN ('text','image','voice')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_messages_consultation ON consult_messages(consultation_id);

CREATE TABLE prescriptions (
    id BIGSERIAL PRIMARY KEY, consultation_id BIGINT NOT NULL REFERENCES consultations(id),
    patient_id BIGINT NOT NULL, doctor_id BIGINT NOT NULL,
    diagnosis TEXT, medicines JSONB DEFAULT '[]', notes TEXT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','dispensed','expired')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE health_records (
    id BIGSERIAL PRIMARY KEY, patient_id BIGINT NOT NULL, doctor_id BIGINT,
    type VARCHAR(20) DEFAULT 'examination' CHECK (type IN ('blood_test','imaging','examination','other')),
    title VARCHAR(200), content TEXT, attachment_url VARCHAR(500),
    record_date DATE DEFAULT CURRENT_DATE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_health_records_patient ON health_records(patient_id);

CREATE TABLE follow_ups (
    id BIGSERIAL PRIMARY KEY, consultation_id BIGINT NOT NULL REFERENCES consultations(id),
    patient_id BIGINT NOT NULL, doctor_id BIGINT NOT NULL,
    scheduled_date DATE NOT NULL, content TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending','completed','cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY, consultation_id BIGINT NOT NULL REFERENCES consultations(id),
    patient_id BIGINT NOT NULL, doctor_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5), comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY, appointment_id BIGINT NOT NULL REFERENCES appointments(id),
    patient_id BIGINT NOT NULL, doctor_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL, method VARCHAR(20) DEFAULT 'wechat',
    status VARCHAR(20) DEFAULT 'paid' CHECK (status IN ('pending','paid','refunded')),
    transaction_no VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, name, phone, role) VALUES
('admin', '$2a$10$dummyhash', 'Admin', '13800000000', 'admin');

INSERT INTO departments (name, code) VALUES
('Internal Medicine', 'IM'), ('Surgery', 'SUR'), ('Pediatrics', 'PED'),
('OB/GYN', 'OBG'), ('Ophthalmology', 'OPH'), ('Dermatology', 'DER');
