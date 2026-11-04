package com.hospital.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/patient/*", "/doctor/*", "/admin/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化代码
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // 允许访问的公共资源
        String[] publicResources = {
                contextPath + "/login",
                contextPath + "/register",
                contextPath + "/logout",
                contextPath + "/css/",
                contextPath + "/js/",
                contextPath + "/images/",
                contextPath + "/api/"
        };

        // 检查是否是公共资源
        boolean isPublicResource = false;
        for (String resource : publicResources) {
            if (requestURI.startsWith(resource)) {
                isPublicResource = true;
                break;
            }
        }

        // 如果是公共资源或已登录，则放行
        if (isPublicResource || (session != null && session.getAttribute("user") != null)) {
            // 检查权限
            if (session != null && session.getAttribute("user") != null) {
                String role = (String) session.getAttribute("role");

                // 检查角色权限
                if (requestURI.startsWith(contextPath + "/patient/") && !"patient".equals(role)) {
                    httpResponse.sendRedirect(contextPath + "/login?error=no_permission");
                    return;
                }
                if (requestURI.startsWith(contextPath + "/doctor/") && !"doctor".equals(role)) {
                    httpResponse.sendRedirect(contextPath + "/login?error=no_permission");
                    return;
                }
                if (requestURI.startsWith(contextPath + "/admin/") && !"admin".equals(role)) {
                    httpResponse.sendRedirect(contextPath + "/login?error=no_permission");
                    return;
                }
            }

            chain.doFilter(request, response);
        } else {
            // 未登录，重定向到登录页面
            httpResponse.sendRedirect(contextPath + "/login?error=not_logged_in");
        }
    }

    @Override
    public void destroy() {
        // 清理资源
    }
}