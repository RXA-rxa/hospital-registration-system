<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 检查用户是否登录，如果未登录则跳转到登录页面
    // 这个检查放在这里，可以确保所有包含此header的页面都需要登录才能访问
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (String) request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "第一医院挂号系统" %></title>

    <!-- 1. 引入 Bootstrap CSS (提供美观的样式和渐变) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- 2. 引入 Font Awesome 图标库 (提供丰富的图标) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        /* 自定义一个渐变背景色 */
        .bg-gradient-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        /* 表格行悬停效果 */
        .table-hover-custom tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.1);
            transform: scale(1.01);
            transition: all 0.2s ease;
        }
    </style>
</head>
<body class="bg-light">