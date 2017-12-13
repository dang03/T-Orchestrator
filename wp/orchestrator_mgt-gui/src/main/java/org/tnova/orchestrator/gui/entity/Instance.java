package org.tnova.orchestrator.gui.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import org.tnova.orchestrator.gui.JsonViews;
import org.codehaus.jackson.map.annotate.JsonView;

/**
 * JPA Annotated Pojo that represents a NetworkService.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
@javax.persistence.Entity
@NamedQueries({  
    @NamedQuery(name = "Instance.findByName", query = "SELECT t FROM Instance t WHERE t.name = :name")})  
public class Instance implements Entity {

    @Id
    @GeneratedValue
    private Long id;
    
    @Column
    private String name;
    
    @Column
    private String ns_id;
    
    @Column
    private String status;
    
    @Column
    private Date created_at;
    
    @Column
    private Date updated_at;
    
    @Column
    private int type;
    
    @Column
    private MonitoringData mData;

    public Instance() {
        this.created_at = new Date();
    }

    @JsonView(JsonViews.User.class)
    public Long getId() {
        return this.id;
    }

    @JsonView(JsonViews.User.class)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    public String getNs_id() {
		return ns_id;
	}

	public void setNs_id(String ns_id) {
		this.ns_id = ns_id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public MonitoringData getmData() {
		return mData;
	}

	public void setmData(MonitoringData mData) {
		this.mData = mData;
	}

	@Override
    public String toString() {
        return String.format("InstanceEntry[%s, %d]", this.name, this.id);
    }

}
