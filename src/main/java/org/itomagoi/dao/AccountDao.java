package org.itomagoi.dao;

import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.ConvertCurrency;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
public class AccountDao {

    @PersistenceContext
    private EntityManager em;

    // ВИДАЛЕНО: private final List<AccountRecord> accounts = new ArrayList<>();
    // Дані тепер шукаємо тільки в базі

    public List<AccountRecord> findAllAccounts() {
        return em.createQuery("SELECT a FROM AccountRecord a", AccountRecord.class)
                .getResultList();
    }

    public AccountRecord findByEmail(String email) {
        List<AccountRecord> results = em.createQuery(
                        "SELECT a FROM AccountRecord a WHERE a.email = :email", AccountRecord.class)
                .setParameter("email", email)
                .getResultList(); // Отримуємо список

        return results.isEmpty() ? null : results.get(0);
    }

    @Transactional
    public boolean saveAccount(String email, String password) {
        if (findByEmail(email) != null) return false;

        AccountRecord accountRecord = new AccountRecord(email, password);

        // ВИПРАВЛЕННЯ: Встановлюємо значення, щоб уникнути NOT NULL constraint violation
        accountRecord.setName("User");
        accountRecord.setSecondName("Guest");

        em.persist(accountRecord);
        return true;
    }

    @Transactional
    public void removeAccount(AccountRecord account) {
        // У JPA перед видаленням об'єкт треба "прикріпити" до контексту (merge)
        em.remove(em.contains(account) ? account : em.merge(account));
    }

    @Transactional
    public void updateName(AccountRecord account, String name) {
        account.setName(name);
        em.merge(account);
    }

    @Transactional
    public void updateSecondName(AccountRecord account, String secondName) {
        account.setSecondName(secondName);
        em.merge(account);
    }

    @Transactional
    public void updateCurrency(AccountRecord account, ConvertCurrency currency) {
        account.setCurrency(currency);
        em.merge(account);
    }

    @Transactional
    public void updatePassword(AccountRecord account, String password) {
        account.setPassword(password);
        em.merge(account);
    }

    @Transactional
    public void updateEmail(AccountRecord account, String email) {
        account.setEmail(email);
        em.merge(account);
    }
}