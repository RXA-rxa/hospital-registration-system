package com.hospital.model;

public class Patient {
    private int patientId;
    private int userId;
    private String name;
    private String gender;
    private int age;
    private String idCard;
    private String address;
    private User user; // 关联用户

    // 构造方法
    public Patient() {}

    public Patient(String name, String gender, int age, String idCard, String address) {
        this.name = name;
        this.gender = gender;
        this.age = age;
        this.idCard = idCard;
        this.address = address;
    }

    // getter和setter
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getIdCard() { return idCard; }
    public void setIdCard(String idCard) { this.idCard = idCard; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    @Override
    public String toString() {
        return "Patient{" +
                "patientId=" + patientId +
                ", name='" + name + '\'' +
                ", gender='" + gender + '\'' +
                ", age=" + age +
                '}';
    }
}