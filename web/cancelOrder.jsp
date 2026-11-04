<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.util.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>取消预约 - 挂号系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f7fa; color: #333; font-family: "Microsoft YaHei", sans-serif; font-size: 14px; }
        .container {
            max-width: 600px; margin: 50px auto; background: #fff;
            padding: 30px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        .warning-icon { font-size: 50px; color: #ffc107; margin-bottom: 20px; }
        .warning-title { font-size: 22px; color: #dc3545; margin-bottom: 15px; }
        .warning-desc { color: #666; line-height: 1.6; margin-bottom: 30px; }
        .order-info {
            background: #f8f9fa; padding: 20px; border-radius: 6px;
            margin-bottom: 30px; text-align: left;
        }
        .order-info p { margin-bottom: 10px; }
        .order-info span { color: #2f5496; font-weight: 500; }
        .btn-group {
            display: flex; gap: 20px; justify-content: center;
        }
        .confirm-btn {
            padding: 12px 35px; background: #dc3545; color: #fff;
            text-decoration: none; border-radius: 6px; font-size: 16px;
            transition: all 0.3s ease;
        }
        .confirm-btn:hover { background: #c82333; }
        .cancel-btn {
            padding: 12px 35px; background: #6c757d; color: #fff;
            text-decoration: none; border-radius: 6px; font-size: 16px;
            transition: all 0.3s ease;
        }
        .cancel-btn:hover { background: #5a6268; }
    </style>
</head>
<body>
    <div class="container">
        <div class="warning-icon">⚠️</div>
        <div class="warning-title">确认取消预约？</div>
        <div class="warning-desc">
            取消预约后，该号源将被释放，无法恢复。<br>
            如需重新预约，请在号源充足时再次操作。
        </div>

        <%
            String orderNo = request.getParameter("orderNo");
            if (orderNo == null || orderNo.trim().isEmpty()) {
                orderNo = "未知编号";
            }
            // 查询预约基础信息
            String deptName = "";
            String registDate = "";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT dept_name, regist_date FROM regist_order WHERE order_no = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, orderNo);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    deptName = rs.getString("dept_name");
                    registDate = rs.getString("regist_date");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }
        %>

        <div class="order-info">
            <p>预约编号：<span><%= orderNo %></span></p>
            <p>就诊科室：<span><%= deptName %></span></p>
            <p>预约日期：<span><%= registDate %></span></p>
        </div>

        <div class="btn-group">
            <a href="myOrder.jsp?cancelNo=<%= orderNo %>" class="confirm-btn">确认取消</a>
            <a href="orderDetail.jsp?orderNo=<%= orderNo %>" class="cancel-btn">取消操作</a>
        </div>
    </div>
</body>
</html>