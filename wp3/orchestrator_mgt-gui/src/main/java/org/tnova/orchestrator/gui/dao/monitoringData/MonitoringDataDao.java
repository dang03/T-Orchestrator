package org.tnova.orchestrator.gui.dao.monitoringData;

import org.tnova.orchestrator.gui.dao.Dao;
import org.tnova.orchestrator.gui.entity.MonitoringData;


/**
 * Definition of a Data Access Object that can perform CRUD Operations for {@link MonitoringData}s.
 * 
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public interface MonitoringDataDao extends Dao<MonitoringData, Long>{

    public MonitoringData findByName(String spName);

}