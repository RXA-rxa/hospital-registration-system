<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.util.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%
    // 设置页面编码
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    request.setAttribute("pageTitle", "用户注册 - 阳光医院");

    String errorMessage = "";
    String successMessage = "";
    String username = "";
    String realName = "";
    String idCard = "";
    String phone = "";
    String userType = "1"; // 默认为患者

    // 处理注册请求
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        realName = request.getParameter("realName");
        userType = request.getParameter("userType");
        idCard = request.getParameter("idCard");
        phone = request.getParameter("phone");

        // 基本验证
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty() ||
            realName == null || realName.trim().isEmpty() ||
            userType == null || userType.trim().isEmpty()) {
            errorMessage = "请填写所有必填字段！";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "两次输入的密码不一致！";
        } else if (password.length() < 6) {
            errorMessage = "密码长度不能少于6位！";
        } else if (username.length() < 4 || username.length() > 20) {
            errorMessage = "用户名长度应为4-20位！";
        } else {
            // 检查用户名是否已存在
            Connection checkConn = null;
            PreparedStatement checkStmt = null;
            ResultSet rs = null;
            try {
                checkConn = DBUtil.getConnection();
                String checkSql = "SELECT COUNT(*) as count FROM user WHERE username = ?";
                checkStmt = checkConn.prepareStatement(checkSql);
                checkStmt.setString(1, username.trim());
                rs = checkStmt.executeQuery();

                if (rs.next() && rs.getInt("count") > 0) {
                    errorMessage = "用户名已存在，请更换其他用户名！";
                } else {
                    // 注册用户
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    try {
                        conn = DBUtil.getConnection();
                        String sql = "INSERT INTO user (username, password, user_type, real_name, id_card, phone) VALUES (?, ?, ?, ?, ?, ?)";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, username.trim());
                        pstmt.setString(2, password.trim());
                        pstmt.setInt(3, Integer.parseInt(userType));
                        pstmt.setString(4, realName.trim());
                        pstmt.setString(5, idCard != null ? idCard.trim() : "");
                        pstmt.setString(6, phone != null ? phone.trim() : "");

                        int rows = pstmt.executeUpdate();
                        if (rows > 0) {
                            successMessage = "注册成功！正在跳转到登录页面...";
                        } else {
                            errorMessage = "注册失败，请稍后重试！";
                        }
                    } catch (Exception e) {
                        errorMessage = "注册失败，数据库错误！";
                        e.printStackTrace();
                    } finally {
                        DBUtil.close(conn, pstmt, null);
                    }
                }
            } catch (Exception e) {
                errorMessage = "系统错误，请稍后重试！";
                e.printStackTrace();
            } finally {
                DBUtil.close(checkConn, checkStmt, rs);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #1a73e8;
            --primary-light: #4a9eff;
            --primary-dark: #0d47a1;
            --secondary-color: #34a853;
            --accent-color: #fbbc04;
            --light-bg: #f8fafc;
            --white: #ffffff;
            --text-dark: #2c3e50;
            --text-light: #7b8793;
            --shadow-light: rgba(0, 0, 0, 0.08);
            --shadow-medium: rgba(0, 0, 0, 0.12);
            --gradient-primary: linear-gradient(135deg, var(--primary-color), var(--primary-light));
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'PingFang SC', 'Microsoft YaHei', 'Segoe UI', sans-serif;
            background-color: var(--light-bg);
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        /* 背景 */
        .wave-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: linear-gradient(120deg, #e0f2ff 0%, #f0f9ff 100%);
            overflow: hidden;
        }

        /* 卡片样式 */
        .card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 10px 30px var(--shadow-light);
            border: 1px solid rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px var(--shadow-medium);
        }

        /* 按钮样式 */
        .btn-primary {
            background: var(--gradient-primary);
            border: none;
            border-radius: 50px;
            padding: 14px 32px;
            font-weight: 600;
            font-size: 16px;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(26, 115, 232, 0.3);
        }

        .register-container {
            width: 100%;
            max-width: 500px;
        }

        .register-card {
            padding: 40px;
        }

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-logo {
            width: 80px;
            height: 80px;
            background: var(--gradient-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 25px rgba(26, 115, 232, 0.3);
        }

        .register-logo i {
            font-size: 36px;
            color: white;
        }

        .register-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .register-subtitle {
            color: var(--text-light);
            font-size: 15px;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            display: block;
        }

        .form-label .required {
            color: #dc3545;
        }

        .form-control {
            border: 2px solid #e0e7ff;
            border-radius: 12px;
            padding: 12px 15px;
            font-size: 16px;
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(26, 115, 232, 0.1);
            outline: none;
        }

        .mb-3 {
            margin-bottom: 20px;
        }

        .user-type-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .user-type-btn {
            flex: 1;
            padding: 12px;
            border: 2px solid #e0e7ff;
            border-radius: 10px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
        }

        .user-type-btn:hover {
            border-color: var(--primary-light);
            background-color: rgba(26, 115, 232, 0.05);
        }

        .user-type-btn.active {
            border-color: var(--primary-color);
            background-color: rgba(26, 115, 232, 0.1);
            color: var(--primary-color);
            font-weight: 600;
        }

        .user-type-btn i {
            font-size: 20px;
            margin-bottom: 5px;
            display: block;
        }

        .register-btn {
            width: 100%;
            padding: 15px;
            font-size: 16px;
            font-weight: 600;
            margin-top: 10px;
        }

        .register-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: var(--text-light);
        }

        .register-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .register-footer a:hover {
            text-decoration: underline;
        }

        .field-hint {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        .password-strength {
            margin-top: 8px;
        }

        .strength-bar {
            height: 6px;
            background-color: #e9ecef;
            border-radius: 3px;
            overflow: hidden;
            margin-top: 5px;
        }

        .strength-fill {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease, background-color 0.3s ease;
            border-radius: 3px;
        }

        .strength-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 3px;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .alert-success {
            background-color: #d1e7dd;
            border-color: #badbcc;
            color: #0f5132;
        }

        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c2c7;
            color: #842029;
        }

        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- 背景 -->
    <div class="wave-bg"></div>

    <!-- 注册表单 -->
    <div class="register-container">
        <div class="card register-card">
            <div class="register-header">
                <div class="register-logo">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h1 class="register-title">用户注册</h1>
                <p class="register-subtitle">请填写以下信息完成注册</p>
            </div>

            <% if (!errorMessage.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <% if (!successMessage.isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <script>
                    setTimeout(function() {
                        window.location.href = 'login.jsp';
                    }, 2000);
                </script>
            <% } %>

            <form action="register_user.jsp" method="post" id="registerForm">
                <!-- 用户名 -->
                <div class="form-group">
                    <label for="username" class="form-label">
                        登录账号 <span class="required">*</span>
                    </label>
                    <input type="text" class="form-control" id="username" name="username"
                           placeholder="请设置登录账号（4-20位）"
                           value="<%= username %>" required>
                    <div class="field-hint">用于登录系统的唯一标识</div>
                </div>

                <!-- 密码 -->
                <div class="form-group">
                    <label for="password" class="form-label">
                        登录密码 <span class="required">*</span>
                    </label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="请设置登录密码（至少6位）" required
                           oninput="checkPasswordStrength()">
                    <div class="password-strength">
                        <div class="strength-bar">
                            <div class="strength-fill" id="strengthFill"></div>
                        </div>
                        <div class="strength-text" id="strengthText">密码强度：弱</div>
                    </div>
                </div>

                <!-- 确认密码 -->
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">
                        确认密码 <span class="required">*</span>
                    </label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                           placeholder="请再次输入密码" required>
                </div>

                <!-- 真实姓名 -->
                <div class="form-group">
                    <label for="realName" class="form-label">
                        真实姓名 <span class="required">*</span>
                    </label>
                    <input type="text" class="form-control" id="realName" name="realName"
                           placeholder="请输入真实姓名"
                           value="<%= realName %>" required>
                    <div class="field-hint">请填写真实姓名，便于系统识别</div>
                </div>

                <!-- 用户类型 -->
                <div class="form-group">
                    <label class="form-label">
                        用户类型 <span class="required">*</span>
                    </label>
                    <div class="user-type-buttons">
                        <button type="button" class="user-type-btn <%= "1".equals(userType) ? "active" : "" %>"
                                onclick="selectUserType('1')">
                            <i class="fas fa-user-injured"></i>
                            患者
                        </button>
                        <button type="button" class="user-type-btn <%= "2".equals(userType) ? "active" : "" %>"
                                onclick="selectUserType('2')">
                            <i class="fas fa-user-md"></i>
                            医生
                        </button>
                        <button type="button" class="user-type-btn <%= "3".equals(userType) ? "active" : "" %>"
                                onclick="selectUserType('3')">
                            <i class="fas fa-user-shield"></i>
                            管理员
                        </button>
                    </div>
                    <input type="hidden" id="userType" name="userType" value="<%= userType %>">
                    <div class="field-hint" id="userTypeHint">
                        <%
                            if ("1".equals(userType)) {
                                out.print("患者：可以预约挂号、查看记录");
                            } else if ("2".equals(userType)) {
                                out.print("医生：可以管理科室、查看记录");
                            } else {
                                out.print("管理员：可以管理所有系统功能");
                            }
                        %>
                    </div>
                </div>

                <!-- 身份证号 -->
                <div class="form-group">
                    <label for="idCard" class="form-label">身份证号</label>
                    <input type="text" class="form-control" id="idCard" name="idCard"
                           placeholder="请输入18位身份证号"
                           value="<%= idCard %>">
                    <div class="field-hint">可选，用于身份验证</div>
                </div>

                <!-- 手机号 -->
                <div class="form-group">
                    <label for="phone" class="form-label">手机号</label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           placeholder="请输入11位手机号"
                           value="<%= phone %>">
                    <div class="field-hint">可选，用于接收通知</div>
                </div>

                <button type="submit" class="btn btn-primary register-btn">
                    <i class="fas fa-user-plus me-2"></i>完成注册
                </button>
            </form>

            <div class="register-footer">
                <p>
                    已有账号？
                    <a href="login.jsp">返回登录</a>
                    <span class="mx-2">|</span>
                    <a href="index.jsp">返回首页</a>
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 选择用户类型
        function selectUserType(type) {
            // 更新按钮状态
            document.querySelectorAll('.user-type-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');

            // 更新隐藏字段的值
            document.getElementById('userType').value = type;

            // 更新提示信息
            const hintElement = document.getElementById('userTypeHint');
            if (type === '1') {
                hintElement.textContent = '患者：可以预约挂号、查看记录';
            } else if (type === '2') {
                hintElement.textContent = '医生：可以管理科室、查看记录';
            } else {
                hintElement.textContent = '管理员：可以管理所有系统功能';
            }
        }

        // 检查密码强度
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');

            let strength = 0;
            let color = '#dc3545'; // 红色
            let text = '密码强度：弱';

            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            switch (strength) {
                case 0:
                case 1:
                    color = '#dc3545';
                    text = '密码强度：弱';
                    break;
                case 2:
                case 3:
                    color = '#ffc107';
                    text = '密码强度：中';
                    break;
                case 4:
                case 5:
                    color = '#28a745';
                    text = '密码强度：强';
                    break;
            }

            const percentage = (strength / 5) * 100;
            strengthFill.style.width = percentage + '%';
            strengthFill.style.backgroundColor = color;
            strengthText.textContent = text;
            strengthText.style.color = color;
        }

        // 表单验证
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();
            const realName = document.getElementById('realName').value.trim();

            // 验证用户名
            if (username.length < 4 || username.length > 20) {
                e.preventDefault();
                alert('用户名长度应为4-20位！');
                return false;
            }

            // 验证密码
            if (password.length < 6) {
                e.preventDefault();
                alert('密码长度不能少于6位！');
                return false;
            }

            // 验证确认密码
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('两次输入的密码不一致！');
                return false;
            }

            // 验证真实姓名
            if (!realName) {
                e.preventDefault();
                alert('请输入真实姓名！');
                return false;
            }

            // 验证身份证号（如果填写了）
            const idCard = document.getElementById('idCard').value.trim();
            if (idCard && idCard.length !== 18) {
                e.preventDefault();
                alert('身份证号应为18位！');
                return false;
            }

            // 验证手机号（如果填写了）
            const phone = document.getElementById('phone').value.trim();
            if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
                e.preventDefault();
                alert('请输入有效的手机号！');
                return false;
            }

            return true;
        });

        // 输入框实时验证
        document.getElementById('idCard').addEventListener('input', function() {
            const idCard = this.value.trim();
            if (idCard && idCard.length !== 18) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#e0e7ff';
            }
        });

        document.getElementById('phone').addEventListener('input', function() {
            const phone = this.value.trim();
            if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#e0e7ff';
            }
        });
    </script>
</body>
</html>