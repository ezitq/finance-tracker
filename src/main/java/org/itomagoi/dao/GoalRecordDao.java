package org.itomagoi.dao;

import org.itomagoi.entity.AccountRecord;
import org.itomagoi.entity.GoalRecord;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
public class GoalRecordDao {

    @PersistenceContext
    private EntityManager em;

    public List<GoalRecord> findAllRecords() {
        return em.createQuery("SELECT g FROM GoalRecord g ORDER BY g.id DESC", GoalRecord.class)
                .getResultList();
    }

    public List<GoalRecord> findByAccountRecord(AccountRecord user) {
        if (user == null) return List.of();
        return em.createQuery("SELECT g FROM GoalRecord g WHERE g.accountRecord = :user", GoalRecord.class)
                .setParameter("user", user)
                .getResultList();
    }

    @Transactional
    public void saveRecord(GoalRecord record) {
        if (record.getId() == 0) {
            em.persist(record);
        } else {
            em.merge(record);
        }
    }

    @Transactional
    public void deleteRecord(int id) {
        GoalRecord record = findById(id);
        if (record != null) {
            em.remove(record);
        }
    }

    public GoalRecord findById(int id) {
        return em.find(GoalRecord.class, id);
    }
}