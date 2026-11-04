<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%@ page import="java.util.UUID" %> <%-- 导入UUID用于生成唯一预约编号 --%>

<%
    // --- 核心修改：处理表单提交 (POST 请求) ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // 1. 从表单中获取所有提交的数据
        String phone = request.getParameter("phone");
        String deptIdStr = request.getParameter("deptId");
        String doctorIdStr = request.getParameter("doctorId");
        String registDate = request.getParameter("registDate");
        String timeSlot = request.getParameter("timeSlot");

        // 2. 从Session中获取当前登录患者的信息
        Integer userId = (Integer) session.getAttribute("userId");
        String realName = (String) session.getAttribute("realName");
        String idCard = (String) session.getAttribute("idCard"); // 假设登录时已将身份证存入session

        // 3. 数据校验
        if (userId == null || phone == null || phone.trim().isEmpty() || deptIdStr == null || doctorIdStr == null || registDate == null || timeSlot == null) {
            // 如果关键数据为空，则重定向回预约页面，并附带错误信息
            response.sendRedirect("register.jsp?error=invalid_data");
            return; // 终止页面继续执行
        }

        int deptId = Integer.parseInt(deptIdStr);
        int doctorId = Integer.parseInt(doctorIdStr);

        // 4. 生成唯一的预约编号
        String orderNo = "ORD" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // 5. 计算挂号费用 (这里简化为固定20元，实际可根据科室/医生级别动态计算)
        double registFee = 20.00;

        // 6. 将数据插入数据库
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO regist_order (order_no, user_id, dept_id, doctor_id, regist_date, regist_time_slot, regist_fee, order_status) VALUES (?, ?, ?, ?, ?, ?, ?, '待就诊')";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, orderNo);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, deptId);
                pstmt.setInt(4, doctorId);
                pstmt.setString(5, registDate);
                pstmt.setString(6, timeSlot);
                pstmt.setDouble(7, registFee);

                int rowsAffected = pstmt.executeUpdate();

                // 7. 如果插入成功，则重定向到成功页面
                if (rowsAffected > 0) {
                    response.sendRedirect("success.jsp?orderNo=" + orderNo);
                    return; // 终止页面继续执行
                } else {
                    // 如果插入失败，重定向回预约页面并显示错误
                    response.sendRedirect("register.jsp?error=submit_failed");
                    return;
                }
            } else {
                response.sendRedirect("register.jsp?error=db_conn_failed");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=exception");
            return;
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    // --- 页面加载 (GET 请求) ---
    request.setAttribute("pageTitle", "预约挂号");
%>
<%@ include file="header.jsp" %>

<div class="container">
    <%@ include file="navbar.jsp" %>

    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm border-0 rounded-lg">
                <div class="card-header bg-white py-3">
                    <h4 class="mb-0 text-center">
                        <i class="fas fa-calendar-plus text-primary me-2"></i>预约挂号
                    </h4>
                </div>
                <div class="card-body p-4">
                    <%-- 显示错误信息 --%>
                    <%
                        String error = request.getParameter("error");
                        if ("invalid_data".equals(error)) {
                            out.print("<div class='alert alert-danger' role='alert'>请填写完整的预约信息！</div>");
                        } else if ("submit_failed".equals(error)) {
                            out.print("<div class='alert alert-danger' role='alert'>预约提交失败，请稍后重试！</div>");
                        } else if ("db_conn_failed".equals(error)) {
                            out.print("<div class='alert alert-danger' role='alert'>数据库连接失败，请联系管理员！</div>");
                        } else if ("exception".equals(error)) {
                            out.print("<div class='alert alert-danger' role='alert'>系统发生异常，请联系管理员！</div>");
                        }
                    %>

                    <%-- 修正：从Session获取患者信息并显示 --%>
                    <%
                        String patientRealName = (String) session.getAttribute("realName");
                        String patientIdCard = (String) session.getAttribute("idCard"); // 确保登录时已存入

                        // 如果session中没有身份证信息，可以考虑从数据库查询
                        if (patientIdCard == null && session.getAttribute("userId") != null) {
                            Connection infoConn = null;
                            PreparedStatement infoPstmt = null;
                            ResultSet infoRs = null;
                            try {
                                infoConn = DBUtil.getConnection();
                                String sql = "SELECT id_card FROM user WHERE id = ?";
                                infoPstmt = infoConn.prepareStatement(sql);
                                infoPstmt.setInt(1, (Integer)session.getAttribute("userId"));
                                infoRs = infoPstmt.executeQuery();
                                if (infoRs.next()) {
                                    patientIdCard = infoRs.getString("id_card");
                                    // 存入session，避免重复查询
                                    session.setAttribute("idCard", patientIdCard);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                DBUtil.close(infoConn, infoPstmt, infoRs);
                            }
                        }
                    %>

                    <form id="registerForm" action="register.jsp" method="post">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="patientName" class="form-label">患者姓名</label>
                                <input type="text" class="form-control" id="patientName" value="<%= patientRealName != null ? patientRealName : "" %>" readonly>
                            </div>
                            <div class="col-md-6">
                                <label for="idCard" class="form-label">身份证号</label>
                                <%-- 修正：如果身份证号仍为空，允许用户填写 --%>
                                <input type="text" class="form-control" id="idCard" value="<%= patientIdCard != null ? patientIdCard : "" %>" <%= patientIdCard != null ? "readonly" : "" %>>
                                <% if (patientIdCard == null) { %>
                                    <div id="idCardHelp" class="form-text">请填写您的身份证号，以便身份核实。</div>
                                <% } %>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">联系电话</label>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="请输入您的联系电话" required>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="deptSelect" class="form-label">选择科室</label>
                                <select class="form-select" id="deptSelect" name="deptId" required>
                                    <option value="">-- 请选择科室 --</option>
                                    <%
                                        Connection deptConn = null;
                                        PreparedStatement deptPstmt = null;
                                        ResultSet deptRs = null;
                                        try {
                                            deptConn = DBUtil.getConnection();
                                            if (deptConn != null) {
                                                String deptSql = "SELECT id, dept_name FROM dept_info ORDER BY id";
                                                deptPstmt = deptConn.prepareStatement(deptSql);
                                                deptRs = deptPstmt.executeQuery();
                                                while (deptRs.next()) {
                                                    String deptId = deptRs.getString("id");
                                                    String deptName = deptRs.getString("dept_name");
                                                    out.println("<option value='" + deptId + "'>" + deptName + "</option>");
                                                }
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            DBUtil.close(deptConn, deptPstmt, deptRs);
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="doctorSelect" class="form-label">选择医生</label>
                                <select class="form-select" id="doctorSelect" name="doctorId" required>
                                    <option value="">-- 请先选择科室 --</option>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="registDate" class="form-label">预约日期</label>
                                <input type="date" class="form-control" id="registDate" name="registDate" required>
                            </div>
                            <div class="col-md-6">
                                <label for="timeSlot" class="form-label">预约时段</label>
                                <select class="form-select" id="timeSlot" name="timeSlot" required>
                                    <option value="">-- 请选择时段 --</option>
                                    <option value="上午8:00-10:00">上午8:00-10:00</option>
                                    <option value="上午10:00-12:00">上午10:00-12:00</option>
                                    <option value="下午14:00-16:00">下午14:00-16:00</option>
                                    <option value="下午16:00-18:00">下午16:00-18:00</option>
                                    <option value="晚上18:00-20:00">晚上18:00-20:00</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-lg" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                                <i class="fas fa-paper-plane me-2"></i>提交预约
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const deptSelect = document.getElementById('deptSelect');
        const doctorSelect = document.getElementById('doctorSelect');

        deptSelect.addEventListener('change', function() {
            const deptId = this.value;
            doctorSelect.innerHTML = '<option value="">-- 加载中... --</option>';

            if (deptId) {
                fetch('get_doctors_by_dept.jsp?deptId=' + deptId)
                    .then(response => response.text())
                    .then(data => {
                        doctorSelect.innerHTML = data;
                    })
                    .catch(error => {
                        console.error('Error fetching doctors:', error);
                        doctorSelect.innerHTML = '<option value="">-- 加载失败 --</option>';
                    });
            } else {
                doctorSelect.innerHTML = '<option value="">-- 请先选择科室 --</option>';
            }
        });

        // 设置最小预约日期为今天
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('registDate').min = today;
    });
</script>

<%@ include file="footer.jsp" %>