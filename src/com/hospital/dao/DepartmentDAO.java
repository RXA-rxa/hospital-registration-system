package com.hospital.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import com.hospital.model.Department;

// 去掉 abstract 关键字
public class DepartmentDAO extends BaseDAO<Department> {

    // 添加科室
    public int addDepartment(Department dept) {
        String sql = "INSERT INTO departments(dept_name, dept_type, description, address, status) " +
                "VALUES(?, ?, ?, ?, ?)";
        return executeUpdate(sql,
                dept.getDeptName(),
                dept.getDeptType(),
                dept.getDescription(),
                dept.getAddress(),
                "open"
        );
    }

    // 根据ID查找科室
    public Department findById(int deptId) {
        String sql = "SELECT * FROM departments WHERE dept_id = ?";
        return querySingle(sql, new DepartmentRowMapper(), deptId);
    }

    // 获取所有科室
    public List<Department> findAll() {
        String sql = "SELECT * FROM departments WHERE status = 'open' ORDER BY dept_type, dept_name";
        return queryList(sql, new DepartmentRowMapper());
    }

    // 根据类型获取科室
    public List<Department> findByType(String deptType) {
        String sql = "SELECT * FROM departments WHERE dept_type = ? AND status = 'open'";
        return queryList(sql, new DepartmentRowMapper(), deptType);
    }

    // 更新科室信息
    public int updateDepartment(Department dept) {
        String sql = "UPDATE departments SET dept_name = ?, dept_type = ?, " +
                "description = ?, address = ?, status = ? WHERE dept_id = ?";
        return executeUpdate(sql,
                dept.getDeptName(),
                dept.getDeptType(),
                dept.getDescription(),
                dept.getAddress(),
                dept.getStatus(),
                dept.getDeptId()
        );
    }

    // 删除科室（软删除）
    public int deleteDepartment(int deptId) {
        String sql = "UPDATE departments SET status = 'closed' WHERE dept_id = ?";
        return executeUpdate(sql, deptId);
    }

    @Override
    public int cancelRegistration(int recordId) {
        return 0;
    }

    // 科室行映射器
    private static class DepartmentRowMapper implements RowMapper<Department> {
        @Override
        public Department mapRow(ResultSet rs) throws SQLException {
            Department dept = new Department();
            dept.setDeptId(rs.getInt("dept_id"));
            dept.setDeptName(rs.getString("dept_name"));
            dept.setDeptType(rs.getString("dept_type"));
            dept.setDescription(rs.getString("description"));
            dept.setAddress(rs.getString("address"));
            dept.setStatus(rs.getString("status"));
            return dept;
        }
    }
}