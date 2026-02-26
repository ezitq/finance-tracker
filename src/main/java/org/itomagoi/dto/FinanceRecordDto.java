package org.itomagoi.dto;

import org.itomagoi.entity.FinanceRecord;

import java.util.LinkedList;
import java.util.List;

public class FinanceRecordDto {
    private final List<FinanceRecord> records;
    private double totalBalance = 0.00;

    public FinanceRecordDto(List<FinanceRecord> records) {
        this.records = records;
    }

    public List<FinanceRecord> getRecords() {
        return records;
    }

    public double getTotalBalance() {
        return totalBalance;
    }

    public void setTotalBalance(double totalBalance) {
        this.totalBalance = totalBalance;
    }
}
