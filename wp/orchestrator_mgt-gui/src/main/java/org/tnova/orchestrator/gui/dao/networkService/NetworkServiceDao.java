package org.tnova.orchestrator.gui.dao.networkService;

import org.tnova.orchestrator.gui.dao.Dao;
import org.tnova.orchestrator.gui.entity.NetworkService;

/**
 * Definition of a Data Access Object that can perform CRUD Operations for
 * {@link NetworkService}s.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public interface NetworkServiceDao extends Dao<NetworkService, Long> {

    public void add(Long id, String name);
    public NetworkService findByName(String viName);
}
