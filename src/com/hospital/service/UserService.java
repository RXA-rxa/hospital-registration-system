package com.hospital.service;

import com.hospital.dao.*;
import com.hospital.model.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class UserService {
    private UserDAO userDAO = new UserDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();

    /**
     * 用户注册
     */
    public boolean registerUser(User user, Patient patient, Doctor doctor) {
        try {
            // 检查用户名是否已存在
            User existingUser = userDAO.findByUsername(user.getUsername());
            if (existingUser != null) {
                return false;
            }

            // 密码加密
            user.setPassword(encryptPassword(user.getPassword()));

            // 添加用户
            int userId = userDAO.addUser(user);
            if (userId <= 0) {
                return false;
            }

            // 获取刚插入的用户ID
            User newUser = userDAO.findByUsername(user.getUsername());
            if (newUser == null) {
                return false;
            }

            // 根据角色添加详细信息
            if ("patient".equals(user.getRole())) {
                patient.setUserId(newUser.getUserId());
                return patientDAO.addPatient(patient) > 0;
            } else if ("doctor".equals(user.getRole())) {
                doctor.setUserId(newUser.getUserId());
                return doctorDAO.addDoctor(doctor) > 0;
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 用户登录
     */
    public User login(String username, String password) {
        try {
            // 密码加密
            String encryptedPassword = encryptPassword(password);
            User user = userDAO.validateUser(username, encryptedPassword);

            if (user != null) {
                // 更新最后登录时间
                userDAO.updateLastLogin(user.getUserId());

                // 根据角色加载详细信息
                if ("patient".equals(user.getRole())) {
                    Patient patient = patientDAO.findByUserId(user.getUserId());
                    // 可以将patient信息设置到session中
                } else if ("doctor".equals(user.getRole())) {
                    Doctor doctor = doctorDAO.findByUserId(user.getUserId());
                    // 可以将doctor信息设置到session中
                }
            }

            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 修改密码
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        try {
            User user = userDAO.findById(userId);
            if (user == null) {
                return false;
            }

            // 验证旧密码
            String encryptedOldPassword = encryptPassword(oldPassword);
            if (!user.getPassword().equals(encryptedOldPassword)) {
                return false;
            }

            // 更新密码
            user.setPassword(encryptPassword(newPassword));
            return userDAO.updateUser(user) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 密码加密（MD5）
     */
    private String encryptPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();

            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return password;
        }
    }

    /**
     * 检查用户名是否可用
     */
    public boolean isUsernameAvailable(String username) {
        User user = userDAO.findByUsername(username);
        return user == null;
    }
}