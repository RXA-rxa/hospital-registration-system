package com.hospital.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import com.hospital.model.*;
import com.hospital.service.RegistrationService;

@WebServlet("/patient/*")
public class PatientServlet extends HttpServlet {
    private RegistrationService registrationService = new RegistrationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Patient patient = (Patient) session.getAttribute("patient");

            if (patient == null) {
                // 加载病人信息
                // 这里需要实现从数据库加载病人信息的逻辑
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            if (action == null || action.equals("/home")) {
                // 病人主页
                List<RegistrationRecord> records = registrationService.getPatientRecords(patient.getPatientId());
                request.setAttribute("records", records);
                request.getRequestDispatcher("/jsp/patient/home.jsp").forward(request, response);
            } else if (action.equals("/registration")) {
                // 挂号页面
                List<Department> departments = registrationService.getDepartments();
                List<TimeSlot> timeSlots = registrationService.getAvailableTimeSlots();

                request.setAttribute("departments", departments);
                request.setAttribute("timeSlots", timeSlots);
                request.getRequestDispatcher("/jsp/patient/registration.jsp").forward(request, response);
            } else if (action.equals("/records")) {
                // 我的挂号记录
                List<RegistrationRecord> records = registrationService.getPatientRecords(patient.getPatientId());
                request.setAttribute("records", records);
                request.getRequestDispatcher("/jsp/patient/myRecords.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Patient patient = (Patient) session.getAttribute("patient");

        if (user == null || patient == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getPathInfo();

        if (action.equals("/register")) {
            // 提交挂号
            try {
                int doctorId = Integer.parseInt(request.getParameter("doctorId"));
                int deptId = Integer.parseInt(request.getParameter("deptId"));
                java.sql.Date registrationDate = java.sql.Date.valueOf(request.getParameter("registrationDate"));
                int timeSlotId = Integer.parseInt(request.getParameter("timeSlotId"));
                String symptoms = request.getParameter("symptoms");

                boolean success = registrationService.createRegistration(
                        patient.getPatientId(), doctorId, deptId, registrationDate, timeSlotId, symptoms
                );

                if (success) {
                    response.sendRedirect("registration?success=true");
                } else {
                    response.sendRedirect("registration?error=register_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("registration?error=system_error");
            }
        } else if (action.equals("/cancel")) {
            // 取消挂号
            try {
                int recordId = Integer.parseInt(request.getParameter("recordId"));
                boolean success = registrationService.cancelRegistration(recordId);

                if (success) {
                    response.sendRedirect("records?cancel=success");
                } else {
                    response.sendRedirect("records?error=cancel_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("records?error=system_error");
            }
        }
    }
}