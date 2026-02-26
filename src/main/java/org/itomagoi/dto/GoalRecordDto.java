package org.itomagoi.dto;

import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.GoalRecord;

import java.util.List;

public class GoalRecordDto {
    private final List<GoalRecord> goalRecords;

    public GoalRecordDto(List<GoalRecord> goalRecords) {
        this.goalRecords = goalRecords;

    }

    public List<GoalRecord> getRecords() {
        return  goalRecords;
    }

}
