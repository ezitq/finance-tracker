package org.itomagoi.service;

import org.itomagoi.dao.GoalRecordDao;
import org.itomagoi.dto.FinanceRecordDto;
import org.itomagoi.dto.GoalRecordDto;
import org.itomagoi.entity.FinanceRecord;
import org.itomagoi.entity.FinanceRecordType;
import org.itomagoi.entity.GoalRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GoalRecordService {
    private GoalRecordDao goalRecordDao;

    @Autowired
    public GoalRecordService(GoalRecordDao goalRecordDao) {
        this.goalRecordDao = goalRecordDao;
    }


    public void addFunds(int id, double amount){

        findGoalRecordById(id).setCurrentMoney(findGoalRecordById(id).getCurrentMoney() + amount);
    }

    public GoalRecord findGoalRecordById(int id){
        return findAllRecords().getRecords()
                .stream()
                .filter(goalRecord -> goalRecord.getId() == id)
                .findFirst().get();
    }

    public GoalRecordDto findAllRecords() {

        List<GoalRecord> goalRecords = goalRecordDao.findAllRecords();

        return new GoalRecordDto(goalRecords);
    }

    public double calculatePercentage(GoalRecord goalRecord){

        return Math.floor((goalRecord.getCurrentMoney() / goalRecord.getGoalMoney()) * 100);
    }

    public void saveGoal(GoalRecord record){

        goalRecordDao.saveRecord(record);
    }

    public void deleteGoal(int id) {

        goalRecordDao.deleteGoal(id);
    }

}
