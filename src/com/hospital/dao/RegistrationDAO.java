package com.hospital.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import com.hospital.model.*;

public  class RegistrationDAO extends BaseDAO<RegistrationRecord> {

    // 添加挂号记录
    public int addRegistration(RegistrationRecord record) {
        String sql = "INSERT INTO registration_records(patient_id, doctor_id, dept_id, " +
                "registration_date, time_slot_id, fee, status, symptoms) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?, ?)";

        return executeUpdate(sql,
                record.getPatientId(),
                record.getDoctorId(),
                record.getDeptId(),
                record.getRegistrationDate(),
                record.getTimeSlotId(),
                record.getFee(),
                record.getStatus(),
                record.getSymptoms()
        );
    }

    // 根据ID查找挂号记录
    public RegistrationRecord findById(int recordId) {
        String sql = "SELECT r.*, p.name as patient_name, d.name as doctor_name, " +
                "dept.dept_name, ts.slot_name " +
                "FROM registration_records r " +
                "JOIN patients p ON r.patient_id = p.patient_id " +
                "JOIN doctors d ON r.doctor_id = d.doctor_id " +
                "JOIN departments dept ON r.dept_id = dept.dept_id " +
                "JOIN time_slots ts ON r.time_slot_id = ts.slot_id " +
                "WHERE r.record_id = ?";

        return querySingle(sql, new RegistrationRowMapper(), recordId);
    }

    // 根据病人ID查找挂号记录
    public List<RegistrationRecord> findByPatientId(int patientId) {
        String sql = "SELECT r.*, p.name as patient_name, d.name as doctor_name, " +
                "dept.dept_name, ts.slot_name " +
                "FROM registration_records r " +
                "JOIN patients p ON r.patient_id = p.patient_id " +
                "JOIN doctors d ON r.doctor_id = d.doctor_id " +
                "JOIN departments dept ON r.dept_id = dept.dept_id " +
                "JOIN time_slots ts ON r.time_slot_id = ts.slot_id " +
                "WHERE r.patient_id = ? ORDER BY r.registration_date DESC, r.created_at DESC";

        return queryList(sql, new RegistrationRowMapper(), patientId);
    }

    // 根据医生ID查找挂号记录
    public List<RegistrationRecord> findByDoctorId(int doctorId, String filterType, String filterValue) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, p.name as patient_name, d.name as doctor_name, ");
        sql.append("dept.dept_name, ts.slot_name ");
        sql.append("FROM registration_records r ");
        sql.append("JOIN patients p ON r.patient_id = p.patient_id ");
        sql.append("JOIN doctors d ON r.doctor_id = d.doctor_id ");
        sql.append("JOIN departments dept ON r.dept_id = dept.dept_id ");
        sql.append("JOIN time_slots ts ON r.time_slot_id = ts.slot_id ");
        sql.append("WHERE r.doctor_id = ? ");

        // 添加筛选条件
        if (filterType != null && filterValue != null) {
            switch (filterType) {
                case "patient":
                    sql.append("AND p.name LIKE ? ");
                    filterValue = "%" + filterValue + "%";
                    break;
                case "date":
                    sql.append("AND r.registration_date = ? ");
                    break;
                case "status":
                    sql.append("AND r.status = ? ");
                    break;
            }
        }

        sql.append("ORDER BY r.registration_date DESC, r.created_at DESC");

        if (filterType != null && filterValue != null) {
            return queryList(sql.toString(), new RegistrationRowMapper(), doctorId, filterValue);
        } else {
            return queryList(sql.toString(), new RegistrationRowMapper(), doctorId);
        }
    }

    // 更新挂号记录状态
    public int updateStatus(int recordId, String status) {
        String sql = "UPDATE registration_records SET status = ? WHERE record_id = ?";
        return executeUpdate(sql, status, recordId);
    }

    // 删除挂号记录
    public int deleteRegistration(int recordId) {
        String sql = "DELETE FROM registration_records WHERE record_id = ?";
        return executeUpdate(sql, recordId);
    }

    // 获取某日期的挂号数量
    public int getCountByDateAndSlot(Date date, int timeSlotId, int doctorId) {
        String sql = "SELECT COUNT(*) FROM registration_records " +
                "WHERE registration_date = ? AND time_slot_id = ? AND doctor_id = ? AND status != 'cancelled'";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setDate(1, (java.sql.Date) date);
            pstmt.setInt(2, timeSlotId);
            pstmt.setInt(3, doctorId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return count;
    }

    @Override
    public int cancelRegistration(int recordId) {
        return 0;
    }

    // 挂号记录行映射器
    private static class RegistrationRowMapper implements RowMapper<RegistrationRecord> {
        @Override
        public RegistrationRecord mapRow(ResultSet rs) throws SQLException {
            RegistrationRecord record = new RegistrationRecord();
            record.setRecordId(rs.getInt("record_id"));
            record.setPatientId(rs.getInt("patient_id"));
            record.setDoctorId(rs.getInt("doctor_id"));
            record.setDeptId(rs.getInt("dept_id"));
            record.setRegistrationDate(rs.getDate("registration_date"));
            record.setTimeSlotId(rs.getInt("time_slot_id"));
            record.setFee(rs.getDouble("fee"));
            record.setStatus(rs.getString("status"));
            record.setSymptoms(rs.getString("symptoms"));
            record.setCreatedAt(rs.getTimestamp("created_at"));

            // 设置关联对象信息
            Patient patient = new Patient();
            patient.setName(rs.getString("patient_name"));
            record.setPatient(patient);

            Doctor doctor = new Doctor();
            doctor.setName(rs.getString("doctor_name"));
            record.setDoctor(doctor);

            Department dept = new Department();
            dept.setDeptName(rs.getString("dept_name"));
            record.setDepartment(dept);

            TimeSlot timeSlot = new TimeSlot();
            timeSlot.setSlotName(rs.getString("slot_name"));
            record.setTimeSlot(timeSlot);

            return record;
        }
    }
}