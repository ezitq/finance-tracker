package org.itomagoi.dao;

import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.GoalRecord;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Repository
public class GoalRecordDao {

    private final List<GoalRecord> goalRecords = new ArrayList<>();

    public List<GoalRecord> findAllRecords() {
        return new ArrayList<>(goalRecords);
    }

    public List<GoalRecord> findByAccountRecord(AccountRecord user) {
        if (user == null) return new ArrayList<>();
        return goalRecords.stream()
                .filter(g -> g.getAccountRecord() != null && g.getAccountRecord().getEmail().equals(user.getEmail()))
                .collect(Collectors.toList());
    }

    public void saveRecord(GoalRecord record) {
        goalRecords.add(0, record);
    }

    public void deleteRecord(int id) {
        goalRecords.removeIf(g -> g.getId() == id);
    }

    public GoalRecord findById(int id) {
        return goalRecords.stream()
                .filter(g -> g.getId() == id)
                .findFirst()
                .orElse(null);
    }
}