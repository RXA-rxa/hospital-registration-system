package com.hospital.model;

import java.util.List;

public class Department {
    private int deptId;
    private String deptName;
    private String deptType; // outpatient, inpatient
    private String description;
    private String address;
    private String status; // open, closed
    private List<Doctor> doctors;

    // 构造方法
    public Department() {}

    public Department(String deptName, String deptType, String description, String address) {
        this.deptName = deptName;
        this.deptType = deptType;
        this.description = description;
        this.address = address;
    }

    // getter和setter方法
    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public String getDeptName() { return deptName; }
    public void setDeptName(String deptName) { this.deptName = deptName; }

    public String getDeptType() { return deptType; }
    public void setDeptType(String deptType) { this.deptType = deptType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<Doctor> getDoctors() { return doctors; }
    public void setDoctors(List<Doctor> doctors) { this.doctors = doctors; }

    @Override
    public String toString() {
        return "Department{" +
                "deptId=" + deptId +
                ", deptName='" + deptName + '\'' +
                ", deptType='" + deptType + '\'' +
                '}';
    }
}