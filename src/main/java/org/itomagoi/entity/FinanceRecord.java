package org.itomagoi.entity;

import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "transactions")
public class FinanceRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AccountRecord accountRecord;

    @Column(name = "title")
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(name = "type")
    private FinanceRecordType type;

    @Column(name = "transaction_date")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;

    @Column(name = "amount")
    private double amount;

    public FinanceRecord(String title, String type, LocalDate date, double amount) {
        this.title = title;
        this.type = FinanceRecordType.valueOf(type);
        this.date = date;
        this.amount = amount;
    }

    public FinanceRecord(String title, FinanceRecordType type, LocalDate date, double amount) {
        this.title = title;
        this.type = type;
        this.date = date;
        this.amount = amount;
    }

    public FinanceRecord() {

    }

    public AccountRecord getAccountRecord() { return accountRecord; }
    public void setAccountRecord(AccountRecord accountRecord) { this.accountRecord = accountRecord; }

    public int getId() { return id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public FinanceRecordType getType() { return type; }
    public void setType(FinanceRecordType type) { this.type = type; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    @Override
    public String toString() {
        return "FinanceRecord{title='" + title + "', type=" + type + ", date=" + date + ", amount=" + amount + '}';
    }
}