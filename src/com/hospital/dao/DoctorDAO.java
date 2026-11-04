package com.hospital.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.hospital.model.Department;
import com.hospital.model.Doctor;
import com.hospital.model.User;

public  class DoctorDAO extends BaseDAO<Doctor> {

    // 添加医生
    public int addDoctor(Doctor doctor) {
        String sql = "INSERT INTO doctors(user_id, name, gender, title, specialty, dept_id, work_schedule) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?)";
        return executeUpdate(sql,
                doctor.getUserId(),
                doctor.getName(),
                doctor.getGender(),
                doctor.getTitle(),
                doctor.getSpecialty(),
                doctor.getDeptId(),
                doctor.getWorkSchedule()
        );
    }

    // 根据ID查找医生
    public Doctor findById(int doctorId) {
        String sql = "SELECT d.*, u.*, dept.dept_name FROM doctors d " +
                "JOIN users u ON d.user_id = u.user_id " +
                "JOIN departments dept ON d.dept_id = dept.dept_id " +
                "WHERE d.doctor_id = ?";

        return querySingle(sql, new DoctorRowMapper(), doctorId);
    }

    // 根据用户ID查找医生
    public Doctor findByUserId(int userId) {
        String sql = "SELECT d.*, u.*, dept.dept_name FROM doctors d " +
                "JOIN users u ON d.user_id = u.user_id " +
                "JOIN departments dept ON d.dept_id = dept.dept_id " +
                "WHERE d.user_id = ?";

        return querySingle(sql, new DoctorRowMapper(), userId);
    }

    // 根据科室ID查找医生列表
    public List<Doctor> findByDeptId(int deptId) {
        String sql = "SELECT d.*, u.*, dept.dept_name FROM doctors d " +
                "JOIN users u ON d.user_id = u.user_id " +
                "JOIN departments dept ON d.dept_id = dept.dept_id " +
                "WHERE d.dept_id = ? AND u.status = 'active'";

        return queryList(sql, new DoctorRowMapper(), deptId);
    }

    // 获取所有医生
    public List<Doctor> findAll() {
        String sql = "SELECT d.*, u.*, dept.dept_name FROM doctors d " +
                "JOIN users u ON d.user_id = u.user_id " +
                "JOIN departments dept ON d.dept_id = dept.dept_id";

        return queryList(sql, new DoctorRowMapper());
    }

    // 更新医生信息
    public int updateDoctor(Doctor doctor) {
        String sql = "UPDATE doctors SET name = ?, gender = ?, title = ?, specialty = ?, " +
                "dept_id = ?, work_schedule = ? WHERE doctor_id = ?";

        return executeUpdate(sql,
                doctor.getName(),
                doctor.getGender(),
                doctor.getTitle(),
                doctor.getSpecialty(),
                doctor.getDeptId(),
                doctor.getWorkSchedule(),
                doctor.getDoctorId()
        );
    }

    @Override
    public int cancelRegistration(int recordId) {
        return 0;
    }

    // 医生行映射器
    private static class DoctorRowMapper implements RowMapper<Doctor> {
        @Override
        public Doctor mapRow(ResultSet rs) throws SQLException {
            Doctor doctor = new Doctor();
            doctor.setDoctorId(rs.getInt("doctor_id"));
            doctor.setUserId(rs.getInt("user_id"));
            doctor.setDeptId(rs.getInt("dept_id"));
            doctor.setName(rs.getString("name"));
            doctor.setGender(rs.getString("gender"));
            doctor.setTitle(rs.getString("title"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setWorkSchedule(rs.getString("work_schedule"));

            // 设置关联的User对象
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setRole(rs.getString("role"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            doctor.setUser(user);

            // 设置关联的Department对象
            Department dept = new Department();
            dept.setDeptId(rs.getInt("dept_id"));
            dept.setDeptName(rs.getString("dept_name"));
            doctor.setDepartment(dept);

            return doctor;
        }
    }
}
