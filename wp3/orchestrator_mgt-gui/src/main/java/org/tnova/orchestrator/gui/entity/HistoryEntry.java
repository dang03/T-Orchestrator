package org.tnova.orchestrator.gui.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import org.tnova.orchestrator.gui.JsonViews;

import org.codehaus.jackson.map.annotate.JsonView;

/**
 * JPA Annotated Pojo that represents a HistoryEntry.
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
@javax.persistence.Entity
public class HistoryEntry implements Entity {

    @Id
    @GeneratedValue
    private Long id;

    @Column
    private Date date;

    @Column
    private String content;
    
    @Column
    private String type;

    public HistoryEntry() {
        this.date = new Date();
    }

    @JsonView(JsonViews.Admin.class)
    public Long getId() {
        return this.id;
    }

    @JsonView(JsonViews.User.class)
    public Date getDate() {
        return this.date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    @JsonView(JsonViews.User.class)
    public String getContent() {
        return this.content;
    }

    public void setContent(String content) {
        this.content = content;
    }
    
    @JsonView(JsonViews.User.class)
    public String getType() {
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return String.format("HistoryEntry[%s, %d, %s]", this.type, this.id, this.content);
    }

}
