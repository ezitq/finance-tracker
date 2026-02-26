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

    public void updateBalance(){

            financeRecordDao.updateBalance();

    }

    public double getTotalBalance(){

        return financeRecordDao.getTotalBalance();
    }

    public double getExpenseAmount(){

        return financeRecordDao.getExpense();
    }

    public double getIncomeAmount(){

        return financeRecordDao.getIncomes();
    }

    public FinanceRecordDto findFilteredRecords(FinanceRecordType filterType){

        List<FinanceRecord> records = financeRecordDao.findAllRecords(filterType);

        return new FinanceRecordDto(records);
    }

    public void saveRecord(FinanceRecord record){

        financeRecordDao.saveRecord(record);
    }

    public void deleteTransaction(int id) {

        financeRecordDao.deleteTransaction(id);
        this.updateBalance();
    }

}
