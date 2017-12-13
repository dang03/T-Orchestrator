package org.tnova.orchestrator.gui.dao.virtualNetworkFunction;

import org.tnova.orchestrator.gui.dao.Dao;
import org.tnova.orchestrator.gui.entity.VirtualNetworkFunction;


/**
 * Definition of a Data Access Object that can perform CRUD Operations for {@link VirtualNetworkFunction}s.
 * 
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public interface VirtualNetworkFunctionDao extends Dao<VirtualNetworkFunction, Long>{

    public VirtualNetworkFunction findByName(String spName);

}