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
    <title>预约详情 - 挂号系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f7fa; color: #333; font-family: "Microsoft YaHei", sans-serif; font-size: 14px; }
        .container {
            max-width: 700px; margin: 50px auto; background: #fff;
            padding: 30px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .back { margin-bottom: 20px; }
        .back a {
            color: #2f5496; text-decoration: none; display: inline-flex; align-items: center;
        }
        .back a::before { content: "←"; margin-right: 5px; }
        .order-title {
            color: #2f5496; font-size: 20px; margin-bottom: 20px;
            padding-bottom: 15px; border-bottom: 2px solid #e8f0fe;
        }
        .info-group {
            margin-bottom: 25px;
        }
        .info-group h5 {
            font-size: 16px; color: #333; margin-bottom: 15px;
            display: flex; align-items: center;
        }
        .info-group h5::before {
            content: ""; width: 4px; height: 16px; background: #2f5496;
            margin-right: 8px; border-radius: 2px;
        }
        .info-item {
            display: flex; padding: 10px 0; border-bottom: 1px solid #f0f0f0;
        }
        .info-item label {
            width: 130px; color: #666; font-weight: 500; flex-shrink: 0;
        }
        .info-item span {
            color: #333; flex: 1;
        }
        .print-btn {
            display: inline-block; padding: 10px 25px; background: #ff7f50;
            color: #fff; text-decoration: none; border-radius: 6px; font-size: 14px;
            transition: all 0.3s ease;
        }
        .print-btn:hover { background: #e67e22; }
        .back-btn {
            display: inline-block; padding: 10px 25px; background: #2f5496;
            color: #fff; text-decoration: none; border-radius: 6px; font-size: 14px;
            margin-left: 10px; transition: all 0.3s ease;
        }
        .back-btn:hover { background: #234680; }
    </style>
</head>
<body>
    <div class="container">
        <div class="back">
            <a href="myOrder.jsp">返回我的预约</a>
        </div>

        <%
            String orderNo = request.getParameter("orderNo");
            if (orderNo == null || orderNo.trim().isEmpty()) {
                orderNo = "未知编号";
            }
            // 从数据库查询预约详情
            String deptName = "";
            String doctorName = "";
            String patientName = "";
            String idCard = "";
            String phone = "";
            String registDate = "";
            String orderStatus = "";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT * FROM regist_order WHERE order_no = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, orderNo);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    deptName = rs.getString("dept_name");
                    doctorName = rs.getString("doctor_name");
                    patientName = rs.getString("patient_name");
                    idCard = rs.getString("id_card");
                    phone = rs.getString("phone");
                    registDate = rs.getString("regist_date");
                    orderStatus = rs.getString("order_status");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }
            // 身份证脱敏
            String idCardMask = idCard;
            if (idCard.length() == 18) {
                idCardMask = idCard.substring(0,6) + "********" + idCard.substring(14);
            }
            // 手机号脱敏
            String phoneMask = phone;
            if (phone.length() == 11) {
                phoneMask = phone.substring(0,3) + "****" + phone.substring(7);
            }
        %>

        <div class="order-title">
            预约详情（<%= orderNo %>）
        </div>

        <div class="info-group">
            <h5>基础预约信息</h5>
            <div class="info-item">
                <label>预约编号：</label>
                <span><%= orderNo %></span>
            </div>
            <div class="info-item">
                <label>就诊科室：</label>
                <span><%= deptName %></span>
            </div>
            <div class="info-item">
                <label>预约医生：</label>
                <span><%= doctorName %>（主任医师）</span>
            </div>
            <div class="info-item">
                <label>预约日期：</label>
                <span><%= registDate %></span>
            </div>
            <div class="info-item">
                <label>坐诊时间：</label>
                <span>上午 8:00-12:00</span>
            </div>
            <div class="info-item">
                <label>预约状态：</label>
                <span style="color: <%= "待就诊".equals(orderStatus) ? "#155724" : "#721c24" %>; font-weight: 500;"><%= orderStatus %></span>
            </div>
        </div>

        <div class="info-group">
            <h5>患者信息</h5>
            <div class="info-item">
                <label>患者姓名：</label>
                <span><%= patientName %></span>
            </div>
            <div class="info-item">
                <label>身份证号：</label>
                <span><%= idCardMask %></span>
            </div>
            <div class="info-item">
                <label>联系电话：</label>
                <span><%= phoneMask %></span>
            </div>
        </div>

        <div class="info-group">
            <h5>就诊须知</h5>
            <div class="info-item" style="flex-direction: column; align-items: flex-start; padding: 0;">
                <label style="width: auto; margin-bottom: 8px;">温馨提示：</label>
                <span style="line-height: 1.6; color: #666;">
                    1. 请凭预约编号及身份证到<%= deptName %>分诊台报到；<br>
                    2. 报到时间：<%= registDate %> 上午 7:30-8:00；<br>
                    3. 如需取消预约，请提前24小时操作。
                </span>
            </div>
        </div>

        <div>
            <a href="javascript:window.print()" class="print-btn">打印详情单</a>
            <a href="myOrder.jsp" class="back-btn">返回预约列表</a>
        </div>
    </div>
</body>
</html>