package org.tnova.orchestrator.gui.dao.instances;

import java.util.List;
import javax.persistence.Query;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.tnova.orchestrator.gui.dao.JpaDao;
import org.tnova.orchestrator.gui.entity.Instance;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.transaction.annotation.Transactional;

/**
 * JPA Implementation of a {@link InstancesDao}.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class JpaInstancesDao extends JpaDao<Instance, Long> implements InstancesDao {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	public JpaInstancesDao() {
		super(Instance.class);
	}

	@Override
	@Transactional(readOnly = true)
	public List<Instance> findAll() {
		final CriteriaBuilder builder = this.getEntityManager()
				.getCriteriaBuilder();
		final CriteriaQuery<Instance> criteriaQuery = builder
				.createQuery(Instance.class);

		Root<Instance> root = criteriaQuery.from(Instance.class);
		criteriaQuery.orderBy(builder.desc(root.get("created_at")));

		TypedQuery<Instance> typedQuery = this.getEntityManager()
				.createQuery(criteriaQuery);
		return typedQuery.getResultList();
	}

	@Override
	public Instance findByName(String viName) {
		Query q = this.getEntityManager().createNamedQuery("Instances.findByName");
		q.setParameter("name", viName);
		return (Instance) q.getSingleResult();
	}
}
