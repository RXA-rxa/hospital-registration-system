<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%
    // 验证医生登录
    if (session.getAttribute("userId") == null || !"2".equals(session.getAttribute("userType"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    request.setAttribute("pageTitle", "查看所有部门");
%>
<%@ include file="header.jsp" %>

<div class="container">
    <%@ include file="navbar.jsp" %>

    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card shadow-sm border-0 rounded-lg mb-5">
                <div class="card-body text-center py-4">
                    <h2 class="mb-0">系统所有科室信息</h2>
                </div>
            </div>

            <div class="card shadow-sm border-0 rounded-lg">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col">科室ID</th>
                                    <th scope="col">科室名称</th>
                                    <th scope="col">科室简介</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    Connection conn = null;
                                    PreparedStatement pstmt = null;
                                    ResultSet rs = null;
                                    try {
                                        conn = DBUtil.getConnection();
                                        String sql = "SELECT id, dept_name, dept_desc FROM dept_info ORDER BY id ASC";
                                        pstmt = conn.prepareStatement(sql);
                                        rs = pstmt.executeQuery();

                                        boolean hasData = false;
                                        while (rs.next()) {
                                            hasData = true;
                                %>
                                <tr>
                                    <td><%= rs.getInt("id") %></td>
                                    <td><%= rs.getString("dept_name") %></td>
                                    <td><%= rs.getString("dept_desc") != null ? rs.getString("dept_desc") : "无" %></td>
                                </tr>
                                <%
                                        }
                                        if (!hasData) {
                                %>
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-4">暂无科室信息</td>
                                </tr>
                                <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                %>
                                <tr>
                                    <td colspan="3" class="text-center text-danger py-4">数据加载失败: <%= e.getMessage() %></td>
                                </tr>
                                <%
                                    } finally {
                                        DBUtil.close(conn, pstmt, rs);
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>