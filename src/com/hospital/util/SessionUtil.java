package com.hospital.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.hospital.model.User;

public class SessionUtil {

    /**
     * 检查用户是否登录
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user") != null;
    }

    /**
     * 获取当前登录用户
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }

    /**
     * 获取当前用户角色
     */
    public static String getCurrentRole(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null ? user.getRole() : null;
    }

    /**
     * 检查用户是否有指定角色
     */
    public static boolean hasRole(HttpServletRequest request, String role) {
        String currentRole = getCurrentRole(request);
        return currentRole != null && currentRole.equals(role);
    }

    /**
     * 检查用户是否有指定角色之一
     */
    public static boolean hasAnyRole(HttpServletRequest request, String... roles) {
        String currentRole = getCurrentRole(request);
        if (currentRole == null) {
            return false;
        }
        for (String role : roles) {
            if (currentRole.equals(role)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 设置Session属性
     */
    public static void setSessionAttribute(HttpServletRequest request, String key, Object value) {
        HttpSession session = request.getSession();
        session.setAttribute(key, value);
    }

    /**
     * 获取Session属性
     */
    public static Object getSessionAttribute(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false);
        return session != null ? session.getAttribute(key) : null;
    }

    /**
     * 移除Session属性
     */
    public static void removeSessionAttribute(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(key);
        }
    }

    /**
     * 获取Session ID
     */
    public static String getSessionId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? session.getId() : null;
    }
}