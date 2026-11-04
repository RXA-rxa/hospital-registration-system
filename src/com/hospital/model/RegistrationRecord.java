package com.hospital.model;

import java.sql.Date;
import java.sql.Timestamp;

public class RegistrationRecord {
    private int recordId;
    private int patientId;
    private int doctorId;
    private int deptId;
    private Date registrationDate;
    private int timeSlotId;
    private double fee;
    private String status; // pending, confirmed, cancelled, completed
    private String symptoms;
    private Timestamp createdAt;

    // 关联对象
    private Patient patient;
    private Doctor doctor;
    private Department department;
    private TimeSlot timeSlot;

    // 构造方法
    public RegistrationRecord() {}

    public RegistrationRecord(int patientId, int doctorId, int deptId,
                              Date registrationDate, int timeSlotId, double fee) {
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.deptId = deptId;
        this.registrationDate = registrationDate;
        this.timeSlotId = timeSlotId;
        this.fee = fee;
        this.status = "pending";
    }

    // getter和setter方法
    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public Date getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Date registrationDate) { this.registrationDate = registrationDate; }

    public int getTimeSlotId() { return timeSlotId; }
    public void setTimeSlotId(int timeSlotId) { this.timeSlotId = timeSlotId; }

    public double getFee() { return fee; }
    public void setFee(double fee) { this.fee = fee; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSymptoms() { return symptoms; }
    public void setSymptoms(String symptoms) { this.symptoms = symptoms; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }

    public TimeSlot getTimeSlot() { return timeSlot; }
    public void setTimeSlot(TimeSlot timeSlot) { this.timeSlot = timeSlot; }

    @Override
    public String toString() {
        return "RegistrationRecord{" +
                "recordId=" + recordId +
                ", patientId=" + patientId +
                ", doctorId=" + doctorId +
                ", registrationDate=" + registrationDate +
                ", fee=" + fee +
                ", status='" + status + '\'' +
                '}';
    }
}