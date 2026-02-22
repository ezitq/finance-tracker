package org.itomagoi.entity;


import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

public class FinanceRecord {

    private static int incrementId = 0;
    private final int id;
    private String title;
    private FinanceRecordType type;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;
    private double amount;

    public FinanceRecord(String title, String type, LocalDate date, double amount) {
        id = incrementId++;
        this.title = title;
        this.type = FinanceRecordType.valueOf(type);
        this.date = date;
        this.amount = amount;
    }

    public FinanceRecord(String title, FinanceRecordType type, LocalDate date, double amount) {
        id = incrementId++;
        this.title = title;
        this.type = type;
        this.date = date;
        this.amount = amount;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public FinanceRecordType getType() {
        return type;
    }

    public void setType(FinanceRecordType type) {
        this.type = type;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    @Override
    public String toString() {
        return "FinanceRecord{" +
                "title='" + title + '\'' +
                ", type=" + type +
                ", date=" + date +
                ", amount=" + amount +
                '}';
    }
}
