package org.itomagoi.entity;

public class GoalRecord {

    private AccountRecord accountRecord;
    private static int incrementId = 0;
    private final int id;
    private String title;
    private double currentMoney;
    private double goalMoney;

    public GoalRecord(String title, double currentMoney, double goalMoney) {
        this.id = incrementId++;
        this.title = title;
        this.currentMoney = currentMoney;
        this.goalMoney = goalMoney;
    }

    public AccountRecord getAccountRecord() { return accountRecord; }
    public void setAccountRecord(AccountRecord accountRecord) { this.accountRecord = accountRecord; }

    public int getId() { return id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getCurrentMoney() { return currentMoney; }
    public void setCurrentMoney(double currentMoney) { this.currentMoney = currentMoney; }

    public double getGoalMoney() { return goalMoney; }
    public void setGoalMoney(double goalMoney) { this.goalMoney = goalMoney; }

    public double getProgress() {
        if (goalMoney <= 0) return 0;
        return Math.min((currentMoney / goalMoney) * 100, 100);
    }
}