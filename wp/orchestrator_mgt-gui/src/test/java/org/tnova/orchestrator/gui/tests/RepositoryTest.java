package org.tnova.orchestrator.gui.tests;

import java.util.ArrayList;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.PersistenceContext;
import static org.junit.Assert.assertEquals;

import org.junit.BeforeClass;
import org.tnova.orchestrator.gui.dao.networkService.NetworkServiceDao;
import org.tnova.orchestrator.gui.entity.NetworkService;
import org.tnova.orchestrator.gui.entity.VirtualNetworkFunction;

/**
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class RepositoryTest {

    @PersistenceContext(unitName = "tNovaPUTest")
    private static EntityManager em;

    @BeforeClass
    public static void setEntityManager() throws Exception {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("tNovaPUTest");
        em = emf.createEntityManager();
        em.getTransaction().begin();
    }

    @Test
    public void size_when_a_ns_is_added() {
        assertEquals(0, em.createQuery("SELECT ns FROM NetworkService ns").getResultList().size());
        NetworkService ns = new NetworkService();
        ns.setName("ns1");
        em.persist(ns);
        assertEquals(1, em.createQuery("SELECT ns FROM NetworkService ns").getResultList().size());
    }

    @Test
    public void add_vnf_to_ns() {
        assertEquals(0, em.createQuery("SELECT vnf FROM VirtualNetworkFunction vnf").getResultList().size());

        VirtualNetworkFunction vnf = new VirtualNetworkFunction();
        vnf.setName("vnf1");
        vnf.setVnf_image("https://api.t-nova.eu/v1/nfstore/vnf/123/image");
        NetworkService ns = new NetworkService();
        ns.setName("ns2");
        ns.addVNF(vnf);
        em.persist(ns);

        NetworkService n = (NetworkService) em.createQuery("SELECT ns FROM NetworkService ns WHERE ns.name = 'ns2'").getResultList().get(0);
        n.addVNF(vnf);
        em.persist(n);
        assertEquals(2, em.createQuery("SELECT ns FROM NetworkService ns").getResultList().size());
        assertEquals(1, em.createQuery("SELECT vnf FROM VirtualNetworkFunction vnf").getResultList().size());
        assertEquals("vnf1", n.getVnfs().get(0).getName());

    }
}
