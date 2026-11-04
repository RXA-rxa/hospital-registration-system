<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%
    // 验证医生登录
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null || !"2".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 1. 查询医生当前所属科室的详细信息 (ID, 名称, 简介)
    String currentDeptName = "您尚未维护科室信息";
    String currentDeptDesc = "请先在下方表单中选择并保存您的科室。";
    int deptIdToUpdate = 0; // 用于在修改时知道要更新哪个科室

    Connection infoConn = null;
    PreparedStatement infoPstmt = null;
    ResultSet infoRs = null;
    try {
        infoConn = DBUtil.getConnection();
        // 从 doctor_info -> dept_info 来获取科室的原始信息
        String sql = "SELECT d.dept_id, dept.dept_name, dept.dept_desc " +
                     "FROM doctor_info d " +
                     "JOIN dept_info dept ON d.dept_id = dept.id " +
                     "WHERE d.user_id = ?";
        infoPstmt = infoConn.prepareStatement(sql);
        infoPstmt.setInt(1, userId);
        infoRs = infoPstmt.executeQuery();
        if (infoRs.next()) {
            deptIdToUpdate = infoRs.getInt("dept_id");
            currentDeptName = infoRs.getString("dept_name");
            currentDeptDesc = infoRs.getString("dept_desc") != null ? infoRs.getString("dept_desc") : "该科室暂无简介。";
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBUtil.close(infoConn, infoPstmt, infoRs);
    }

    // 2. 处理表单提交（修改科室信息）
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newDeptName = request.getParameter("newDeptName");
        String newDeptDesc = request.getParameter("newDeptDesc");

        if (deptIdToUpdate == 0) {
            out.print("<script>alert('错误：未找到您要修改的科室！');</script>");
        } else if (newDeptName == null || newDeptName.trim().isEmpty()) {
            out.print("<script>alert('科室名称不能为空！');</script>");
        } else {
            Connection updateConn = null;
            PreparedStatement updatePstmt = null;
            try {
                updateConn = DBUtil.getConnection();
                // 直接更新 dept_info 表
                String sql = "UPDATE dept_info SET dept_name = ?, dept_desc = ? WHERE id = ?";
                updatePstmt = updateConn.prepareStatement(sql);
                updatePstmt.setString(1, newDeptName);
                updatePstmt.setString(2, newDeptDesc);
                updatePstmt.setInt(3, deptIdToUpdate);

                int rowsAffected = updatePstmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.print("<script>alert('科室信息修改成功！'); location.reload();</script>");
                } else {
                    out.print("<script>alert('科室信息修改失败，请重试！');</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("<script>alert('修改异常：" + e.getMessage() + "');</script>");
            } finally {
                DBUtil.close(updateConn, updatePstmt, null);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>维护科室信息</title>
    <style>
        body { font-family: "Microsoft YaHei", sans-serif; background-color: #f4f7f9; margin: 0; padding: 20px; }
        .container { max-width: 700px; margin: 0 auto; }
        .card { background-color: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 30px; margin-bottom: 25px; }
        .card h2 { color: #2c3e50; border-bottom: 2px solid #e0e0e0; padding-bottom: 10px; margin-top: 0; }
        .info-display p { font-size: 16px; line-height: 1.8; color: #34495e; }
        .info-display strong { color: #2980b9; }
        .form-item { margin-bottom: 20px; }
        .form-item label { display: block; margin-bottom: 8px; font-weight: bold; color: #34495e; }
        .form-item input, .form-item textarea { width: 100%; padding: 12px; border: 1px solid #bdc3c7; border-radius: 5px; font-size: 16px; box-sizing: border-box; }
        .form-item textarea { resize: vertical; min-height: 120px; }
        .btn { display: inline-block; padding: 12px 30px; background-color: #2ecc71; color: #fff; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; transition: background-color 0.3s; }
        .btn:hover { background-color: #27ae60; }
        .btn-back { background-color: #95a5a6; margin-left: 15px; text-decoration: none; }
        .btn-back:hover { background-color: #7f8c8d; color: #fff; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>当前科室信息</h2>
            <div class="info-display">
                <% if (deptIdToUpdate > 0) { %>
                    <p><strong>科室ID：</strong><%= deptIdToUpdate %></p>
                    <p><strong>科室名称：</strong><%= currentDeptName %></p>
                    <p><strong>科室简介：</strong><%= currentDeptDesc %></p>
                <% } else { %>
                    <p>您尚未选择科室，请先在“医生科室信息维护”页面中进行设置。</p>
                <% } %>
            </div>
        </div>

        <% if (deptIdToUpdate > 0) { %>
        <div class="card">
            <h2>修改科室信息</h2>
            <form action="doctor_dept_edit.jsp" method="post">
                <div class="form-item">
                    <label for="newDeptName">新科室名称</label>
                    <input type="text" id="newDeptName" name="newDeptName" value="<%= currentDeptName %>" required>
                </div>
                <div class="form-item">
                    <label for="newDeptDesc">新科室简介</label>
                    <textarea id="newDeptDesc" name="newDeptDesc" required><%= currentDeptDesc %></textarea>
                </div>
                <button type="submit" class="btn">保存修改</button>
                <a href="index.jsp" class="btn btn-back">返回</a>
            </form>
        </div>
        <% } %>
    </div>
</body>
</html>