package org.itomagoi.dao;

import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.springframework.stereotype.Repository;
import java.util.*;
import java.util.stream.Collectors;

@Repository
public class FinanceRecordDao {

    private final List<FinanceRecord> records = new ArrayList<>();
    private double expense = 0;
    private double incomes = 0;
    private double totalBalance = 0;

    public List<FinanceRecord> findAllRecords(){

        return new ArrayList<>(records);
    }

    public List<FinanceRecord> findAllRecords(FinanceRecordType filterType){

        return records.stream().filter(rec -> rec.getType() == filterType).collect(Collectors.toList());
    }

    public double getExpense() {
        return expense;
    }

    public double getIncomes() {
        return incomes;
    }

    public double getTotalBalance() {
        return totalBalance;
    }

    public void updateBalance(){

        this.incomes =  findAllRecords()
                .stream()
                .filter(financeRecord -> financeRecord.getType().equals(FinanceRecordType.INCOME))
                .map(FinanceRecord::getAmount)
                .reduce(0.0,Double::sum);

        this.expense = findAllRecords()
                .stream()
                .filter(financeRecord -> financeRecord.getType().equals(FinanceRecordType.EXPENSE)
                        || financeRecord.getType().equals(FinanceRecordType.GOAL)  )
                .map(financeRecord -> financeRecord.getAmount() * -1)
                .reduce(0.0,Double::sum);

        this.totalBalance = expense + incomes;


    }


    public void deleteTransaction(int id) {
        // Це скаже списку: "Пройдися по всіх елементах і видали той, у якого id збігається"
        records.removeIf(record -> record.getId() == id);
    }


    public void saveRecord(FinanceRecord record){

        records.add(0, record);

        String recordType = String.valueOf(record.getType());

        switch (recordType){

            case ("GOAL") :
            case ("EXPENSE") :
                this.expense -= record.getAmount();
                this.totalBalance -= record.getAmount();
                break;
            case ("INCOME") :
                this.incomes += record.getAmount();
                this.totalBalance += record.getAmount();
            default:
                break;
            }

        }

    }




