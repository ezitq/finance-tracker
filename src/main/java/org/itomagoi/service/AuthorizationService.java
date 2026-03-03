package org.itomagoi.service;

import org.itomagoi.dao.AccountDao;
import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.ConvertCurrency;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthorizationService {

    private final AccountDao accountDao;
    private static final int MIN_PASS_LENGTH = 8;

    @Autowired
    public AuthorizationService(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    public List<AccountRecord> findAllAccounts() {
        return accountDao.findAllAccounts();
    }

    public int getMinPassLength() {
        return MIN_PASS_LENGTH;
    }

    public boolean validateEmail(String email) {
        return email != null && email.contains("@") && email.contains(".");
    }

    public boolean validatePassword(String password) {
        return password != null && password.length() >= MIN_PASS_LENGTH;
    }

    public AccountRecord validateUser(String email, String password) {
        AccountRecord account = findAccountByEmail(email);
        if (account != null && account.getPassword().equals(password)) return account;
        return null;
    }

    public boolean registerAccount(String email, String password) {
        if (!validateEmail(email) || !validatePassword(password)) return false;
        return accountDao.saveAccount(email, password);
    }

    public AccountRecord findAccountByEmail(String email) {
        if (!validateEmail(email)) return null;
        return accountDao.findByEmail(email);
    }

    public void updateName(AccountRecord account, String name) {
        accountDao.updateName(account, name);
    }

    public void updateSecondName(AccountRecord account, String secondName) {
        accountDao.updateSecondName(account, secondName);
    }

    public void updateCurrency(AccountRecord account, ConvertCurrency currency) {
        accountDao.updateCurrency(account, currency);
    }

    public boolean updatePassword(AccountRecord account, String oldPassword, String newPassword) {
        if (!account.getPassword().equals(oldPassword)) return false;
        if (!validatePassword(newPassword)) return false;
        accountDao.updatePassword(account, newPassword);
        return true;
    }

    public boolean updateEmail(AccountRecord account, String newEmail) {
        if (!validateEmail(newEmail)) return false;
        if (findAccountByEmail(newEmail) != null) return false;
        accountDao.updateEmail(account, newEmail);
        return true;
    }

    public void deleteAccount(AccountRecord account) {
        accountDao.removeAccount(account);
    }
}