package com.hospital.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import com.hospital.model.Patient;
import com.hospital.model.User;

public class PatientDAO extends BaseDAO<Patient> {

    // 添加病人
    public int addPatient(Patient patient) {
        String sql = "INSERT INTO patients(user_id, name, gender, age, id_card, address) VALUES(?, ?, ?, ?, ?, ?)";
        return executeUpdate(sql,
                patient.getUserId(),
                patient.getName(),
                patient.getGender(),
                patient.getAge(),
                patient.getIdCard(),
                patient.getAddress()
        );
    }

    // 根据ID查找病人
    public Patient findById(int patientId) {
        String sql = "SELECT p.*, u.* FROM patients p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "WHERE p.patient_id = ?";

        return querySingle(sql, new PatientRowMapper(), patientId);
    }

    // 根据用户ID查找病人
    public Patient findByUserId(int userId) {
        String sql = "SELECT p.*, u.* FROM patients p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "WHERE p.user_id = ?";

        return querySingle(sql, new PatientRowMapper(), userId);
    }

    // 更新病人信息
    public int updatePatient(Patient patient) {
        String sql = "UPDATE patients SET name = ?, gender = ?, age = ?, id_card = ?, address = ? WHERE patient_id = ?";
        return executeUpdate(sql,
                patient.getName(),
                patient.getGender(),
                patient.getAge(),
                patient.getIdCard(),
                patient.getAddress(),
                patient.getPatientId()
        );
    }

    // 获取所有病人
    public List<Patient> findAll() {
        String sql = "SELECT p.*, u.* FROM patients p " +
                "JOIN users u ON p.user_id = u.user_id";
        return queryList(sql, new PatientRowMapper());
    }

    @Override
    public int cancelRegistration(int recordId) {
        return 0;
    }

    // 病人行映射器
    private static class PatientRowMapper implements RowMapper<Patient> {
        @Override
        public Patient mapRow(ResultSet rs) throws SQLException {
            Patient patient = new Patient();
            patient.setPatientId(rs.getInt("patient_id"));
            patient.setUserId(rs.getInt("user_id"));
            patient.setName(rs.getString("name"));
            patient.setGender(rs.getString("gender"));
            patient.setAge(rs.getInt("age"));
            patient.setIdCard(rs.getString("id_card"));
            patient.setAddress(rs.getString("address"));

            // 设置关联的User对象
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setRole(rs.getString("role"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            patient.setUser(user);

            return patient;
        }
    }
}