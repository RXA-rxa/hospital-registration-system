package com.hospital.service;

import com.hospital.dao.*;
import com.hospital.model.*;
import java.sql.Date;
import java.util.List;
import java.util.ArrayList;

public class RegistrationService {
    private RegistrationDAO registrationDAO = new RegistrationDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    private TimeSlotDAO timeSlotDAO = new TimeSlotDAO();
    private FeeCalculator feeCalculator = new FeeCalculator();

    // ========== 新增方法 ==========

    /**
     * 获取病人的挂号记录（PatientServlet 需要）
     */
    public List<RegistrationRecord> getPatientRecords(int patientId) {
        try {
            return registrationDAO.findByPatientId(patientId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 获取所有科室（PatientServlet 需要）
     */
    public List<Department> getDepartments() {
        try {
            return departmentDAO.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 获取可用时间段（PatientServlet 需要）
     */
    public List<TimeSlot> getAvailableTimeSlots() {
        try {
            return timeSlotDAO.findAllAvailable();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 创建挂号记录（PatientServlet 需要）
     */
    public boolean createRegistration(int patientId, int doctorId, int deptId,
                                      Date registrationDate, int timeSlotId, String symptoms) {
        try {
            // 检查医生是否可挂号
            Doctor doctor = doctorDAO.findById(doctorId);
            if (doctor == null) {
                return false;
            }

            // 检查时间段是否可用
            TimeSlot timeSlot = timeSlotDAO.findById(timeSlotId);
            if (timeSlot == null || !timeSlot.isAvailable()) {
                return false;
            }

            // 检查是否已挂号
            int existingCount = registrationDAO.getCountByDateAndSlot(registrationDate, timeSlotId, doctorId);
            if (existingCount >= 20) { // 假设每个时段最多20个号
                return false;
            }

            // 计算挂号费
            double fee = feeCalculator.calculateFee(timeSlotId);

            // 创建挂号记录
            RegistrationRecord record = new RegistrationRecord();
            record.setPatientId(patientId);
            record.setDoctorId(doctorId);
            record.setDeptId(deptId);
            record.setRegistrationDate(registrationDate);
            record.setTimeSlotId(timeSlotId);
            record.setFee(fee);
            record.setSymptoms(symptoms);
            record.setStatus("pending");

            return registrationDAO.addRegistration(record) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 取消挂号（PatientServlet 需要）
     */
    public boolean cancelRegistration(int recordId) {
        try {
            return registrationDAO.cancelRegistration(recordId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取医生管理的挂号记录
     */
    public List<RegistrationRecord> getDoctorRecords(int doctorId, String filterType, String filterValue) {
        try {
            return registrationDAO.findByDoctorId(doctorId, filterType, filterValue);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ========== 之前已有的添加方法 ==========

    /**
     * 添加医生（HospitalTest 需要）
     */
    public boolean addDoctor(Doctor doctor) {
        try {
            return doctorDAO.addDoctor(doctor) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 添加科室（HospitalTest 需要）
     */
    public boolean addDepartment(Department dept) {
        try {
            return departmentDAO.addDepartment(dept) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 添加病人（HospitalTest 需要）
     */
    public boolean addPatient(Patient patient) {
        try {
            PatientDAO patientDAO = new PatientDAO();
            return patientDAO.addPatient(patient) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取所有医生（HospitalTest 需要）
     */
    public List<Doctor> getAllDoctors() {
        try {
            return doctorDAO.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * 更新挂号状态
     */
    public boolean updateRegistrationStatus(int recordId, String status) {
        try {
            return registrationDAO.updateStatus(recordId, status) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 确认挂号
     */
    public boolean confirmRegistration(int recordId) {
        return updateRegistrationStatus(recordId, "confirmed");
    }

    /**
     * 完成就诊
     */
    public boolean completeRegistration(int recordId) {
        return updateRegistrationStatus(recordId, "completed");
    }

    /**
     * 根据科室获取医生
     */
    public List<Doctor> getDoctorsByDepartment(int deptId) {
        try {
            return doctorDAO.findByDeptId(deptId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void close() {
    }

    public void addDepartment(entity.Department dept1) {
    }

    public void addDoctor(entity.Doctor doctor1) {
    }

    public void addPatient(entity.Patient patient1) {
    }

    public boolean registerPatient(int i, int i1, int i2, java.util.Date today, String 上午) {
        return false;
    }

    public List<entity.RegistrationRecord> addPatient(int i) {
        return java.util.Collections.emptyList();
    }

    public List<entity.RegistrationRecord> addDoctor(int i) {
        return java.util.Collections.emptyList();
    }

    public List<entity.RegistrationRecord> getDoctorsByDepartment(java.util.Date today) {
        return java.util.Collections.emptyList();
    }

    public List<entity.Department> getAllDepartments() {
        return java.util.Collections.emptyList();
    }

    public List<entity.RegistrationRecord> findRecordsByDepartment(int i) {
        return java.util.Collections.emptyList();
    }
}