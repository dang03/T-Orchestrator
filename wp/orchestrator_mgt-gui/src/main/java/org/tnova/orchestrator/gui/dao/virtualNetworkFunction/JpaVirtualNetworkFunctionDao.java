package org.tnova.orchestrator.gui.dao.virtualNetworkFunction;

import java.util.List;
import javax.persistence.Query;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.tnova.orchestrator.gui.dao.JpaDao;
import org.tnova.orchestrator.gui.entity.VirtualNetworkFunction;

import org.springframework.transaction.annotation.Transactional;

/**
 * JPA Implementation of a {@link VirtualNetworkFunction}.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class JpaVirtualNetworkFunctionDao extends JpaDao<VirtualNetworkFunction, Long> implements VirtualNetworkFunctionDao {

    public JpaVirtualNetworkFunctionDao() {
        super(VirtualNetworkFunction.class);
    }

    @Override
    @Transactional(readOnly = true)
    public List<VirtualNetworkFunction> findAll() {
        final CriteriaBuilder builder = this.getEntityManager().getCriteriaBuilder();
        final CriteriaQuery<VirtualNetworkFunction> criteriaQuery = builder.createQuery(VirtualNetworkFunction.class);

        Root<VirtualNetworkFunction> root = criteriaQuery.from(VirtualNetworkFunction.class);
        criteriaQuery.orderBy(builder.desc(root.get("created_at")));

        TypedQuery<VirtualNetworkFunction> typedQuery = this.getEntityManager().createQuery(criteriaQuery);
        return typedQuery.getResultList();
    }

    @Override
    public VirtualNetworkFunction findByName(String spName) {
        Query q = this.getEntityManager().createNamedQuery("VirtualNetworkFunction.findByName");
        q.setParameter("name", spName);
        return (VirtualNetworkFunction) q.getSingleResult();
    }

}
