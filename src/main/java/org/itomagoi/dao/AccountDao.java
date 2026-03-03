package org.itomagoi.dao;

import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.ConvertCurrency;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class AccountDao {

    private final List<AccountRecord> accounts = new ArrayList<>();

    public List<AccountRecord> findAllAccounts() {
        return new ArrayList<>(accounts);
    }

    public AccountRecord findByEmail(String email) {
        return accounts.stream()
                .filter(a -> a.getEmail().equals(email))
                .findFirst()
                .orElse(null);
    }

    public boolean saveAccount(String email, String password) {
        if (findByEmail(email) != null) return false;
        accounts.add(new AccountRecord(email, password));
        return true;
    }

    public void removeAccount(AccountRecord account) {
        accounts.remove(account);
    }

    public void updateName(AccountRecord account, String name) { account.setName(name); }
    public void updateSecondName(AccountRecord account, String secondName) { account.setSecondName(secondName); }
    public void updateCurrency(AccountRecord account, ConvertCurrency currency) { account.setCurrency(currency); }
    public void updatePassword(AccountRecord account, String password) { account.setPassword(password); }
    public void updateEmail(AccountRecord account, String email) { account.setEmail(email); }
}