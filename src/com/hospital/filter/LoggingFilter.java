package com.hospital.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Date;

@WebFilter("/*")
public class LoggingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("LoggingFilter初始化完成");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();
        String remoteAddr = httpRequest.getRemoteAddr();

        long startTime = System.currentTimeMillis();

        // 记录请求开始
        System.out.println(String.format("[%s] %s %s from %s",
                new Date(), method, requestURI, remoteAddr));

        // 继续执行过滤器链
        chain.doFilter(request, response);

        // 记录请求结束和处理时间
        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;

        System.out.println(String.format("[%s] %s %s completed in %d ms",
                new Date(), method, requestURI, duration));
    }

    @Override
    public void destroy() {
        System.out.println("LoggingFilter销毁");
    }
}