package com.vigilance.vigilance.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "evenement")
public class EvenementModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_evenement;

    private String type;
    private String description;
    private String gravite;

    @Temporal(TemporalType.TIMESTAMP)
    private Date date_evenement;

    @ManyToOne
    @JoinColumn(name = "id_eleve")
    private EleveModel eleve;

    //getter setter


    public Long getId_evenement() {
        return id_evenement;
    }

    public void setId_evenement(Long id_evenement) {
        this.id_evenement = id_evenement;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDate_evenement() {
        return date_evenement;
    }

    public void setDate_evenement(Date date_evenement) {
        this.date_evenement = date_evenement;
    }

    public EleveModel getEleve() {
        return eleve;
    }

    public void setEleve(EleveModel eleve) {
        this.eleve = eleve;
    }

    public String getGravite() {
        return gravite;
    }

    public void setGravite(String gravite) {
        this.gravite = gravite;
    }
}