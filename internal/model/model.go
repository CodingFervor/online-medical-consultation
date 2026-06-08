package model

import "time"

type User struct {
	ID        int64     `json:"id" db:"id"`
	Username  string    `json:"username" db:"username"`
	Password  string    `json:"-" db:"password"`
	Name      string    `json:"name" db:"name"`
	Phone     string    `json:"phone" db:"phone"`
	Role      string    `json:"role" db:"role"` // admin, doctor, patient
	Status    string    `json:"status" db:"status"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

type Doctor struct {
	ID           int64   `json:"id" db:"id"`
	UserID       int64   `json:"user_id" db:"user_id"`
	Name         string  `json:"name" db:"name"`
	Title        string  `json:"title" db:"title"`       // attending, associate, chief
	DepartmentID int64   `json:"department_id" db:"department_id"`
	Specialty    string  `json:"specialty" db:"specialty"`
	Hospital     string  `json:"hospital" db:"hospital"`
	Rating       float64 `json:"rating" db:"rating"`
	ConsultCount int     `json:"consult_count" db:"consult_count"`
	Fee          float64 `json:"fee" db:"fee"`
	IsOnline     bool    `json:"is_online" db:"is_online"`
	Bio          string  `json:"bio" db:"bio"`
	Status       string  `json:"status" db:"status"`
}

type Patient struct {
	ID         int64   `json:"id" db:"id"`
	UserID     int64   `json:"user_id" db:"user_id"`
	Name       string  `json:"name" db:"name"`
	Gender     string  `json:"gender" db:"gender"`
	Age        int     `json:"age" db:"age"`
	Phone      string  `json:"phone" db:"phone"`
	IDCard     string  `json:"id_card" db:"id_card"`
	BloodType  string  `json:"blood_type" db:"blood_type"`
	Allergies  string  `json:"allergies" db:"allergies"`
	MedicalHistory string `json:"medical_history" db:"medical_history"`
}

type Department struct {
	ID   int64  `json:"id" db:"id"`
	Name string `json:"name" db:"name"`
	Code string `json:"code" db:"code"`
	Icon string `json:"icon" db:"icon"`
}

type Schedule struct {
	ID         int64     `json:"id" db:"id"`
	DoctorID   int64     `json:"doctor_id" db:"doctor_id"`
	Date       time.Time `json:"date" db:"date"`
	StartTime  string    `json:"start_time" db:"start_time"`
	EndTime    string    `json:"end_time" db:"end_time"`
	MaxPatients int      `json:"max_patients" db:"max_patients"`
	Booked     int       `json:"booked" db:"booked"`
	Type       string    `json:"type" db:"type"` // video, text
}

type Appointment struct {
	ID           int64     `json:"id" db:"id"`
	PatientID    int64     `json:"patient_id" db:"patient_id"`
	DoctorID     int64     `json:"doctor_id" db:"doctor_id"`
	ScheduleID   int64     `json:"schedule_id" db:"schedule_id"`
	Type         string    `json:"type" db:"type"` // video, text
	Symptom      string    `json:"symptom" db:"symptom"`
	Status       string    `json:"status" db:"status"` // booked, cancelled, completed, no_show
	AppointmentTime time.Time `json:"appointment_time" db:"appointment_time"`
	CreatedAt    time.Time `json:"created_at" db:"created_at"`
}

type Consultation struct {
	ID          int64     `json:"id" db:"id"`
	AppointmentID int64   `json:"appointment_id" db:"appointment_id"`
	PatientID   int64     `json:"patient_id" db:"patient_id"`
	DoctorID    int64     `json:"doctor_id" db:"doctor_id"`
	Type        string    `json:"type" db:"type"` // video, text
	Status      string    `json:"status" db:"status"` // active, ended
	StartTime   time.Time `json:"start_time" db:"start_time"`
	EndTime     *time.Time `json:"end_time" db:"end_time"`
	Duration    int       `json:"duration" db:"duration"` // minutes
	Diagnosis   string    `json:"diagnosis" db:"diagnosis"`
	Advice      string    `json:"advice" db:"advice"`
}

type ConsultMessage struct {
	ID             int64     `json:"id" db:"id"`
	ConsultationID int64     `json:"consultation_id" db:"consultation_id"`
	SenderType     string    `json:"sender_type" db:"sender_type"` // doctor, patient, system
	SenderID       int64     `json:"sender_id" db:"sender_id"`
	Content        string    `json:"content" db:"content"`
	Type           string    `json:"type" db:"type"` // text, image, voice
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}

type Prescription struct {
	ID             int64     `json:"id" db:"id"`
	ConsultationID int64     `json:"consultation_id" db:"consultation_id"`
	PatientID      int64     `json:"patient_id" db:"patient_id"`
	DoctorID       int64     `json:"doctor_id" db:"doctor_id"`
	Diagnosis      string    `json:"diagnosis" db:"diagnosis"`
	Medicines      string    `json:"medicines" db:"medicines"` // JSON array
	Notes          string    `json:"notes" db:"notes"`
	Status         string    `json:"status" db:"status"` // active, dispensed, expired
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}

type HealthRecord struct {
	ID          int64     `json:"id" db:"id"`
	PatientID   int64     `json:"patient_id" db:"patient_id"`
	DoctorID    *int64    `json:"doctor_id" db:"doctor_id"`
	Type        string    `json:"type" db:"type"` // blood_test, imaging, examination
	Title       string    `json:"title" db:"title"`
	Content     string    `json:"content" db:"content"`
	AttachmentURL string  `json:"attachment_url" db:"attachment_url"`
	RecordDate  time.Time `json:"record_date" db:"record_date"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

type FollowUp struct {
	ID             int64     `json:"id" db:"id"`
	ConsultationID int64     `json:"consultation_id" db:"consultation_id"`
	PatientID      int64     `json:"patient_id" db:"patient_id"`
	DoctorID       int64     `json:"doctor_id" db:"doctor_id"`
	ScheduledDate  time.Time `json:"scheduled_date" db:"scheduled_date"`
	Content        string    `json:"content" db:"content"`
	Status         string    `json:"status" db:"status"` // pending, completed, cancelled
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}

type Review struct {
	ID             int64     `json:"id" db:"id"`
	ConsultationID int64     `json:"consultation_id" db:"consultation_id"`
	PatientID      int64     `json:"patient_id" db:"patient_id"`
	DoctorID       int64     `json:"doctor_id" db:"doctor_id"`
	Rating         int       `json:"rating" db:"rating"` // 1-5
	Comment        string    `json:"comment" db:"comment"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}
