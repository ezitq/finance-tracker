package org.itomagoi.service;

import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ChartService {

    @NonNull
    public static Map<String, Double> getStringDoubleMap(FinanceRecordDto recordsToAnalyze) {
        List<FinanceRecord> financeRecordList = recordsToAnalyze.getRecords();

// 1. Уявімо, що це ваші реальні витрати з бази даних
        Map<String, Double> expensesFromDb = new HashMap<>();

        for(FinanceRecord record : financeRecordList){

            if(record.getType() == FinanceRecordType.GOAL
                    || record.getType() == FinanceRecordType.EXPENSE){
                expensesFromDb.put(record.getTitle(), record.getAmount() * - 1);

            }else {
                expensesFromDb.put(record.getTitle(), record.getAmount());

            }
        }
        return expensesFromDb;
    }

}
