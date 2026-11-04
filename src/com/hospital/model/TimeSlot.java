package com.hospital.model;

import java.sql.Time;

public class TimeSlot {
    private int slotId;
    private String slotName;
    private Time startTime;
    private Time endTime;
    private double fee;
    private boolean isAvailable;

    // 构造方法
    public TimeSlot() {}

    public TimeSlot(String slotName, Time startTime, Time endTime, double fee) {
        this.slotName = slotName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.fee = fee;
        this.isAvailable = true;
    }

    // getter和setter方法
    public int getSlotId() { return slotId; }
    public void setSlotId(int slotId) { this.slotId = slotId; }

    public String getSlotName() { return slotName; }
    public void setSlotName(String slotName) { this.slotName = slotName; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public double getFee() { return fee; }
    public void setFee(double fee) { this.fee = fee; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    @Override
    public String toString() {
        return "TimeSlot{" +
                "slotId=" + slotId +
                ", slotName='" + slotName + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", fee=" + fee +
                '}';
    }
}
