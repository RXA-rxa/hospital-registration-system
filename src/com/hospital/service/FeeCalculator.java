package com.hospital.service;

import com.hospital.dao.TimeSlotDAO;
import com.hospital.model.TimeSlot;
import java.time.LocalDate;
import java.time.DayOfWeek;

public class FeeCalculator {
    private TimeSlotDAO timeSlotDAO = new TimeSlotDAO();

    /**
     * 计算挂号费
     */
    public double calculateFee(int timeSlotId) {
        try {
            TimeSlot timeSlot = timeSlotDAO.findById(timeSlotId);
            if (timeSlot == null) {
                return 0.0;
            }

            double baseFee = timeSlot.getFee();
            double finalFee = baseFee;

            // 检查是否是周末
            LocalDate today = LocalDate.now();
            DayOfWeek day = today.getDayOfWeek();

            // 周末加收
            if (day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
                finalFee += 10.0; // 周末加收10元
            }

            // 检查是否是节假日（这里可以扩展为从数据库读取节假日）
            if (isHoliday(today)) {
                finalFee += 15.0; // 节假日加收15元
            }

            return finalFee;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    /**
     * 计算动态费用（根据医生职称）
     */
    public double calculateDynamicFee(int timeSlotId, String doctorTitle) {
        double baseFee = calculateFee(timeSlotId);

        // 根据医生职称调整费用
        if ("主任医师".equals(doctorTitle)) {
            baseFee += 30.0;
        } else if ("副主任医师".equals(doctorTitle)) {
            baseFee += 20.0;
        } else if ("主治医师".equals(doctorTitle)) {
            baseFee += 10.0;
        }

        return baseFee;
    }

    /**
     * 判断是否是节假日（简化版本）
     */
    private boolean isHoliday(LocalDate date) {
        // 这里可以扩展为从数据库读取节假日
        // 暂时返回false
        return false;
    }
}