package org.itomagoi.entity;

public class GoalRecord {

    private static int incrementId = 0;
    private final int id;
    private String title;
    private double currentMoney;
    private double goalMoney;

    public GoalRecord(String title, double currentMoney, double goalMoney) {
        id = incrementId++;
        this.title = title;
        this.currentMoney = currentMoney;
        this.goalMoney = goalMoney;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public double getCurrentMoney() {
        return currentMoney;
    }

    public double getGoalMoney() {
        return goalMoney;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setCurrentMoney(double currentMoney) {
        this.currentMoney = currentMoney;
    }

    public void setGoalMoney(double goalMoney) {
        this.goalMoney = goalMoney;
    }
}
