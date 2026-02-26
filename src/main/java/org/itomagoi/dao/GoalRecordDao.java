package org.itomagoi.dao;

import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.itomagoi.entity.GoalRecord;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class GoalRecordDao {

    private final List<GoalRecord> goalRecords = new ArrayList<>();

    public List<GoalRecord> findAllRecords(){

        return new ArrayList<>(goalRecords);
    }

    public void deleteGoal(int id) {
        // Це скаже списку: "Пройдися по всіх елементах і видали той, у якого id збігається"
        goalRecords.removeIf(record -> record.getId() == id);
    }

    public void saveRecord(GoalRecord record){

        goalRecords.add(record);

    }
}
