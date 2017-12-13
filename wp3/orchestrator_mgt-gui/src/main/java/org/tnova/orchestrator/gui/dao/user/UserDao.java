package org.tnova.orchestrator.gui.dao.user;

import org.tnova.orchestrator.gui.dao.Dao;
import org.tnova.orchestrator.gui.entity.User;

import org.springframework.security.core.userdetails.UserDetailsService;

public interface UserDao extends Dao<User, Long>, UserDetailsService {

    User findByName(String name);

}
