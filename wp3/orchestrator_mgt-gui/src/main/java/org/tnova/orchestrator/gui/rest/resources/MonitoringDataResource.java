package org.tnova.orchestrator.gui.rest.resources;

import java.io.IOException;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;

import org.tnova.orchestrator.gui.JsonViews;
import org.tnova.orchestrator.gui.dao.monitoringData.MonitoringDataDao;
import org.tnova.orchestrator.gui.entity.MonitoringData;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.ObjectWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
@Path("/mData")
public class MonitoringDataResource {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private MonitoringDataDao monitoringDataDao;

    @Autowired
    private ObjectMapper mapper;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String list() throws JsonGenerationException, JsonMappingException, IOException {
        this.logger.info("list()");

        ObjectWriter viewWriter;
        if (this.isAdmin()) {
            viewWriter = this.mapper.writerWithView(JsonViews.Admin.class);
        } else {
            viewWriter = this.mapper.writerWithView(JsonViews.User.class);
        }
        List<MonitoringData> allEntries = this.monitoringDataDao.findAll();

        return viewWriter.writeValueAsString(allEntries);
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id}")
    public MonitoringData read(@PathParam("id") Long id) {
        this.logger.info("read(id)");

        MonitoringData historyEntry = this.monitoringDataDao.find(id);
        if (historyEntry == null) {
            throw new WebApplicationException(404);
        }
        return historyEntry;
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public MonitoringData create(MonitoringData historyEntry) {
        this.logger.info("create(): " + historyEntry);

        return this.monitoringDataDao.save(historyEntry);
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("{id}")
    public MonitoringData update(@PathParam("id") Long id, MonitoringData historyEntry) {
        this.logger.info("update(): " + historyEntry);

        return this.monitoringDataDao.save(historyEntry);
    }

    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Path("{id}")
    public void delete(@PathParam("id") Long id) {
        this.logger.info("delete(id)");

        this.monitoringDataDao.delete(id);
    }
    
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/getVIByName/{viName}")
    public MonitoringData getVIByName( @PathParam("viName")String viName) {
        this.logger.info("get vi by Name "+viName);

        return this.monitoringDataDao.findByName(viName);
    }
    
    private boolean isAdmin() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Object principal = authentication.getPrincipal();
        if (principal instanceof String && ((String) principal).equals("anonymousUser")) {
            return false;
        }
        UserDetails userDetails = (UserDetails) principal;

        for (GrantedAuthority authority : userDetails.getAuthorities()) {
            if (authority.toString().equals("admin")) {
                return true;
            }
        }

        return false;
    }

}
