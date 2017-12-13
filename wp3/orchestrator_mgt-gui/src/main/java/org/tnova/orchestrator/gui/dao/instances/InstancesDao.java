package org.tnova.orchestrator.gui.dao.instances;

import org.tnova.orchestrator.gui.dao.Dao;
import org.tnova.orchestrator.gui.entity.Instance;

/**
 * Definition of a Data Access Object that can perform CRUD Operations for {@link InstancesDao}s.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public interface InstancesDao extends Dao<Instance, Long> {

    public Instance findByName(String viName);
}
