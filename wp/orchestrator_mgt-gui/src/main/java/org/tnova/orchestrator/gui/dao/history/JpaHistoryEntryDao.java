package org.tnova.orchestrator.gui.dao.history;

import java.util.List;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.tnova.orchestrator.gui.dao.JpaDao;
import org.tnova.orchestrator.gui.entity.HistoryEntry;

import org.springframework.transaction.annotation.Transactional;

/**
 * JPA Implementation of a {@link HistoryEntryDao}.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class JpaHistoryEntryDao extends JpaDao<HistoryEntry, Long> implements HistoryEntryDao {

    public JpaHistoryEntryDao() {
        super(HistoryEntry.class);
    }

    @Override
    @Transactional(readOnly = true)
    public List<HistoryEntry> findAll() {
        final CriteriaBuilder builder = this.getEntityManager().getCriteriaBuilder();
        final CriteriaQuery<HistoryEntry> criteriaQuery = builder.createQuery(HistoryEntry.class);

        Root<HistoryEntry> root = criteriaQuery.from(HistoryEntry.class);
        criteriaQuery.orderBy(builder.desc(root.get("date")));

        TypedQuery<HistoryEntry> typedQuery = this.getEntityManager().createQuery(criteriaQuery);
        return typedQuery.getResultList();
    }

}
