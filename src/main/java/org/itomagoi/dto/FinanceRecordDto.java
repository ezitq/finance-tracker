package org.itomagoi.dto;

import org.itomagoi.entity.FinanceRecord;
import java.util.List;

public class FinanceRecordDto {
    private final List<FinanceRecord> records;

    public FinanceRecordDto(List<FinanceRecord> records) {
        this.records = records;
    }

    public List<FinanceRecord> getRecords() {
        return records;
    }
}