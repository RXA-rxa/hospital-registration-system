<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%
    // 设置请求编码，避免中文乱码
    request.setCharacterEncoding("UTF-8");
    // 获取前端传入的科室ID
    String deptId = request.getParameter("deptId");

    // 如果科室ID为空，返回提示选项
    if (deptId == null || deptId.trim().isEmpty()) {
        out.print("<option value=''>-- 请先选择科室 --</option>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        // 连接数据库
        conn = DBUtil.getConnection();
        if (conn != null) {
            // 核心SQL：通过科室ID关联查询该科室的医生信息
            // 关联doctor_info表（医生信息）和user表（医生的真实姓名）
            String sql = "SELECT d.id, u.real_name FROM doctor_info d " +
                         "JOIN user u ON d.user_id = u.id " +
                         "WHERE d.dept_id = ? " +  // 根据科室ID筛选
                         "ORDER BY d.id ASC";      // 按医生ID排序
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(deptId)); // 传入科室ID参数
            rs = pstmt.executeQuery();

            boolean hasDoctors = false;
            // 遍历结果，生成医生下拉选项
            while (rs.next()) {
                hasDoctors = true;
                String doctorId = rs.getString("id");       // 医生ID（存入挂号表）
                String doctorName = rs.getString("real_name"); // 医生真实姓名（显示给用户）
                out.print("<option value='" + doctorId + "'>" + doctorName + "</option>");
            }

            // 如果该科室没有医生，返回提示
            if (!hasDoctors) {
                out.print("<option value=''>-- 该科室暂无医生 --</option>");
            }
        } else {
            out.print("<option value=''>-- 数据库连接失败 --</option>");
        }
    } catch (Exception e) {
        // 异常时返回提示
        out.print("<option value=''>-- 加载医生异常 --</option>");
        e.printStackTrace();
    } finally {
        // 关闭数据库资源
        DBUtil.close(conn, pstmt, rs);
    }
%>