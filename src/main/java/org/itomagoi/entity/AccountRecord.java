package org.itomagoi.entity;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class AccountRecord {

    private String name;
    private String secondName;
    private ConvertCurrency currency = ConvertCurrency.USD;

    private String email;
    private String password;
    private LocalDate registrationDate;
    private List<FinanceRecord> transactionsList;
    private List<GoalRecord> goalsList;
    private String image;


    public AccountRecord(String email, String password){

        this.email = email;
        this.password = password;

        this.registrationDate = LocalDate.now();
        this.transactionsList = new ArrayList<>();
        this.goalsList = new ArrayList<>();
        this.image = null;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSecondName() {
        return secondName;
    }

    public void setSecondName(String secondName) {
        this.secondName = secondName;
    }

    public ConvertCurrency getCurrency() {
        return currency;
    }

    public void setCurrency(ConvertCurrency currency) {
        this.currency = currency;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public LocalDate getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDate registrationDate) {
        this.registrationDate = registrationDate;
    }

    public List<FinanceRecord> getTransactionsList() {
        return transactionsList;
    }

    public void setTransactionsList(List<FinanceRecord> transactionsList) {
        this.transactionsList = transactionsList;
    }

    public List<GoalRecord> getGoalsList() {
        return goalsList;
    }

    public void setGoalsList(List<GoalRecord> goalsList) {
        this.goalsList = goalsList;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
