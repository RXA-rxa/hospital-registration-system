<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%
    // 设置页面标题，这个标题会在 header.jsp 中被使用
    request.setAttribute("pageTitle", "我的预约记录");
%>
<%@ include file="header.jsp" %>

<div class="container">
    <%@ include file="navbar.jsp" %> <!-- 引入顶部导航栏 -->

    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card shadow-sm border-0 rounded-lg">
                <div class="card-header bg-white py-3">
                    <h4 class="mb-0 text-center">
                        <i class="fas fa-calendar-check text-primary me-2"></i>我的预约记录
                    </h4>
                </div>
                <div class="card-body p-4">
                    <%
                        // 验证和查询逻辑保持不变，只是修改了HTML渲染部分
                        Integer userId = (Integer) session.getAttribute("userId");
                        String userType = (String) session.getAttribute("userType");

                        if (userId == null || !"1".equals(userType)) {
                            // header.jsp 已经做了登录检查，这里可以简化
                            out.print("<div class='alert alert-danger text-center' role='alert'>请先以患者身份登录！</div>");
                            return;
                        }

                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        boolean hasRecords = false;

                        try {
                            conn = DBUtil.getConnection();
                            if (conn != null) {
                                String sql = "SELECT ro.order_no, ro.regist_date, ro.regist_time_slot, ro.regist_fee, ro.order_status, d.dept_name, doc_u.real_name AS doctor_name FROM regist_order ro JOIN dept_info d ON ro.dept_id = d.id LEFT JOIN doctor_info di ON ro.doctor_id = di.id LEFT JOIN user doc_u ON di.user_id = doc_u.id WHERE ro.user_id = ? ORDER BY ro.create_time DESC";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setInt(1, userId);
                                rs = pstmt.executeQuery();

                                if (rs.next()) {
                                    hasRecords = true;
                    %>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-hover-custom align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>预约编号</th>
                                    <th>预约科室</th>
                                    <th>接诊医生</th>
                                    <th>预约日期</th>
                                    <th>预约时段</th>
                                    <th>挂号费用</th>
                                    <th>预约状态</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% do { %>
                                <tr>
                                    <td><%= rs.getString("order_no") %></td>
                                    <td><%= rs.getString("dept_name") %></td>
                                    <td><%= (rs.getString("doctor_name") != null) ? rs.getString("doctor_name") : "（系统安排）" %></td>
                                    <td><%= rs.getString("regist_date") %></td>
                                    <td><%= rs.getString("regist_time_slot") %></td>
                                    <td>¥<%= rs.getString("regist_fee") %></td>
                                    <td>
                                        <span class="badge bg-warning"><%= rs.getString("order_status") %></span>
                                    </td>
                                </tr>
                                <% } while (rs.next()); %>
                            </tbody>
                        </table>
                    </div>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            out.print("<div class='alert alert-danger text-center' role='alert'>查询预约记录时发生错误: " + e.getMessage() + "</div>");
                            e.printStackTrace();
                        } finally {
                            DBUtil.close(conn, pstmt, rs);
                        }

                        if (!hasRecords) {
                    %>
                    <div class="text-center py-5">
                        <i class="fas fa-calendar-times text-secondary" style="font-size: 60px;"></i>
                        <h5 class="mt-3 text-secondary">您还没有任何预约记录</h5>
                        <a href="register.jsp" class="btn btn-primary mt-4">
                            <i class="fas fa-plus me-1"></i>立即预约
                        </a>
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