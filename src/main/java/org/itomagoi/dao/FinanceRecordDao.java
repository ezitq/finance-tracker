package org.itomagoi.dao;


import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class FinanceRecordDao {

    private final List<FinanceRecord> records = new ArrayList<>(

            Arrays.asList(
                new FinanceRecord("Grocery", FinanceRecordType.INCOME, LocalDate.now(),100 ),
                    new FinanceRecord("Grocery", FinanceRecordType.EXPENSE, LocalDate.now(),100 ),
                    new FinanceRecord("Grocery", FinanceRecordType.EXPENSE, LocalDate.now(),100 ),
                new FinanceRecord("Grocery", FinanceRecordType.EXPENSE, LocalDate.now(),100 ),
            new FinanceRecord("Grocery", FinanceRecordType.EXPENSE, LocalDate.now(),100 ),
            new FinanceRecord("Grocery", FinanceRecordType.EXPENSE, LocalDate.now(),100 )

            )

    );

    public List<FinanceRecord> findAllRecords(){

        return new ArrayList<>(records);
    }

    public List<FinanceRecord> findAllRecords(FinanceRecordType filterType){

        return records.stream().filter(rec -> rec.getType() == filterType).collect(Collectors.toList());
    }

    public void deleteTransaction(int id) {
        // Це скаже списку: "Пройдися по всіх елементах і видали той, у якого id збігається"
        records.removeIf(record -> record.getId() == id);
    }


    public void saveRecord(FinanceRecord record){

        records.add(record);

    }





}
