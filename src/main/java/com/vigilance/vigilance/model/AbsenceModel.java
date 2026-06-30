package com.vigilance.vigilance.model;

import jakarta.persistence.*;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

@Entity
@Table(name = "absence")
public class AbsenceModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_absence;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date_absence;  // ← LocalDate au lieu de Date

    private String motif;
    private boolean justifie;

    @ManyToOne
    @JoinColumn(name = "id_eleve", referencedColumnName = "id_eleve")
    private EleveModel eleve;

    // ========== CONSTRUCTEURS ==========

    public AbsenceModel() {}

    public AbsenceModel(EleveModel eleve, LocalDate date_absence, String motif, boolean justifie) {
        this.eleve = eleve;
        this.date_absence = date_absence;
        this.motif = motif;
        this.justifie = justifie;
    }

    // ========== GETTERS ET SETTERS ==========

    public Long getId_absence() {
        return id_absence;
    }

    public void setId_absence(Long id_absence) {
        this.id_absence = id_absence;
    }

    public LocalDate getDate_absence() {
        return date_absence;
    }

    public void setDate_absence(LocalDate date_absence) {
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