package org.itomagoi.service;

import org.itomagoi.dao.AccountDao;
import org.itomagoi.dao.FinanceRecordDao;
import org.itomagoi.entity.AccountRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class AuthorizationService {

    private final AccountDao accountDao;
    private final int MIN_PASS_LENGTH = 8;

    @Autowired
    public AuthorizationService(AccountDao accountDao) {
        this.accountDao = accountDao;
    }

    public List<AccountRecord> findAllAccounts(){

        return new ArrayList<>(accountDao.findAllAccounts());
    }

    public int getMIN_PASS_LENGTH() {
        return MIN_PASS_LENGTH;
    }

    public boolean validateEmail(String email){

        if(!email.contains("@gmail.com")) {

            System.out.println("Wrong email format");
            return false;
        }

        return true;
    }

    public AccountRecord validateUser(String email, String password){

        AccountRecord accountRecord = findConcreteAccount(email);

        if(accountRecord != null) {
            if(accountRecord.getPassword().equals(password)) {
                return accountRecord;
            }
        }

        return null;

    }


    public void saveAccount(String email, String password){

        if(findConcreteAccount(email) == null){
            accountDao.saveAccount(email,password);
        }

    }

    private AccountRecord findConcreteAccount(String email){
        if(validateEmail(email)){
            return accountDao.findAllAccounts().stream()
                    .filter(account -> account.getEmail().equals(email))
                    .findFirst()
                    .orElse(null);
        }
        return null;
    }

    public boolean validatePassword(String originalPassword){

        return originalPassword.length() >= MIN_PASS_LENGTH;

    }

}
