package com.hospital.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    /**
     * 验证用户名（4-20位字母数字下划线）
     */
    public static boolean isValidUsername(String username) {
        if (StringUtil.isEmpty(username)) {
            return false;
        }
        Pattern pattern = Pattern.compile("^[a-zA-Z0-9_]{4,20}$");
        return pattern.matcher(username).matches();
    }

    /**
     * 验证密码（6-20位，包含字母和数字）
     */
    public static boolean isValidPassword(String password) {
        if (StringUtil.isEmpty(password)) {
            return false;
        }
        if (password.length() < 6 || password.length() > 20) {
            return false;
        }
        // 必须包含字母和数字
        boolean hasLetter = false;
        boolean hasDigit = false;

        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) {
                hasLetter = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            }
        }

        return hasLetter && hasDigit;
    }

    /**
     * 验证邮箱
     */
    public static boolean isValidEmail(String email) {
        if (StringUtil.isEmpty(email)) {
            return false;
        }
        Pattern pattern = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
        return pattern.matcher(email).matches();
    }

    /**
     * 验证手机号
     */
    public static boolean isValidPhone(String phone) {
        if (StringUtil.isEmpty(phone)) {
            return false;
        }
        Pattern pattern = Pattern.compile("^1[3-9]\\d{9}$");
        return pattern.matcher(phone).matches();
    }

    /**
     * 验证身份证号（简化版）
     */
    public static boolean isValidIdCard(String idCard) {
        if (StringUtil.isEmpty(idCard)) {
            return false;
        }
        // 18位身份证
        if (idCard.length() == 18) {
            Pattern pattern = Pattern.compile("^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$");
            return pattern.matcher(idCard).matches();
        }
        // 15位身份证
        else if (idCard.length() == 15) {
            Pattern pattern = Pattern.compile("^[1-9]\\d{5}\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{2}[0-9Xx]$");
            return pattern.matcher(idCard).matches();
        }
        return false;
    }

    /**
     * 验证年龄（0-150岁）
     */
    public static boolean isValidAge(int age) {
        return age >= 0 && age <= 150;
    }

    /**
     * 验证金额（两位小数）
     */
    public static boolean isValidAmount(double amount) {
        return amount >= 0;
    }

    /**
     * 验证日期格式（yyyy-MM-dd）
     */
    public static boolean isValidDate(String dateStr) {
        if (StringUtil.isEmpty(dateStr)) {
            return false;
        }
        Pattern pattern = Pattern.compile("^\\d{4}-\\d{2}-\\d{2}$");
        return pattern.matcher(dateStr).matches();
    }
}