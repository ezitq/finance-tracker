package org.itomagoi.dao;

import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.ConvertCurrency;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class AccountDao {

    private final List<AccountRecord> accounts = new ArrayList<>();

    public List<AccountRecord> findAllAccounts(){

        return new ArrayList<>(accounts);
    }

    public void saveAccount(String email, String password){

        AccountRecord accountRecord = accounts.stream()
                .filter(account -> account.getEmail().equals(email))
                .findFirst()
                .orElse(null);

        if(accountRecord == null) accounts.add(0, new AccountRecord(email,password));
        else System.out.println("Account with this email exist");

    }

    public void removeAccount(AccountRecord accountRecord){

        if(accountRecord != null) accounts.remove(accountRecord);
        else System.out.println("Account with this email exist");

    }

    public void updateName(AccountRecord accountRecord, String name){accountRecord.setName(name);}

    public void updateSecondName(AccountRecord accountRecord, String name){accountRecord.setSecondName(name);}

    public void updateCurrency(AccountRecord accountRecord, ConvertCurrency currency){accountRecord.setCurrency(currency);}

    public void updatePassword(AccountRecord accountRecord, String password){accountRecord.setPassword(password);}

    public void updateEmail(AccountRecord accountRecord, String email){accountRecord.setEmail(email);}



}
