package org.itomagoi.service;

import org.itomagoi.dao.GoalRecordDao;
import org.itomagoi.dto.GoalRecordDto;
import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.GoalRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GoalRecordService {

    private final GoalRecordDao goalRecordDao;

    @Autowired
    public GoalRecordService(GoalRecordDao goalRecordDao) {
        this.goalRecordDao = goalRecordDao;
    }

    public GoalRecordDto findAllRecordsByUser(AccountRecord user) {
        return new GoalRecordDto(goalRecordDao.findByAccountRecord(user));
    }

    public GoalRecord findById(int id) {
        return goalRecordDao.findById(id);
    }

    public GoalRecord findByTitleAndUser(String title, AccountRecord user) {
        return goalRecordDao.findByAccountRecord(user).stream()
                .filter(g -> g.getTitle().equals(title))
                .findFirst()
                .orElse(null);
    }

    public void saveGoal(GoalRecord record) {
        goalRecordDao.saveRecord(record);
    }

    public void deleteGoal(int id) {
        goalRecordDao.deleteRecord(id);
    }

    public boolean addFunds(int id, double amount) {
        GoalRecord goal = goalRecordDao.findById(id);
        if (goal == null || amount <= 0) return false;
        goal.setCurrentMoney(goal.getCurrentMoney() + amount);
        return true;
    }

    public boolean reduceFunds(int id, double amount) {
        GoalRecord goal = goalRecordDao.findById(id);
        if (goal == null || amount <= 0) return false;
        goal.setCurrentMoney(Math.max(0, goal.getCurrentMoney() - amount));
        return true;
    }
}