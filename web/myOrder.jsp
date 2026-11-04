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
    <title>我的预约 - 挂号系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f7fa; color: #333; font-family: "Microsoft YaHei", sans-serif; font-size: 14px; }
        .header {
            background: #2f5496; color: #fff; padding: 15px 0; text-align: center;
            font-size: 22px; font-weight: bold; box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            position: sticky; top: 0; z-index: 999;
        }
        .container {
            width: 90%; max-width: 1000px; margin: 30px auto; background: #fff;
            padding: 30px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .top-bar {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;
        }
        .back a {
            color: #2f5496; text-decoration: none; display: inline-flex; align-items: center;
        }
        .back a::before { content: "←"; margin-right: 5px; }
        .title {
            font-size: 18px; color: #2f5496; font-weight: bold;
        }
        .order-table {
            width: 100%; border-collapse: collapse; margin-top: 20px;
        }
        .order-table th {
            background: #e8f0fe; color: #2f5496; padding: 12px; text-align: left;
            border-bottom: 2px solid #d1e0fe; font-size: 14px;
        }
        .order-table td {
            padding: 15px; border-bottom: 1px solid #f0f0f0; color: #666;
        }
        .order-table tr:hover { background: #f8f9fa; }
        .order-no { color: #2f5496; font-weight: 500; }
        .status-normal { color: #155724; background: #d4edda; padding: 3px 8px; border-radius: 10px; font-size: 12px; }
        .status-cancel { color: #721c24; background: #f8d7da; padding: 3px 8px; border-radius: 10px; font-size: 12px; }
        .opt-btn {
            display: inline-block; padding: 6px 12px; color: #fff; text-decoration: none;
            border-radius: 4px; font-size: 12px; margin-right: 5px;
        }
        .cancel-btn { background: #dc3545; }
        .detail-btn { background: #2f5496; }
        .no-order {
            text-align: center; padding: 50px 0; color: #999; font-size: 16px;
        }
        .no-order i { font-size: 40px; margin-bottom: 10px; display: block; }
    </style>
</head>
<body>
    <div class="header">我的预约记录</div>
    <div class="container">
        <div class="top-bar">
            <div class="back"><a href="index.jsp">返回首页</a></div>
            <div class="title">个人预约查询</div>
        </div>

        <%
            // 处理取消预约请求
            String cancelOrderNo = request.getParameter("cancelNo");
            if (cancelOrderNo != null && !cancelOrderNo.trim().isEmpty()) {
                Connection conn = null;
                PreparedStatement pstmt = null;
                try {
                    conn = DBUtil.getConnection();
                    String sql = "UPDATE regist_order SET order_status = '已取消' WHERE order_no = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, cancelOrderNo);
                    pstmt.executeUpdate();
                    // 刷新页面
                    response.sendRedirect("myOrder.jsp");
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    DBUtil.close(conn, pstmt);
                }
            }

            // 查询所有预约记录
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean hasOrder = false;
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT * FROM regist_order ORDER BY create_time DESC";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
        %>

        <table class="order-table">
            <thead>
                <tr>
                    <th>预约编号</th>
                    <th>就诊科室</th>
                    <th>预约医生</th>
                    <th>患者姓名</th>
                    <th>预约日期</th>
                    <th>预约状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        hasOrder = true;
                        String orderNo = rs.getString("order_no");
                        String deptName = rs.getString("dept_name");
                        String doctorName = rs.getString("doctor_name");
                        String patientName = rs.getString("patient_name");
                        String registDate = rs.getString("regist_date");
                        String orderStatus = rs.getString("order_status");
                %>
                <tr>
                    <td class="order-no"><%= orderNo %></td>
                    <td><%= deptName %></td>
                    <td><%= doctorName %></td>
                    <td><%= patientName %></td>
                    <td><%= registDate %></td>
                    <td>
                        <% if ("待就诊".equals(orderStatus)) { %>
                            <span class="status-normal"><%= orderStatus %></span>
                        <% } else { %>
                            <span class="status-cancel"><%= orderStatus %></span>
                        <% } %>
                    </td>
                    <td>
                        <a href="orderDetail.jsp?orderNo=<%= orderNo %>" class="opt-btn detail-btn">详情</a>
                        <% if ("待就诊".equals(orderStatus)) { %>
                            <a href="myOrder.jsp?cancelNo=<%= orderNo %>" class="opt-btn cancel-btn" onclick="return confirm('确认取消该预约吗？取消后无法恢复！')">取消</a>
                        <% } %>
                    </td>
                </tr>
                <%
                    }
                    // 若无预约记录
                    if (!hasOrder) {
                %>
                <tr>
                    <td colspan="7" class="no-order">
                        <i>📄</i>
                        暂无预约记录，请先进行挂号预约
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }
        %>
    </div>
</body>
</html>