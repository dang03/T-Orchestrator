package org.tnova.orchestrator.gui.dao.monitoringData;

import java.util.List;
import javax.persistence.Query;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.tnova.orchestrator.gui.dao.JpaDao;
import org.tnova.orchestrator.gui.entity.MonitoringData;

import org.springframework.transaction.annotation.Transactional;

/**
 * JPA Implementation of a {@link MonitoringData}.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class JpaMonitoringDataDao extends JpaDao<MonitoringData, Long> implements MonitoringDataDao {

    public JpaMonitoringDataDao() {
        super(MonitoringData.class);
    }

    @Override
    @Transactional(readOnly = true)
    public List<MonitoringData> findAll() {
        final CriteriaBuilder builder = this.getEntityManager().getCriteriaBuilder();
        final CriteriaQuery<MonitoringData> criteriaQuery = builder.createQuery(MonitoringData.class);

        Root<MonitoringData> root = criteriaQuery.from(MonitoringData.class);
        criteriaQuery.orderBy(builder.desc(root.get("created_at")));

        TypedQuery<MonitoringData> typedQuery = this.getEntityManager().createQuery(criteriaQuery);
        return typedQuery.getResultList();
    }

    @Override
    public MonitoringData findByName(String spName) {
        Query q = this.getEntityManager().createNamedQuery("MonitoringData.findByName");
        q.setParameter("name", spName);
        return (MonitoringData) q.getSingleResult();
    }

}
