<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%
    // 设置页面编码
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    // 处理退出登录请求
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }

    request.setAttribute("pageTitle", "用户登录 - 阳光医院");
    String errorMessage = "";

    // 处理登录请求
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            errorMessage = "用户名和密码不能为空！";
        } else {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT id, real_name, user_type FROM user WHERE username = ? AND password = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("realName", rs.getString("real_name"));
                    session.setAttribute("userType", rs.getString("user_type"));
                    response.sendRedirect("main.jsp");
                    return;
                } else {
                    errorMessage = "用户名或密码错误！";
                }
            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "系统繁忙，请稍后再试！";
            } finally {
                DBUtil.close(conn, pstmt, rs);
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

        .login-container {
            width: 100%;
            max-width: 450px;
        }

        .login-card {
            padding: 40px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-logo {
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

        .login-logo i {
            font-size: 36px;
            color: white;
        }

        .login-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .login-subtitle {
            color: var(--text-light);
            font-size: 15px;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            display: block;
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

        .login-btn {
            width: 100%;
            padding: 15px;
            font-size: 16px;
            font-weight: 600;
            margin-top: 10px;
        }

        .login-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: var(--text-light);
        }

        .login-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .login-footer a:hover {
            text-decoration: underline;
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary-color);
            z-index: 10;
        }

        .form-control-with-icon {
            padding-left: 50px;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c2c7;
            color: #842029;
        }

        .floating-hospital {
            position: absolute;
            font-size: 150px;
            color: rgba(26, 115, 232, 0.05);
            pointer-events: none;
        }

        .floating-hospital:nth-child(1) {
            top: 10%;
            left: 5%;
        }

        .floating-hospital:nth-child(2) {
            bottom: 15%;
            right: 8%;
        }

        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- 背景 -->
    <div class="wave-bg"></div>

    <!-- 浮动图标 -->
    <i class="fas fa-hospital floating-hospital"></i>
    <i class="fas fa-stethoscope floating-hospital"></i>

    <!-- 登录表单 -->
    <div class="login-container">
        <div class="card login-card">
            <div class="login-header">
                <div class="login-logo">
                    <i class="fas fa-user-md"></i>
                </div>
                <h1 class="login-title">用户登录</h1>
                <p class="login-subtitle">欢迎回到阳光医院服务系统</p>
            </div>

            <% if (!errorMessage.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <form action="login.jsp" method="post" id="loginForm">
                <!-- 用户名 -->
                <div class="form-group">
                    <label for="username" class="form-label">用户名</label>
                    <div class="input-group">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" class="form-control form-control-with-icon"
                               id="username" name="username"
                               placeholder="请输入用户名" required>
                    </div>
                </div>

                <!-- 密码 -->
                <div class="form-group">
                    <label for="password" class="form-label">密码</label>
                    <div class="input-group">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" class="form-control form-control-with-icon"
                               id="password" name="password"
                               placeholder="请输入密码" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary login-btn">
                    <i class="fas fa-sign-in-alt me-2"></i>登录系统
                </button>
            </form>

            <div class="login-footer">
                <p>
                    还没有账号？
                    <a href="register_user.jsp" class="fw-bold">立即注册</a>
                    <span class="mx-2">|</span>
                    <a href="index.jsp">返回首页</a>
                </p>
                <p class="mt-2 small text-muted">
                    支持注册：患者 | 医生 | 管理员
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 表单验证
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !password) {
                e.preventDefault();
                showAlert('请输入完整的登录信息！', 'danger');
                return false;
            }

            return true;
        });

        function showAlert(message, type) {
            // 创建提示框
            const alertDiv = document.createElement('div');
            const iconClass = type === 'danger' ? 'exclamation-circle' : 'check-circle';
            alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
            alertDiv.innerHTML =
                '<i class="fas fa-' + iconClass + ' me-2"></i>' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

            // 添加到卡片顶部
            const card = document.querySelector('.login-card');
            card.insertBefore(alertDiv, card.firstChild);

            // 自动消失
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.classList.remove('show');
                    setTimeout(() => alertDiv.remove(), 150);
                }
            }, 5000);
        }

        // 输入框焦点效果
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });

            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
        });

        // 按回车键切换焦点
        document.getElementById('username').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('password').focus();
            }
        });

        // 按回车键提交表单
        document.getElementById('password').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('loginForm').submit();
            }
        });
    </script>
</body>
</html>