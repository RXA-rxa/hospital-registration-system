<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约成功 - 挂号系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f7fa; color: #333; font-family: "Microsoft YaHei", sans-serif; font-size: 14px; }
        .header {
            background: #2f5496;
            color: #fff;
            padding: 15px 0;
            text-align: center;
            font-size: 22px;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .container {
            width: 90%;
            max-width: 600px;
            margin: 40px auto;
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            font-size: 60px;
            color: #28a745;
            margin-bottom: 20px;
        }
        .title {
            font-size: 24px;
            color: #2f5496;
            margin-bottom: 30px;
            font-weight: bold;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            text-align: left;
        }
        .info-table th, .info-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #e9ecef;
        }
        .info-table th {
            width: 30%;
            font-weight: 500;
            color: #495057;
            background-color: #f8f9fa;
        }
        .info-table td {
            width: 70%;
            color: #212529;
        }
        .btn-group {
            margin-top: 20px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 10px;
            background: #2f5496;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .btn:hover {
            background: #234680;
        }
        .btn-secondary {
            background: #6c757d;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .error-msg {
            color: #dc3545;
            font-size: 16px;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="header">预约结果</div>
    <div class="container">
        <%
            // 1. 从请求中获取预约编号
            String orderNo = request.getParameter("orderNo");

            // 2. 验证预约编号是否存在
            if (orderNo == null || orderNo.trim().isEmpty()) {
                out.println("<div class='error-msg'>错误：未找到有效的预约信息！</div>");
                out.println("<div class='btn-group'><a href='register.jsp' class='btn'>返回重新预约</a></div>");
                return; // 终止页面继续执行
            }

            // 3. 根据预约编号从数据库查询详细信息
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean orderFound = false;

            try {
                conn = DBUtil.getConnection();
                if (conn != null) {
                    // 核心SQL：使用JOIN关联所有需要的表，一次性查出所有信息
                    String sql = "SELECT " +
                                 "ro.order_no, ro.regist_date, ro.regist_time_slot, ro.regist_fee, ro.order_status, " +
                                 "u.real_name AS patient_name, u.id_card, u.phone, " +
                                 "d.dept_name, " +
                                 "doc_u.real_name AS doctor_name " +
                                 "FROM regist_order ro " +
                                 "JOIN user u ON ro.user_id = u.id " +
                                 "JOIN dept_info d ON ro.dept_id = d.id " +
                                 "LEFT JOIN doctor_info di ON ro.doctor_id = di.id " +
                                 "LEFT JOIN user doc_u ON di.user_id = doc_u.id " +
                                 "WHERE ro.order_no = ?";

                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, orderNo);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        orderFound = true;
                        // 从查询结果中获取所有需要显示的字段
                        String patientName = rs.getString("patient_name");
                        String idCard = rs.getString("id_card");
                        String phone = rs.getString("phone");
                        String deptName = rs.getString("dept_name");
                        String doctorName = rs.getString("doctor_name");
                        String registDate = rs.getString("regist_date");
                        String timeSlot = rs.getString("regist_time_slot");
                        String fee = rs.getString("regist_fee");
                        String status = rs.getString("order_status");

                        // 如果医生姓名为空（可能是预约科室未指定医生），给一个默认值
                        if (doctorName == null || doctorName.trim().isEmpty()) {
                            doctorName = "（系统安排）";
                        }
        %>
                        <!-- 4. 动态生成并显示预约成功信息 -->
                        <div class="success-icon">✓</div>
                        <div class="title">预约成功！</div>
                        <p style="font-size: 18px; color: #28a745; margin-bottom: 20px;">您的预约已提交成功，请凭预约信息按时就诊。</p>

                        <table class="info-table">
                            <tr>
                                <th>预约编号：</th>
                                <td><%= orderNo %></td>
                            </tr>
                            <tr>
                                <th>患者姓名：</th>
                                <td><%= patientName %></td>
                            </tr>
                            <tr>
                                <th>身份证号：</th>
                                <td><%= idCard %></td>
                            </tr>
                            <tr>
                                <th>联系电话：</th>
                                <td><%= phone %></td>
                            </tr>
                            <tr>
                                <th>预约科室：</th>
                                <td><%= deptName %></td>
                            </tr>
                            <tr>
                                <th>接诊医生：</th>
                                <td><%= doctorName %></td>
                            </tr>
                            <tr>
                                <th>预约日期：</th>
                                <td><%= registDate %></td>
                            </tr>
                            <tr>
                                <th>预约时段：</th>
                                <td><%= timeSlot %></td>
                            </tr>
                            <tr>
                                <th>挂号费用：</th>
                                <td>¥<%= fee %></td>
                            </tr>
                            <tr>
                                <th>预约状态：</th>
                                <td><%= status %></td>
                            </tr>
                        </table>

                        <div class="btn-group">
                            <a href="patient_regist_record.jsp" class="btn">查看我的预约</a>
                            <a href="register.jsp" class="btn btn-secondary">继续预约</a>
                        </div>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("<div class='error-msg'>查询预约信息时发生异常：" + e.getMessage() + "</div>");
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }

            // 5. 如果没有找到对应的预约记录
            if (!orderFound) {
                out.println("<div class='error-msg'>错误：未查询到编号为 " + orderNo + " 的预约记录！</div>");
                out.println("<div class='btn-group'><a href='register.jsp' class='btn'>返回重新预约</a></div>");
            }
        %>
    </div>
</body>
</html>