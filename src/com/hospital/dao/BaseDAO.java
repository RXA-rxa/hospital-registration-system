package com.hospital.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.hospital.util.DBUtil;

public abstract class BaseDAO<T> {

    /**
     * 获取数据库连接
     */
    protected Connection getConnection() throws SQLException {
        return DBUtil.getConnection();
    }

    /**
     * 关闭资源
     */
    protected void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 执行更新操作（INSERT, UPDATE, DELETE）
     */
    protected int executeUpdate(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            // 设置参数
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return result;
    }

    /**
     * 执行查询操作，返回单个对象
     */
    protected T querySingle(String sql, RowMapper<T> mapper, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        T obj = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                obj = mapper.mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return obj;
    }

    /**
     * 执行查询操作，返回对象列表
     */
    protected List<T> queryList(String sql, RowMapper<T> mapper, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<T> list = new ArrayList<>();

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                T obj = mapper.mapRow(rs);
                list.add(obj);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return list;
    }

    public abstract int cancelRegistration(int recordId);

    /**
     * 行映射器接口
     */
    public interface RowMapper<T> {
        T mapRow(ResultSet rs) throws SQLException;
    }
}