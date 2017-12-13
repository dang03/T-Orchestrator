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
 * JPA Annotated Pojo that represents a MonitoringData.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
@javax.persistence.Entity
@NamedQueries({  
    @NamedQuery(name = "MonitoringData.findByName", query = "SELECT t FROM MonitoringData t WHERE t.name = :name")})  
public class MonitoringData implements Entity {

    @Id
    @GeneratedValue
    private Long id;
    
    @Column
    private String name;
    
    @Column
    private Date created_at;
    
    @Column
    private Date updated_at;
    
    @Column
    private String metric1;
    
    @Column
    private String metric2;
    
    @Column
    private String metric3;

    public MonitoringData() {
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
    
    public Date getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}

	public String getMetric1() {
		return metric1;
	}

	public void setMetric1(String metric1) {
		this.metric1 = metric1;
	}

	public String getMetric2() {
		return metric2;
	}

	public void setMetric2(String metric2) {
		this.metric2 = metric2;
	}

	public String getMetric3() {
		return metric3;
	}

	public void setMetric3(String metric3) {
		this.metric3 = metric3;
	}

	@Override
    public String toString() {
        return String.format("mData[%s, %d]", this.name, this.id);
    }

}
