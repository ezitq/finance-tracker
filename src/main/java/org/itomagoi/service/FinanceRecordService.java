package org.itomagoi.service;

import org.itomagoi.dao.FinanceRecordDao;
import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FinanceRecordService {

    private final FinanceRecordDao financeRecordDao;

    @Autowired
    public FinanceRecordService(FinanceRecordDao financeRecordDao) {
        this.financeRecordDao = financeRecordDao;
    }

    public FinanceRecordDto findAllRecordsByUser(AccountRecord user) {
        return new FinanceRecordDto(financeRecordDao.findByAccountRecord(user));
    }

    public double getIncomeAmountByUser(AccountRecord user) {
        return financeRecordDao.findByAccountRecord(user).stream()
                .filter(r -> r.getType() == FinanceRecordType.INCOME)
                .mapToDouble(FinanceRecord::getAmount)
                .sum();
    }

    public double getExpenseAmountByUser(AccountRecord user) {
        return financeRecordDao.findByAccountRecord(user).stream()
                .filter(r -> r.getType() == FinanceRecordType.EXPENSE || r.getType() == FinanceRecordType.GOAL)
                .mapToDouble(FinanceRecord::getAmount)
                .sum();
    }

    public double getTotalBalanceByUser(AccountRecord user) {
        return getIncomeAmountByUser(user) - getExpenseAmountByUser(user);
    }

    public void saveRecord(FinanceRecord record) {
        financeRecordDao.saveRecord(record);
    }

    public void deleteRecord(int id) {
        financeRecordDao.deleteRecord(id);
    }

    public FinanceRecord findById(int id) {
        return financeRecordDao.findById(id);
    }
}