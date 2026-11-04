package com.hospital.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import com.hospital.model.*;
import com.hospital.service.RegistrationService;

@WebServlet("/doctor/*")
public class DoctorServlet extends HttpServlet {
    private RegistrationService registrationService = new RegistrationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Doctor doctor = (Doctor) session.getAttribute("doctor");

            if (doctor == null) {
                // 加载医生信息
                // 这里需要实现从数据库加载医生信息的逻辑
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            if (action == null || action.equals("/home")) {
                // 医生主页
                List<RegistrationRecord> records = registrationService.getDoctorRecords(
                        doctor.getDoctorId(), null, null);
                request.setAttribute("records", records);
                request.getRequestDispatcher("/jsp/doctor/home.jsp").forward(request, response);
            } else if (action.equals("/records")) {
                // 挂号记录管理
                String filterType = request.getParameter("filterType");
                String filterValue = request.getParameter("filterValue");

                List<RegistrationRecord> records = registrationService.getDoctorRecords(
                        doctor.getDoctorId(), filterType, filterValue);
                request.setAttribute("records", records);
                request.getRequestDispatcher("/jsp/doctor/viewRecords.jsp").forward(request, response);
            } else if (action.equals("/dept")) {
                // 科室管理
                Department dept = doctor.getDepartment();
                List<Doctor> doctors = registrationService.getDoctorsByDepartment(dept.getDeptId());
                request.setAttribute("department", dept);
                request.setAttribute("doctors", doctors);
                request.getRequestDispatcher("/jsp/doctor/manageDept.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Doctor doctor = (Doctor) session.getAttribute("doctor");

        if (user == null || doctor == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getPathInfo();

        if (action.equals("/confirm")) {
            // 确认挂号
            try {
                int recordId = Integer.parseInt(request.getParameter("recordId"));
                boolean success = registrationService.confirmRegistration(recordId);

                if (success) {
                    response.sendRedirect("records?confirm=success");
                } else {
                    response.sendRedirect("records?error=confirm_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("records?error=system_error");
            }
        } else if (action.equals("/complete")) {
            // 完成就诊
            try {
                int recordId = Integer.parseInt(request.getParameter("recordId"));
                boolean success = registrationService.completeRegistration(recordId);

                if (success) {
                    response.sendRedirect("records?complete=success");
                } else {
                    response.sendRedirect("records?error=complete_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("records?error=system_error");
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
        } else if (action.equals("/updateDept")) {
            // 更新科室信息
            try {
                String deptName = request.getParameter("deptName");
                String description = request.getParameter("description");
                String address = request.getParameter("address");

                Department dept = doctor.getDepartment();
                dept.setDeptName(deptName);
                dept.setDescription(description);
                dept.setAddress(address);

                // 这里需要实现更新科室信息的DAO方法
                // boolean success = departmentDAO.updateDepartment(dept);

                response.sendRedirect("dept?update=success");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dept?error=update_failed");
            }
        }
    }
}