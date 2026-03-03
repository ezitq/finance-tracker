package org.itomagoi.dto;

import org.itomagoi.entity.AccountRecord;
import java.util.List;

public class AccountDto {
    private final List<AccountRecord> accounts;

    public AccountDto(List<AccountRecord> accounts) {
        this.accounts = accounts;
    }

    public List<AccountRecord> getAccounts() {
        return accounts;
    }
}