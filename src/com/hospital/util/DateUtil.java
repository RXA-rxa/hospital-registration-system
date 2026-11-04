package com.hospital.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {

    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String TIME_FORMAT = "HH:mm:ss";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

    /**
     * 格式化日期
     */
    public static String formatDate(Date date, String pattern) {
        if (date == null) {
            return "";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.format(date);
    }

    /**
     * 解析日期字符串
     */
    public static Date parseDate(String dateStr, String pattern) throws ParseException {
        if (StringUtil.isEmpty(dateStr)) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.parse(dateStr);
    }

    /**
     * 获取当前日期
     */
    public static Date getCurrentDate() {
        return new Date();
    }

    /**
     * 获取当前日期字符串
     */
    public static String getCurrentDateStr(String pattern) {
        return formatDate(getCurrentDate(), pattern);
    }

    /**
     * 获取指定天数后的日期
     */
    public static Date addDays(Date date, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_MONTH, days);
        return calendar.getTime();
    }

    /**
     * 计算两个日期之间的天数差
     */
    public static int daysBetween(Date startDate, Date endDate) {
        long diff = endDate.getTime() - startDate.getTime();
        return (int) (diff / (1000 * 60 * 60 * 24));
    }

    /**
     * 判断日期是否在今天之后
     */
    public static boolean isAfterToday(Date date) {
        Date today = getCurrentDate();
        return date.after(today);
    }

    /**
     * 判断日期是否在今天之前
     */
    public static boolean isBeforeToday(Date date) {
        Date today = getCurrentDate();
        return date.before(today);
    }

    /**
     * 获取星期几
     */
    public static String getWeekday(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

        String[] weekdays = {"", "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
        return weekdays[dayOfWeek];
    }
}
