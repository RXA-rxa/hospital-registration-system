<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 设置页面编码
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
%>
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <i class="fas fa-hospital"></i>
            阳光医院
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <i class="fas fa-bars"></i>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="index.jsp">首页</a>
                </li>
                <% if (session.getAttribute("userId") != null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="main.jsp">功能中心</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>
                            <%= session.getAttribute("realName") != null ? session.getAttribute("realName") : "用户" %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>个人资料</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="login.jsp?action=logout">
                                <i class="fas fa-sign-out-alt me-2"></i>退出登录
                            </a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">登录</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary ms-2" href="login.jsp">立即注册</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>