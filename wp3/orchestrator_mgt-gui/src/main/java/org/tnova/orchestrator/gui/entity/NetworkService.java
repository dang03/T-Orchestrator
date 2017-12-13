package org.tnova.orchestrator.gui.entity;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.CascadeType;

import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OrderColumn;

import org.tnova.orchestrator.gui.JsonViews;
import org.codehaus.jackson.map.annotate.JsonView;

/**
 * JPA Annotated Pojo that represents a NetworkService.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
@javax.persistence.Entity
@NamedQueries({
    @NamedQuery(name = "NS.findByName", query = "SELECT t FROM NetworkService t WHERE t.name = :name")})
public class NetworkService implements Entity {

    @Id
    @GeneratedValue
    private Long id;
    @Column
    private String name;

    @Column
    private String description;

    @Column
    private Date created_at;

    @Column
    private Date updated_at;

    @OneToMany(cascade = {CascadeType.ALL}, fetch=FetchType.EAGER)
    @OrderColumn(name = "INDEX")
    private List<VirtualNetworkFunction> vnfs = new ArrayList<VirtualNetworkFunction>();

    public NetworkService() {
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

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public List<VirtualNetworkFunction> getVnfs() {
        return vnfs;
    }

    public void setVnfs(List<VirtualNetworkFunction> vnfs) {
        this.vnfs = vnfs;
    }

    public void addVNF(VirtualNetworkFunction vnf) {
        if (!vnfs.contains(vnf)) {
            vnfs.add(vnf);
        }
    }

    @Override
    public String toString() {
        return String.format("NSEntry[%s, %d]", this.name, this.id);
    }

}
