<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%
    request.setAttribute("pageTitle", "我的患者");
%>
<%@ include file="header.jsp" %>

<div class="container">
    <%@ include file="navbar.jsp" %>

    <div class="row justify-content-center">
        <div class="col-md-11 col-lg-10">
            <div class="card shadow-sm border-0 rounded-lg">
                <div class="card-header bg-white py-3">
                    <h4 class="mb-0 text-center">
                        <i class="fas fa-user-md text-primary me-2"></i>我的患者
                    </h4>
                </div>
                <div class="card-body p-4">
                    <%
                        Integer userId = (Integer) session.getAttribute("userId");
                        if (userId == null || !"2".equals(session.getAttribute("userType"))) {
                            response.sendRedirect("login.jsp");
                            return;
                        }

                        Integer doctorId = null;
                        String deptName = "";
                        Connection infoConn = null;
                        PreparedStatement infoPstmt = null;
                        ResultSet infoRs = null;
                        try {
                            infoConn = DBUtil.getConnection();
                            String sql = "SELECT d.id, dept.dept_name FROM doctor_info d JOIN dept_info dept ON d.dept_id = dept.id WHERE d.user_id = ?";
                            infoPstmt = infoConn.prepareStatement(sql);
                            infoPstmt.setInt(1, userId);
                            infoRs = infoPstmt.executeQuery();
                            if (infoRs.next()) {
                                doctorId = infoRs.getInt("id");
                                deptName = infoRs.getString("dept_name");
                            }
                        } catch (Exception e) { e.printStackTrace(); } finally { DBUtil.close(infoConn, infoPstmt, infoRs); }

                        if (doctorId == null) {
                            out.print("<div class='alert alert-warning text-center' role='alert'>您尚未维护科室信息，请先前往 <a href='doctor_dept_edit.jsp'>科室信息维护</a> 页面！</div>");
                        } else {
                    %>
                    <h5 class="text-center mb-4">您所在科室：<%= deptName %></h5>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover align-middle">
                            <thead class="table-light"><tr><th>预约号</th><th>患者</th><th>电话</th><th>日期</th><th>时段</th><th>费用</th><th>状态</th></tr></thead>
                            <tbody>
                                <%
                                    Connection conn = null;
                                    PreparedStatement pstmt = null;
                                    ResultSet rs = null;
                                    boolean hasRecords = false;
                                    try {
                                        conn = DBUtil.getConnection();
                                        String sql = "SELECT ro.order_no, u.real_name, u.phone, ro.regist_date, ro.regist_time_slot, ro.regist_fee, ro.order_status FROM regist_order ro JOIN user u ON ro.user_id = u.id WHERE ro.doctor_id = ? ORDER BY ro.create_time DESC";
                                        pstmt = conn.prepareStatement(sql);
                                        pstmt.setInt(1, doctorId);
                                        rs = pstmt.executeQuery();
                                        while (rs.next()) {
                                            hasRecords = true;
                                %>
                                <tr>
                                    <td><%= rs.getString("order_no") %></td>
                                    <td><%= rs.getString("real_name") %></td>
                                    <td><%= rs.getString("phone") %></td>
                                    <td><%= rs.getString("regist_date") %></td>
                                    <td><%= rs.getString("regist_time_slot") %></td>
                                    <td>¥<%= rs.getString("regist_fee") %></td>
                                    <td><span class="badge bg-warning"><%= rs.getString("order_status") %></span></td>
                                </tr>
                                <%
                                        }
                                        if (!hasRecords) out.print("<tr><td colspan='7' class='text-center text-muted'>暂无患者挂您的号</td></tr>");
                                    } catch (Exception e) {
                                        out.print("<tr><td colspan='7' class='text-center text-danger'>查询异常: " + e.getMessage() + "</td></tr>");
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