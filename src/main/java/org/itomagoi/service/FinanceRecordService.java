package org.itomagoi.service;

import org.itomagoi.dao.FinanceRecordDao;
import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FinanceRecordService {
    private final FinanceRecordDao financeRecordDao;

    @Autowired
    public FinanceRecordService(FinanceRecordDao financeRecordDao) {
        this.financeRecordDao = financeRecordDao;
    }

    public FinanceRecordDto findAllRecords() {

        List<FinanceRecord> records = financeRecordDao.findAllRecords();

        return new FinanceRecordDto(records);
    }

    public FinanceRecord findRecordById(int id){

        return findAllRecords().getRecords().get(id);

    }

    public FinanceRecordDto findFilteredRecords(FinanceRecordType filterType){

        List<FinanceRecord> records = financeRecordDao.findAllRecords(filterType);

        return new FinanceRecordDto(records);
    }

    public double calculateIncome(){

        return financeRecordDao.findAllRecords(FinanceRecordType.INCOME).
                stream()
                .map(FinanceRecord::getAmount)
                .reduce(0.0,Double::sum);
    }

    public double calculateExpense(){

        return financeRecordDao.findAllRecords(FinanceRecordType.EXPENSE).
                stream()
                .map(FinanceRecord::getAmount)
                .reduce(0.0,Double::sum);

    }

    public void saveRecord(FinanceRecord record){

        financeRecordDao.saveRecord(record);
    }

    public void deleteTransaction(int id) {

        financeRecordDao.deleteTransaction(id);
    }

}
