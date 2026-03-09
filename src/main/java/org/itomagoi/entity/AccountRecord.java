package org.itomagoi.entity;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
public class AccountRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "name")
    private String name;

    @Column(name = "second_name")
    private String secondName;

    @Enumerated(EnumType.STRING)
    @Column(name = "currency")
    private ConvertCurrency currency = ConvertCurrency.USD;

    @Column(name = "email", unique = true)
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "registration_date")
    private LocalDate registrationDate;

    @OneToMany(mappedBy = "accountRecord", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FinanceRecord> transactionsList = new ArrayList<>();

    @OneToMany(mappedBy = "accountRecord", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<GoalRecord> goalsList = new ArrayList<>();

    public AccountRecord() {
    }

    public AccountRecord(String email, String password) {
        this.email = email;
        this.password = password;
        this.registrationDate = LocalDate.now();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSecondName() { return secondName; }
    public void setSecondName(String secondName) { this.secondName = secondName; }

    public ConvertCurrency getCurrency() { return currency; }
    public void setCurrency(ConvertCurrency currency) { this.currency = currency; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public LocalDate getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(LocalDate registrationDate) { this.registrationDate = registrationDate; }

    public List<FinanceRecord> getTransactionsList() { return transactionsList; }
    public void setTransactionsList(List<FinanceRecord> transactionsList) { this.transactionsList = transactionsList; }

    public List<GoalRecord> getGoalsList() { return goalsList; }
    public void setGoalsList(List<GoalRecord> goalsList) { this.goalsList = goalsList; }

    @Override
    public String toString() {
        return "AccountRecord{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", secondName='" + secondName + '\'' +
                ", currency=" + currency +
                ", email='" + email + '\'' +
                ", registrationDate=" + registrationDate +
                '}';
    }
}