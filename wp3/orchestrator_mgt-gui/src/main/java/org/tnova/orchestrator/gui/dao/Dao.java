package org.tnova.orchestrator.gui.dao;

import java.util.List;

import org.tnova.orchestrator.gui.entity.Entity;

public interface Dao<T extends Entity, I> {

    List<T> findAll();

    T find(I id);

    T save(T entry);

    void delete(I id);

}
