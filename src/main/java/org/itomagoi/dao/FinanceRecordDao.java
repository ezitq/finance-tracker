package org.itomagoi.dao;

import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class FinanceRecordDao {

    private final List<FinanceRecord> records = new ArrayList<>();

    public List<FinanceRecord> findAllRecords() {
        return new ArrayList<>(records);
    }

    public List<FinanceRecord> findByAccountRecord(AccountRecord user) {
        if (user == null) return new ArrayList<>();
        return records.stream()
                .filter(r -> r.getAccountRecord() != null && r.getAccountRecord().getEmail().equals(user.getEmail()))
                .collect(Collectors.toList());
    }

    public double getIncomesByUser(AccountRecord user) {
        return findByAccountRecord(user).stream()
                .filter(r -> r.getType() == FinanceRecordType.INCOME)
                .mapToDouble(FinanceRecord::getAmount)
                .sum();
    }

    public double getExpensesByUser(AccountRecord user) {
        return findByAccountRecord(user).stream()
                .filter(r -> r.getType() == FinanceRecordType.EXPENSE || r.getType() == FinanceRecordType.GOAL)
                .mapToDouble(FinanceRecord::getAmount)
                .sum();
    }

    public void saveRecord(FinanceRecord record) {
        records.add(0, record);
    }

    public void deleteRecord(int id) {
        records.removeIf(r -> r.getId() == id);
    }

    public FinanceRecord findById(int id) {
        return records.stream()
                .filter(r -> r.getId() == id)
                .findFirst()
                .orElse(null);
    }
}