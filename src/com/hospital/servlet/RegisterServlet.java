package com.hospital.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import com.hospital.model.*;
import com.hospital.service.UserService;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // 验证密码是否一致
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        // 创建用户对象
        User user = new User(username, password, role);
        user.setEmail(email);
        user.setPhone(phone);

        Patient patient = null;
        Doctor doctor = null;

        try {
            if ("patient".equals(role)) {
                String name = request.getParameter("name");
                String gender = request.getParameter("gender");
                int age = Integer.parseInt(request.getParameter("age"));
                String idCard = request.getParameter("idCard");
                String address = request.getParameter("address");

                patient = new Patient(name, gender, age, idCard, address);
            } else if ("doctor".equals(role)) {
                String name = request.getParameter("name");
                String gender = request.getParameter("gender");
                String title = request.getParameter("title");
                String specialty = request.getParameter("specialty");
                int deptId = Integer.parseInt(request.getParameter("deptId"));

                doctor = new Doctor(name, gender, title, specialty, deptId);
            }

            // 注册用户
            boolean success = userService.registerUser(user, patient, doctor);
            if (success) {
                response.sendRedirect("login?register=success");
            } else {
                request.setAttribute("error", "注册失败，用户名可能已存在");
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "注册失败，系统错误");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }
}