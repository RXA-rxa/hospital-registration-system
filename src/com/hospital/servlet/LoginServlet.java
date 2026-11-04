package com.hospital.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import com.hospital.model.User;
import com.hospital.service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果是GET请求，跳转到登录页面
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // 如果已登录，根据角色重定向
            User user = (User) session.getAttribute("user");
            redirectByRole(response, user.getRole());
        } else {
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = userService.login(username, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setMaxInactiveInterval(30 * 60); // 30分钟

                // 根据角色重定向
                redirectByRole(response, user.getRole());
            } else {
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后再试");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }

    private void redirectByRole(HttpServletResponse response, String role)
            throws IOException {
        switch (role) {
            case "patient":
                response.sendRedirect("patient/home");
                break;
            case "doctor":
                response.sendRedirect("doctor/home");
                break;
            case "admin":
                response.sendRedirect("admin/home");
                break;
            default:
                response.sendRedirect("login?error=invalid_role");
        }
    }
}