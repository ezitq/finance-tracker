package org.itomagoi.entity;

import javax.persistence.*;

@Entity
@Table(name = "goals")
public class GoalRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AccountRecord accountRecord;

    @Column(name = "title")
    private String title;

    @Column(name = "current_money")
    private double currentMoney;

    @Column(name = "goal_money")
    private double goalMoney;

    public GoalRecord() {
    }

    public GoalRecord(String title, double currentMoney, double goalMoney) {
        this.title = title;
        this.currentMoney = currentMoney;
        this.goalMoney = goalMoney;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public AccountRecord getAccountRecord() { return accountRecord; }
    public void setAccountRecord(AccountRecord accountRecord) { this.accountRecord = accountRecord; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getCurrentMoney() { return currentMoney; }
    public void setCurrentMoney(double currentMoney) { this.currentMoney = currentMoney; }

    public double getGoalMoney() { return goalMoney; }
    public void setGoalMoney(double goalMoney) { this.goalMoney = goalMoney; }

    @Transient
    public double getProgress() {
        if (goalMoney <= 0) return 0;
        return Math.min((currentMoney / goalMoney) * 100, 100);
    }
}