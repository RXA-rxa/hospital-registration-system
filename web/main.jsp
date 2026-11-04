<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 设置页面编码
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    // 强制登录检查
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    request.setAttribute("pageTitle", "功能中心 - 阳光医院");
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
        }

        /* 简化背景 */
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

        /* 导航栏样式 */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(26, 115, 232, 0.1);
            padding: 15px 0;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 24px;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar-brand i {
            color: var(--primary-color);
        }

        .main-container {
            min-height: 100vh;
            padding-top: 80px;
        }

        .welcome-section {
            margin-bottom: 50px;
        }

        .welcome-card {
            padding: 40px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            border-radius: 20px;
            position: relative;
            overflow: hidden;
        }

        .welcome-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 20px 20px;
            opacity: 0.3;
            transform: rotate(30deg);
        }

        .welcome-title {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .welcome-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 20px;
        }

        .user-avatar {
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            margin-right: 20px;
        }

        .functions-section {
            margin-bottom: 60px;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px solid var(--primary-color);
            display: inline-block;
        }

        .function-card {
            height: 100%;
            padding: 30px 25px;
            text-align: center;
            border-radius: 18px;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .function-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: var(--gradient-primary);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
            z-index: 2;
        }

        .function-card:hover::before {
            transform: scaleX(1);
        }

        .function-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .function-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 28px;
            color: white;
            transition: all 0.3s ease;
        }

        .function-card:hover .function-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 10px 25px rgba(26, 115, 232, 0.3);
        }

        .function-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 12px;
        }

        .function-desc {
            color: var(--text-light);
            font-size: 0.95rem;
            line-height: 1.6;
        }

        .quick-stats {
            margin-top: 40px;
        }

        .stat-item {
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .user-type-badge {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 0.9rem;
            margin-left: 10px;
            backdrop-filter: blur(10px);
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            .card {
                margin: 10px;
            }

            .welcome-title {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <!-- 简化背景 -->
    <div class="wave-bg"></div>

    <!-- 导航栏 -->
    <jsp:include page="navbar.jsp" />

    <!-- 主要内容 -->
    <main class="main-container">
        <div class="container">
            <!-- 欢迎信息 -->
            <section class="welcome-section">
                <div class="card welcome-card">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <div class="d-flex align-items-center">
                                <div class="user-avatar">
                                    <i class="fas fa-user-md"></i>
                                </div>
                                <div>
                                    <h1 class="welcome-title">
                                        欢迎回来，<%= session.getAttribute("realName") %>！
                                        <span class="user-type-badge">
                                            <%
                                                String userType = (String) session.getAttribute("userType");
                                                if ("1".equals(userType)) out.print("患者");
                                                else if ("2".equals(userType)) out.print("医生");
                                                else out.print("管理员");
                                            %>
                                        </span>
                                    </h1>
                                    <p class="welcome-subtitle">
                                        今天是 <span id="currentDate"></span>，祝您工作顺利！
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <a href="index.jsp" class="btn btn-light me-2">
                                <i class="fas fa-home me-1"></i>返回首页
                            </a>
                        </div>
                    </div>
                </div>
            </section>

            <!-- 功能区域 -->
            <section class="functions-section">
                <h2 class="section-title">功能中心</h2>
                <p class="text-muted mb-4">请选择您需要的服务功能</p>

                <div class="row g-4">
                    <%
                        String currentUserType = (String) session.getAttribute("userType");

                        // 医生功能
                        if ("2".equals(currentUserType)) {
                    %>
                    <div class="col-md-6 col-lg-4">
                        <a href="doctor_view_all_depts.jsp" class="text-decoration-none">
                            <div class="card function-card">
                                <div class="function-icon">
                                    <i class="fas fa-building"></i>
                                </div>
                                <h3 class="function-title">查看所有部门</h3>
                                <p class="function-desc">浏览医院所有科室信息，了解各科室专业特色</p>
                            </div>
                        </a>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <a href="doctor_record.jsp" class="text-decoration-none">
                            <div class="card function-card">
                                <div class="function-icon">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <h3 class="function-title">科室记录管理</h3>
                                <p class="function-desc">查看并管理本科室的挂号记录和患者信息</p>
                            </div>
                        </a>
                    </div>

                    <div class="col-md-6 col-lg-4">
                        <a href="doctor_dept_edit.jsp" class="text-decoration-none">
                            <div class="card function-card">
                                <div class="function-icon">
                                    <i class="fas fa-user-cog"></i>
                                </div>
                                <h3 class="function-title">科室信息维护</h3>
                                <p class="function-desc">维护科室信息，更新科室介绍和医生信息</p>
                            </div>
                        </a>
                    </div>
                    <%
                        }
                        // 患者功能
                        else if ("1".equals(currentUserType)) {
                    %>
                    <div class="col-md-6">
                        <a href="register.jsp" class="text-decoration-none">
                            <div class="card function-card">
                                <div class="function-icon">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <h3 class="function-title">预约挂号</h3>
                                <p class="function-desc">选择科室和医生，预约就诊时间，方便快捷</p>
                            </div>
                        </a>
                    </div>

                    <div class="col-md-6">
                        <a href="patient_regist_record.jsp" class="text-decoration-none">
                            <div class="card function-card">
                                <div class="function-icon">
                                    <i class="fas fa-history"></i>
                                </div>
                                <h3 class="function-title">我的预约记录</h3>
                                <p class="function-desc">查看历史预约，管理待就诊预约</p>
                            </div>
                        </a>
                    </div>
                    <%
                        } else {
                    %>
                    <div class="col-12">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            未知的用户类型，请联系系统管理员！
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </section>

            <!-- 快速统计 -->
            <section class="quick-stats">
                <h2 class="section-title">快捷信息</h2>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="stat-item">
                            <div class="stat-number">
                                <i class="fas fa-hospital me-2"></i>2000+
                            </div>
                            <div class="stat-label">开放床位</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-item">
                            <div class="stat-number">
                                <i class="fas fa-user-md me-2"></i>500+
                            </div>
                            <div class="stat-label">专业医生</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-item">
                            <div class="stat-number">
                                <i class="fas fa-users me-2"></i>100+
                            </div>
                            <div class="stat-label">服务科室</div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="bg-white py-4 border-top mt-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0 text-muted">
                        <i class="fas fa-shield-alt me-1 text-primary"></i> 阳光医院信息管理系统
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-0 text-muted">
                        <i class="fas fa-clock me-1"></i> 系统时间: <span id="currentTime"></span>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 显示当前日期和时间
        function updateDateTime() {
            var now = new Date();

            // 格式化日期
            var year = now.getFullYear();
            var month = String(now.getMonth() + 1).padStart(2, '0');
            var day = String(now.getDate()).padStart(2, '0');
            var weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
            var weekday = weekdays[now.getDay()];

            // 格式化时间
            var hours = String(now.getHours()).padStart(2, '0');
            var minutes = String(now.getMinutes()).padStart(2, '0');
            var seconds = String(now.getSeconds()).padStart(2, '0');

            // 更新页面元素
            document.getElementById('currentDate').textContent =
                year + '年' + month + '月' + day + '日 ' + weekday;

            document.getElementById('currentTime').textContent =
                hours + ':' + minutes + ':' + seconds;
        }

        // 初始化并每秒更新一次时间
        updateDateTime();
        setInterval(updateDateTime, 1000);

        // 卡片动画效果
        document.addEventListener('DOMContentLoaded', function() {
            var cards = document.querySelectorAll('.function-card');
            cards.forEach(function(card, index) {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';

                setTimeout(function() {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 150 + 300);
            });

            // 添加点击效果
            document.querySelectorAll('.function-card').forEach(function(card) {
                card.addEventListener('click', function() {
                    var self = this;
                    self.style.transform = 'scale(0.98)';
                    setTimeout(function() {
                        self.style.transform = '';
                    }, 200);
                });
            });
        });
    </script>
</body>
</html>