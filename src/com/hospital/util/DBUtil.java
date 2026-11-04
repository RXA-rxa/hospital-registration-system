package com.hospital.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 数据库连接工具类
 */
public class DBUtil {
    // MySQL连接配置（根据你的本地数据库修改用户名和密码）
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/hospital_regist?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai";

    private static final String DB_USER = "root"; // 你的MySQL用户名
    private static final String DB_PASSWORD = "123456"; // 你的MySQL密码

    // 加载驱动
    static {
        try {
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取数据库连接
     * @return Connection
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    /**
     * 关闭数据库资源
     * @param conn 连接对象
     * @param pstmt 预处理对象
     * @param rs 结果集对象
     */
    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 重载：关闭连接和预处理对象（无结果集时使用）
    public static void close(Connection conn, PreparedStatement pstmt) {
        close(conn, pstmt, null);
    }

    public static boolean testConnection() {

        return false;
    }
}