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
 * JPA Annotated Pojo that represents a VirtualNetworkFunction
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
@javax.persistence.Entity
@NamedQueries({
    @NamedQuery(name = "VirtualNetworkFunction.findByName", query = "SELECT t FROM VirtualNetworkFunction t WHERE t.name = :name")})
public class VirtualNetworkFunction implements Entity {

    @Id
    @GeneratedValue
    private Long id;

    @Column
    private String name;

    @Column
    private String description;

    @Column
    private String vnf_image;

    @Column
    private String vnf_manager;

    @Column
    private Date created_at;

    @Column
    private Date updated_at;

    public VirtualNetworkFunction() {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getVnf_image() {
        return vnf_image;
    }

    public void setVnf_image(String vnf_image) {
        this.vnf_image = vnf_image;
    }

    public String getVnf_manager() {
        return vnf_manager;
    }

    public void setVnf_manager(String vnf_manager) {
        this.vnf_manager = vnf_manager;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Date updated_at) {
        this.updated_at = updated_at;
    }

    @Override
    public String toString() {
        return String.format("VirtualNetworkFunction[%s, %d]", this.name, this.id);
    }

}
