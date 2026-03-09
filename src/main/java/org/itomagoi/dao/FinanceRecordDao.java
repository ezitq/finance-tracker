package org.itomagoi.dao;

import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.FinanceRecord;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
public class FinanceRecordDao {

    @PersistenceContext
    private EntityManager em;

    public List<FinanceRecord> findAllRecords() {
        // Запит на отримання всіх записів, сортування за ID (останні зверху)
        return em.createQuery("SELECT f FROM FinanceRecord f ORDER BY f.id DESC", FinanceRecord.class)
                .getResultList();
    }

    public List<FinanceRecord> findByAccountRecord(AccountRecord user) {
        if (user == null) return List.of();
        // Використовуємо JPQL для фільтрації за об'єктом AccountRecord
        return em.createQuery("SELECT f FROM FinanceRecord f WHERE f.accountRecord = :user", FinanceRecord.class)
                .setParameter("user", user)
                .getResultList();
    }

    @Transactional
    public void saveRecord(FinanceRecord record) {
        if (record.getId() == 0) {
            em.persist(record); // Створити новий запис
        } else {
            em.merge(record);   // Оновити існуючий
        }
    }

    @Transactional
    public void deleteRecord(int id) {
        FinanceRecord record = findById(id);
        if (record != null) {
            em.remove(record);
        }
    }

    public FinanceRecord findById(int id) {
        return em.find(FinanceRecord.class, id);
    }
}