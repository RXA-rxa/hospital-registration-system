package com.hospital.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import com.google.gson.Gson;
import com.hospital.model.Doctor;
import com.hospital.service.RegistrationService;

@WebServlet("/api/*")
public class RegistrationServlet extends HttpServlet {
    private RegistrationService registrationService = new RegistrationService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getPathInfo();

        try {
            if (action.equals("/doctors")) {
                // 获取科室下的医生列表
                String deptIdParam = request.getParameter("deptId");
                if (deptIdParam != null) {
                    int deptId = Integer.parseInt(deptIdParam);
                    List<Doctor> doctors = registrationService.getDoctorsByDepartment(deptId);
                    out.print(gson.toJson(doctors));
                } else {
                    out.print("[]");
                }
            } else if (action.equals("/timeslots")) {
                // 获取时间段列表
                // 实现获取时间段的逻辑
                out.print("[]");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"系统错误\"}");
        } finally {
            out.flush();
        }
    }
}