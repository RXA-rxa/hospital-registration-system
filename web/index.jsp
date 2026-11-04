<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="com.hospital.util.DBUtil" %>
<%
    // 设置页面编码
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    String hospitalDesc = "医院介绍";
    String address = "医院地址";
    String servicePhone = "服务电话";
    String registPhone = "挂号电话";
    String trafficRoute = "交通路线";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        conn = DBUtil.getConnection();
        String sql = "SELECT * FROM hospital_info LIMIT 1";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            hospitalDesc = rs.getString("hospital_desc");
            address = rs.getString("address");
            servicePhone = rs.getString("service_phone");
            registPhone = rs.getString("regist_phone");
            trafficRoute = rs.getString("traffic_route");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBUtil.close(conn, pstmt, rs);
    }
    request.setAttribute("pageTitle", "阳光医院 - 专业医疗健康服务");
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

        /* 简化的背景 */
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

        .wave {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 200%;
            height: 100px;
            background-color: rgba(26, 115, 232, 0.1);
            opacity: 0.5;
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

        /* 图标容器 */
        .icon-container {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-light) 0%, var(--primary-color) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 8px 20px rgba(26, 115, 232, 0.2);
        }

        .icon-container i {
            font-size: 28px;
            color: white;
        }

        .hero-section {
            padding: 100px 0 60px;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-light) 100%);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 25px;
            line-height: 1.2;
        }

        .hero-subtitle {
            font-size: 1.25rem;
            color: var(--text-light);
            margin-bottom: 35px;
            line-height: 1.8;
        }

        .features-section {
            padding: 80px 0;
        }

        .feature-card {
            padding: 40px 30px;
            height: 100%;
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
        }

        .feature-icon i {
            font-size: 32px;
            color: white;
        }

        .contact-section {
            padding: 60px 0 100px;
        }

        .contact-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 15px;
        }

        .contact-subtitle {
            color: var(--text-light);
            margin-bottom: 50px;
        }

        .contact-card {
            padding: 35px 25px;
            text-align: center;
            height: 100%;
        }

        .contact-info {
            margin-top: 20px;
        }

        .contact-info h4 {
            color: var(--primary-color);
            margin-bottom: 10px;
            font-size: 1.2rem;
        }

        .contact-info p {
            color: var(--text-light);
            margin-bottom: 5px;
        }

        .cta-button {
            padding: 16px 40px;
            font-size: 18px;
            font-weight: 600;
        }

        .stats-badge {
            display: inline-block;
            background: var(--gradient-primary);
            color: white;
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 30px;
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            .card {
                margin: 10px;
            }

            .hero-title {
                font-size: 2.2rem !important;
            }
        }
    </style>
</head>
<body>
    <!-- 简化后的背景 -->
    <div class="wave-bg"></div>

    <!-- 导航栏 -->
    <jsp:include page="navbar.jsp" />

    <!-- 主要内容 -->
    <main>
        <!-- 英雄区域 -->
        <section class="hero-section">
            <div class="container">
                <div class="hero-content text-center">
                    <span class="stats-badge">
                        <i class="fas fa-shield-alt me-2"></i>三级甲等医院 | 始于1950年
                    </span>
                    <h1 class="hero-title">阳光医院登录系统</h1>
                    <p class="hero-subtitle"><%= hospitalDesc %></p>
                    <div class="mt-5">
                        <a href="login.jsp" class="btn btn-primary cta-button">
                            <i class="fas fa-sign-in-alt me-2"></i>立即登录 / 注册
                        </a>
                        <a href="#contact" class="btn btn-outline-primary ms-3 cta-button">
                            <i class="fas fa-phone-alt me-2"></i>联系我们
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- 特色服务 -->
        <section class="features-section">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="card feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <h3>专业医疗团队</h3>
                            <p>拥有2000余名专业医护人员，提供全方位的医疗服务</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-laptop-medical"></i>
                            </div>
                            <h3>智能预约系统</h3>
                            <p>在线预约挂号，实时查看医生排班，方便快捷</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <h3>24小时服务</h3>
                            <p>全天候医疗服务，急诊绿色通道随时开放</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 联系信息 -->
        <section id="contact" class="contact-section">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="contact-title">联系我们</h2>
                    <p class="contact-subtitle">我们随时为您提供帮助，有任何问题欢迎咨询</p>
                </div>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="card contact-card">
                            <div class="icon-container">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="contact-info">
                                <h4>医院地址</h4>
                                <p><%= address %></p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card contact-card">
                            <div class="icon-container">
                                <i class="fas fa-phone-alt"></i>
                            </div>
                            <div class="contact-info">
                                <h4>联系电话</h4>
                                <p>服务热线: <strong><%= servicePhone %></strong></p>
                                <p>挂号专线: <strong><%= registPhone %></strong></p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card contact-card">
                            <div class="icon-container">
                                <i class="fas fa-bus"></i>
                            </div>
                            <div class="contact-info">
                                <h4>交通路线</h4>
                                <p><%= trafficRoute %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- 页脚 -->
    <footer class="bg-white py-4 border-top">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0 text-muted">
                        <i class="fas fa-copyright me-1"></i> 2024 阳光医院. 保留所有权利
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-0 text-muted">
                        <i class="fas fa-heartbeat me-1 text-danger"></i> 用心服务，健康相伴
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 简单的动画效果
        document.addEventListener('DOMContentLoaded', function() {
            // 滚动动画
            var cards = document.querySelectorAll('.card');
            cards.forEach(function(card, index) {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';

                setTimeout(function() {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // 平滑滚动
            var anchors = document.querySelectorAll('a[href^="#"]');
            anchors.forEach(function(anchor) {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    var targetId = this.getAttribute('href');
                    if(targetId === '#') return;

                    var targetElement = document.querySelector(targetId);
                    if(targetElement) {
                        window.scrollTo({
                            top: targetElement.offsetTop - 80,
                            behavior: 'smooth'
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>