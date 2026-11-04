package com.hospital.util;

public class StringUtil {

    /**
     * 判断字符串是否为空
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().length() == 0;
    }

    /**
     * 判断字符串是否非空
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    /**
     * 去除字符串两端的空白字符
     */
    public static String trim(String str) {
        return str == null ? null : str.trim();
    }

    /**
     * 将对象转换为字符串，如果为null则返回空字符串
     */
    public static String toString(Object obj) {
        return obj == null ? "" : obj.toString();
    }

    /**
     * 判断字符串是否为数字
     */
    public static boolean isNumeric(String str) {
        if (isEmpty(str)) {
            return false;
        }
        return str.matches("\\d+");
    }

    /**
     * 判断字符串是否为邮箱格式
     */
    public static boolean isEmail(String str) {
        if (isEmpty(str)) {
            return false;
        }
        return str.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    /**
     * 判断字符串是否为手机号格式
     */
    public static boolean isPhone(String str) {
        if (isEmpty(str)) {
            return false;
        }
        return str.matches("^1[3-9]\\d{9}$");
    }

    /**
     * 隐藏手机号中间4位
     */
    public static String hidePhone(String phone) {
        if (isEmpty(phone) || phone.length() < 7) {
            return phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(7);
    }
}