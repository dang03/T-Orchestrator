package org.tnova.orchestrator.gui.dao.networkService;

import java.util.List;
import javax.persistence.Query;

import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.tnova.orchestrator.gui.dao.JpaDao;
import org.tnova.orchestrator.gui.entity.VirtualNetworkFunction;
import org.tnova.orchestrator.gui.entity.NetworkService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.transaction.annotation.Transactional;

/**
 * JPA Implementation of a {@link NetworkService}.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class JpaNetworkServiceDao extends JpaDao<NetworkService, Long> implements NetworkServiceDao {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	public JpaNetworkServiceDao() {
		super(NetworkService.class);
	}

	@Override
	@Transactional(readOnly = true)
	public List<NetworkService> findAll() {
		final CriteriaBuilder builder = this.getEntityManager()
				.getCriteriaBuilder();
		final CriteriaQuery<NetworkService> criteriaQuery = builder
				.createQuery(NetworkService.class);

		Root<NetworkService> root = criteriaQuery.from(NetworkService.class);
		criteriaQuery.orderBy(builder.desc(root.get("created_at")));

		TypedQuery<NetworkService> typedQuery = this.getEntityManager()
				.createQuery(criteriaQuery);
		return typedQuery.getResultList();
	}

	@Override
	@Transactional
	public void add(Long id, String name) {
		NetworkService entity = this.find(id);
		VirtualNetworkFunction virtRes = new VirtualNetworkFunction();
                virtRes.setName(name);
		entity.getVnfs().add(virtRes);
		this.getEntityManager().persist(entity);
		// this.getEntityManager().flush();
	}

	@Override
	public NetworkService findByName(String viName) {
		Query q = this.getEntityManager().createNamedQuery("NS.findByName");
		q.setParameter("name", viName);
		return (NetworkService) q.getSingleResult();
	}
}
