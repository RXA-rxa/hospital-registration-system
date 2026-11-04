package com.hospital.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.hospital.model.User;

public class UserDAO extends BaseDAO<User> {

    // 用户登录验证
    public User validateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND status = 'active'";
        return querySingle(sql, new UserRowMapper(), username, password);
    }

    // 根据ID查找用户
    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        return querySingle(sql, new UserRowMapper(), userId);
    }

    // 根据用户名查找用户
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        return querySingle(sql, new UserRowMapper(), username);
    }

    // 添加用户
    public int addUser(User user) {
        String sql = "INSERT INTO users(username, password, role, email, phone) VALUES(?, ?, ?, ?, ?)";
        return executeUpdate(sql,
                user.getUsername(),
                user.getPassword(),
                user.getRole(),
                user.getEmail(),
                user.getPhone()
        );
    }

    // 更新用户最后登录时间
    public int updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE user_id = ?";
        return executeUpdate(sql, userId);
    }

    // 更新用户信息
    public int updateUser(User user) {
        String sql = "UPDATE users SET email = ?, phone = ?, status = ? WHERE user_id = ?";
        return executeUpdate(sql,
                user.getEmail(),
                user.getPhone(),
                user.getStatus(),
                user.getUserId()
        );
    }

    // 删除用户（软删除）
    public int deleteUser(int userId) {
        String sql = "UPDATE users SET status = 'inactive' WHERE user_id = ?";
        return executeUpdate(sql, userId);
    }

    // 获取所有用户
    public List<User> findAll() {
        String sql = "SELECT * FROM users WHERE status = 'active'";
        return queryList(sql, new UserRowMapper());
    }

    @Override
    public int cancelRegistration(int recordId) {
        return 0;
    }

    // 用户行映射器
    private static class UserRowMapper implements RowMapper<User> {
        @Override
        public User mapRow(ResultSet rs) throws SQLException {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setRole(rs.getString("role"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setLastLogin(rs.getTimestamp("last_login"));
            user.setStatus(rs.getString("status"));
            return user;
        }
    }
}