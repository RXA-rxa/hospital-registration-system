package com.hospital.dao;

import java.sql.*;
import java.util.List;
import com.hospital.model.TimeSlot;

public class TimeSlotDAO extends BaseDAO<TimeSlot> {

    /**
     * 添加时间段
     */
    public int addTimeSlot(TimeSlot timeSlot) {
        String sql = "INSERT INTO time_slots(slot_name, start_time, end_time, fee, is_available) " +
                "VALUES(?, ?, ?, ?, ?)";

        return executeUpdate(sql,
                timeSlot.getSlotName(),
                timeSlot.getStartTime(),
                timeSlot.getEndTime(),
                timeSlot.getFee(),
                timeSlot.isAvailable()
        );
    }

    /**
     * 根据ID查找时间段
     */
    public TimeSlot findById(int slotId) {
        String sql = "SELECT * FROM time_slots WHERE slot_id = ?";
        return querySingle(sql, new TimeSlotRowMapper(), slotId);
    }

    /**
     * 获取所有时间段
     */
    public List<TimeSlot> findAll() {
        String sql = "SELECT * FROM time_slots ORDER BY start_time";
        return queryList(sql, new TimeSlotRowMapper());
    }

    /**
     * 获取所有可用的时间段
     */
    public List<TimeSlot> findAllAvailable() {
        String sql = "SELECT * FROM time_slots WHERE is_available = true ORDER BY start_time";
        return queryList(sql, new TimeSlotRowMapper());
    }

    /**
     * 根据时间段名称查找
     */
    public TimeSlot findByName(String slotName) {
        String sql = "SELECT * FROM time_slots WHERE slot_name = ?";
        return querySingle(sql, new TimeSlotRowMapper(), slotName);
    }

    /**
     * 更新时间段信息
     */
    public int updateTimeSlot(TimeSlot timeSlot) {
        String sql = "UPDATE time_slots SET slot_name = ?, start_time = ?, end_time = ?, " +
                "fee = ?, is_available = ? WHERE slot_id = ?";

        return executeUpdate(sql,
                timeSlot.getSlotName(),
                timeSlot.getStartTime(),
                timeSlot.getEndTime(),
                timeSlot.getFee(),
                timeSlot.isAvailable(),
                timeSlot.getSlotId()
        );
    }

    /**
     * 根据ID删除时间段
     */
    public int deleteTimeSlot(int slotId) {
        String sql = "DELETE FROM time_slots WHERE slot_id = ?";
        return executeUpdate(sql, slotId);
    }

    /**
     * 根据ID更新可用状态
     */
    public int updateAvailability(int slotId, boolean isAvailable) {
        String sql = "UPDATE time_slots SET is_available = ? WHERE slot_id = ?";
        return executeUpdate(sql, isAvailable, slotId);
    }

    /**
     * 获取时间段费用
     */
    public double getFeeBySlotId(int slotId) {
        String sql = "SELECT fee FROM time_slots WHERE slot_id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        double fee = 0.0;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, slotId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                fee = rs.getDouble("fee");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return fee;
    }

    /**
     * 根据时间获取适用的时间段
     */
    public TimeSlot getSlotByTime(java.util.Date dateTime) {
        // 将java.util.Date转换为java.sql.Time
        Time time = new Time(dateTime.getTime());

        String sql = "SELECT * FROM time_slots WHERE start_time <= ? AND end_time > ? AND is_available = true";

        return querySingle(sql, new TimeSlotRowMapper(), time, time);
    }

    /**
     * 检查时间段是否可用
     */
    public boolean isSlotAvailable(int slotId) {
        TimeSlot slot = findById(slotId);
        return slot != null && slot.isAvailable();
    }

    /**
     * 获取某医生在某个时间段的可挂号数量
     */
    public int getAvailableCapacity(int slotId, int doctorId, java.sql.Date date) {
        // 假设每个时间段每个医生最多可挂20个号
        int maxCapacity = 20;

        // 查询已挂号数量
        String sql = "SELECT COUNT(*) FROM registration_records " +
                "WHERE time_slot_id = ? AND doctor_id = ? " +
                "AND registration_date = ? AND status != 'cancelled'";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int bookedCount = 0;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, slotId);
            pstmt.setInt(2, doctorId);
            pstmt.setDate(3, date);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                bookedCount = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return maxCapacity - bookedCount;
    }

    @Override
    public int cancelRegistration(int recordId) {
        return 0;
    }

    /**
     * 时间段行映射器
     */
    private static class TimeSlotRowMapper implements RowMapper<TimeSlot> {
        @Override
        public TimeSlot mapRow(ResultSet rs) throws SQLException {
            TimeSlot timeSlot = new TimeSlot();
            timeSlot.setSlotId(rs.getInt("slot_id"));
            timeSlot.setSlotName(rs.getString("slot_name"));
            timeSlot.setStartTime(rs.getTime("start_time"));
            timeSlot.setEndTime(rs.getTime("end_time"));
            timeSlot.setFee(rs.getDouble("fee"));
            timeSlot.setAvailable(rs.getBoolean("is_available"));
            return timeSlot;
        }
    }
}