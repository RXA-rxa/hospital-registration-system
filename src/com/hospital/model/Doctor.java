package com.hospital.model;

public class Doctor {
    private int doctorId;
    private int userId;
    private int deptId;
    private String name;
    private String gender;
    private String title;
    private String specialty;
    private String workSchedule;
    private User user;
    private Department department;

    // 构造方法
    public Doctor() {}

    public Doctor(String name, String gender, String title, String specialty, int deptId) {
        this.name = name;
        this.gender = gender;
        this.title = title;
        this.specialty = specialty;
        this.deptId = deptId;
    }

    // getter和setter方法
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }

    public String getWorkSchedule() { return workSchedule; }
    public void setWorkSchedule(String workSchedule) { this.workSchedule = workSchedule; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }

    @Override
    public String toString() {
        return "Doctor{" +
                "doctorId=" + doctorId +
                ", name='" + name + '\'' +
                ", title='" + title + '\'' +
                ", specialty='" + specialty + '\'' +
                '}';
    }
}
