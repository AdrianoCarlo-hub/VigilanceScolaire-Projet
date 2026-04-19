package com.vigilance.vigilance.model;

import jakarta.persistence.*;
import org.springframework.format.annotation.DateTimeFormat; // IMPORT CRUCIAL
import java.util.Date;

@Entity
@Table(name = "absence")
public class AbsenceModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_absence;

    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "yyyy-MM-dd") // CORRECTION : Pour transformer le String du formulaire en Date
    private Date date_absence;

    private String motif;
    private boolean justifie;

    @ManyToOne
    @JoinColumn(name = "id_eleve", referencedColumnName = "id_eleve") // Précision de la colonne de référence
    private EleveModel eleve;

    // --- GETTERS ET SETTERS ---

    public Long getId_absence() {
        return id_absence;
    }

    public void setId_absence(Long id_absence) {
        this.id_absence = id_absence;
    }

    public Date getDate_absence() {
        return date_absence;
    }

    public void setDate_absence(Date date_absence) {
        this.date_absence = date_absence;
    }

    public EleveModel getEleve() {
        return eleve;
    }

    public void setEleve(EleveModel eleve) {
        this.eleve = eleve;
    }

    public boolean isJustifie() {
        return justifie;
    }

    public void setJustifie(boolean justifie) {
        this.justifie = justifie;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }
}