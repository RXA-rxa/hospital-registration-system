<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%
    request.setAttribute("pageTitle", "科室挂号记录");
%>
<%@ include file="header.jsp" %>

<div class="container">
    <%@ include file="navbar.jsp" %>

    <div class="row justify-content-center">
        <div class="col-md-11 col-lg-10">
            <div class="card shadow-sm border-0 rounded-lg">
                <div class="card-header bg-white py-3">
                    <h4 class="mb-0 text-center">
                        <i class="fas fa-building text-primary me-2"></i>科室挂号记录
                    </h4>
                </div>
                <div class="card-body p-4">
                    <%
                        Integer userId = (Integer) session.getAttribute("userId");
                        if (userId == null || !"2".equals(session.getAttribute("userType"))) {
                            response.sendRedirect("login.jsp");
                            return;
                        }

                        Integer deptId = null;
                        String deptName = "";
                        Connection infoConn = null;
                        PreparedStatement infoPstmt = null;
                        ResultSet infoRs = null;
                        try {
                            infoConn = DBUtil.getConnection();
                            String sql = "SELECT d.dept_id, dept.dept_name FROM doctor_info d JOIN dept_info dept ON d.dept_id = dept.id WHERE d.user_id = ?";
                            infoPstmt = infoConn.prepareStatement(sql);
                            infoPstmt.setInt(1, userId);
                            infoRs = infoPstmt.executeQuery();
                            if (infoRs.next()) {
                                deptId = infoRs.getInt("dept_id");
                                deptName = infoRs.getString("dept_name");
                            }
                        } catch (Exception e) { e.printStackTrace(); } finally { DBUtil.close(infoConn, infoPstmt, infoRs); }

                        if (deptId == null) {
                            out.print("<div class='alert alert-warning text-center' role='alert'>您尚未维护科室信息，请先前往 <a href='doctor_dept_edit.jsp'>科室信息维护</a> 页面！</div>");
                        } else {
                    %>
                    <h5 class="text-center mb-4">科室：<%= deptName %></h5>

                    <!-- 筛选表单 -->
                    <form action="doctor_record.jsp" method="get" class="row g-3 mb-4">
                        <div class="col-md-3">
                            <label for="filterDate" class="form-label">预约日期</label>
                            <input type="date" class="form-control" id="filterDate" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>">
                        </div>
                        <div class="col-md-3">
                            <label for="filterTimeSlot" class="form-label">预约时段</label>
                            <select class="form-select" id="filterTimeSlot" name="timeSlot">
                                <option value="">全部时段</option>
                                <option value="上午8:00-10:00" <%= "上午8:00-10:00".equals(request.getParameter("timeSlot")) ? "selected" : "" %>>上午8:00-10:00</option>
                                <option value="上午10:00-12:00" <%= "上午10:00-12:00".equals(request.getParameter("timeSlot")) ? "selected" : "" %>>上午10:00-12:00</option>
                                <option value="下午14:00-16:00" <%= "下午14:00-16:00".equals(request.getParameter("timeSlot")) ? "selected" : "" %>>下午14:00-16:00</option>
                                <option value="下午16:00-18:00" <%= "下午16:00-18:00".equals(request.getParameter("timeSlot")) ? "selected" : "" %>>下午16:00-18:00</option>
                                <option value="晚上18:00-20:00" <%= "晚上18:00-20:00".equals(request.getParameter("timeSlot")) ? "selected" : "" %>>晚上18:00-20:00</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filterStatus" class="form-label">预约状态</label>
                            <select class="form-select" id="filterStatus" name="status">
                                <option value="">全部状态</option>
                                <option value="待就诊" <%= "待就诊".equals(request.getParameter("status")) ? "selected" : "" %>>待就诊</option>
                                <option value="已就诊" <%= "已就诊".equals(request.getParameter("status")) ? "selected" : "" %>>已就诊</option>
                                <option value="已取消" <%= "已取消".equals(request.getParameter("status")) ? "selected" : "" %>>已取消</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">查询</button>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-striped table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>预约号</th><th>患者</th><th>电话</th><th>接诊医生</th><th>日期</th><th>时段</th><th>费用</th><th>状态</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    Connection conn = null;
                                    PreparedStatement pstmt = null;
                                    ResultSet rs = null;
                                    boolean hasRecords = false;
                                    try {
                                        conn = DBUtil.getConnection();
                                        StringBuilder sqlBuilder = new StringBuilder();
                                        sqlBuilder.append("SELECT ro.order_no, u.real_name, u.phone, doc_u.real_name AS doctor_name, ro.regist_date, ro.regist_time_slot, ro.regist_fee, ro.order_status ");
                                        sqlBuilder.append("FROM regist_order ro ");
                                        sqlBuilder.append("JOIN user u ON ro.user_id = u.id ");
                                        sqlBuilder.append("LEFT JOIN doctor_info di ON ro.doctor_id = di.id ");
                                        sqlBuilder.append("LEFT JOIN user doc_u ON di.user_id = doc_u.id ");
                                        sqlBuilder.append("WHERE ro.dept_id = ? ");

                                        String date = request.getParameter("date");
                                        String timeSlot = request.getParameter("timeSlot");
                                        String status = request.getParameter("status");

                                        if (date != null && !date.trim().isEmpty()) sqlBuilder.append("AND ro.regist_date = ? ");
                                        if (timeSlot != null && !timeSlot.trim().isEmpty()) sqlBuilder.append("AND ro.regist_time_slot = ? ");
                                        if (status != null && !status.trim().isEmpty()) sqlBuilder.append("AND ro.order_status = ? ");

                                        sqlBuilder.append("ORDER BY ro.create_time DESC");

                                        pstmt = conn.prepareStatement(sqlBuilder.toString());
                                        int paramIndex = 1;
                                        pstmt.setInt(paramIndex++, deptId);
                                        if (date != null && !date.trim().isEmpty()) pstmt.setString(paramIndex++, date);
                                        if (timeSlot != null && !timeSlot.trim().isEmpty()) pstmt.setString(paramIndex++, timeSlot);
                                        if (status != null && !status.trim().isEmpty()) pstmt.setString(paramIndex++, status);

                                        rs = pstmt.executeQuery();
                                        while (rs.next()) {
                                            hasRecords = true;
                                %>
                                <tr>
                                    <td><%= rs.getString("order_no") %></td>
                                    <td><%= rs.getString("real_name") %></td>
                                    <td><%= rs.getString("phone") %></td>
                                    <td><%= rs.getString("doctor_name") != null ? rs.getString("doctor_name") : "未分配" %></td>
                                    <td><%= rs.getString("regist_date") %></td>
                                    <td><%= rs.getString("regist_time_slot") %></td>
                                    <td>¥<%= rs.getString("regist_fee") %></td>
                                    <td><span class="badge <%= "待就诊".equals(rs.getString("order_status")) ? "bg-warning" : ("已就诊".equals(rs.getString("order_status")) ? "bg-success" : "bg-secondary") %>"><%= rs.getString("order_status") %></span></td>
                                </tr>
                                <%
                                        }
                                        if (!hasRecords) out.print("<tr><td colspan='8' class='text-center text-muted'>暂无符合条件的挂号记录</td></tr>");
                                    } catch (Exception e) {
                                        out.print("<tr><td colspan='8' class='text-center text-danger'>查询异常: " + e.getMessage() + "</td></tr>");
                                    } finally { DBUtil.close(conn, pstmt, rs); }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="footer.jsp" %>