package org.itomagoi.service;

import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class ChartService {

    public static Map<String, Double> getStringDoubleMap(FinanceRecordDto dto) {
        Map<String, Double> result = new LinkedHashMap<>();
        for (FinanceRecord record : dto.getRecords()) {
            double value = (record.getType() == FinanceRecordType.EXPENSE || record.getType() == FinanceRecordType.GOAL)
                    ? record.getAmount() * -1
                    : record.getAmount();
            result.put(record.getTitle(), value);
        }
        return result;
    }
}