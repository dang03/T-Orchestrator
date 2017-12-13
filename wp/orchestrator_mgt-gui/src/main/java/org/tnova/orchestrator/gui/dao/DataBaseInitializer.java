package org.tnova.orchestrator.gui.dao;

import java.util.ArrayList;
import static org.hsqldb.Tokens.T;

import org.tnova.orchestrator.gui.dao.instances.InstancesDao;
import org.tnova.orchestrator.gui.dao.monitoringData.MonitoringDataDao;
import org.tnova.orchestrator.gui.dao.networkService.NetworkServiceDao;
import org.tnova.orchestrator.gui.dao.virtualNetworkFunction.VirtualNetworkFunctionDao;
import org.tnova.orchestrator.gui.dao.user.UserDao;
import org.tnova.orchestrator.gui.entity.Instance;
import org.tnova.orchestrator.gui.entity.MonitoringData;
import org.tnova.orchestrator.gui.entity.NetworkService;
import org.tnova.orchestrator.gui.entity.User;
import org.tnova.orchestrator.gui.entity.VirtualNetworkFunction;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Initialize the database with some test entries.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class DataBaseInitializer {

    private NetworkServiceDao networkServiceDao;

    private VirtualNetworkFunctionDao virtualNetworkFunctionDao;

    private InstancesDao instancesDao;

    private MonitoringDataDao monitoringDataDao;

    private UserDao userDao;

    private PasswordEncoder passwordEncoder;

    protected DataBaseInitializer() {
        /* Default constructor for reflection instantiation */
    }

    public DataBaseInitializer(UserDao userDao, NetworkServiceDao networkServiceDao, VirtualNetworkFunctionDao virtualNetworkFunctionDao, InstancesDao instancesDao, MonitoringDataDao monitoringDataDao, PasswordEncoder passwordEncoder) {
        this.userDao = userDao;
        this.networkServiceDao = networkServiceDao;
        this.virtualNetworkFunctionDao = virtualNetworkFunctionDao;
        this.instancesDao = instancesDao;
        this.monitoringDataDao = monitoringDataDao;
        this.passwordEncoder = passwordEncoder;
    }

    public void initDataBase() {
        createUsers();

        createNS();

        VirtualNetworkFunction vnf = new VirtualNetworkFunction();
        vnf.setName("vnf1");
        vnf.setVnf_image("https://api.t-nova.eu/v1/nfstore/vnf/123/image");
//        this.virtualNetworkFunctionDao.save(vnf);
        
        VirtualNetworkFunction vnf2 = new VirtualNetworkFunction();
        vnf2.setName("vnf2");
        vnf2.setVnf_image("https://api.t-nova.eu/v1/nfstore/vnf/456/image");
//        this.virtualNetworkFunctionDao.save(vnf);

        NetworkService t = this.networkServiceDao.find((long) 1);
        t.addVNF(vnf);
        t.addVNF(vnf2);
        this.networkServiceDao.save(t);
        
        createInstances();
        createMonitoringData();
    }
    
    private void createNS(){
        NetworkService ns = new NetworkService();
        ns.setName("ns1");
        this.networkServiceDao.save(ns);
        ns = new NetworkService();
        ns.setName("ns2");
        this.networkServiceDao.save(ns);
    }
    
    private void createInstances(){
        Instance ins = new Instance();
        ins.setName("Instance1");
        ins.setType(0);
        ins.setStatus("stopped");
        ins.setNs_id("1");
        this.instancesDao.save(ins);
        ins = new Instance();
        ins.setName("Instance2");
        ins.setType(0);
        ins.setNs_id("1");
        ins.setStatus("stopped");//running
        this.instancesDao.save(ins);
        ins = new Instance();
        ins.setName("Instance3");
        ins.setType(1);
        ins.setStatus("stopped");
        ins.setNs_id("1");
        this.instancesDao.save(ins);
    }
    
    private void createMonitoringData(){
        MonitoringData mData = new MonitoringData();
        mData.setName("mData1");
        mData.setMetric1("value1");
        mData.setMetric2("value2");
        mData.setMetric3("value3");
        this.monitoringDataDao.save(mData);
    }
    
    private void createUsers(){
        User userUser = new User("user", this.passwordEncoder.encode("user"));
        userUser.addRole("user");
        this.userDao.save(userUser);

        User tnovaUser = new User("tnova", this.passwordEncoder.encode("tnova"));
        tnovaUser.addRole("user");
        tnovaUser.addRole("admin");
        this.userDao.save(tnovaUser);
        
        User adminUser = new User("admin", this.passwordEncoder.encode("admin"));
        adminUser.addRole("user");
        adminUser.addRole("admin");
        this.userDao.save(adminUser);
    }
}

