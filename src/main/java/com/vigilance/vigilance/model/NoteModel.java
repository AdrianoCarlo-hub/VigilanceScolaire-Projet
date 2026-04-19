package com.vigilance.vigilance.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "note")
public class NoteModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_note;

    private String matiere;
    private double valeur;
    private int coefficient;

    @Temporal(TemporalType.DATE)
    private Date date_note;

    @ManyToOne
    @JoinColumn(name = "id_eleve")
    private EleveModel eleve;

    // getter setter


    public Long getId_note() {
        return id_note;
    }

    public void setId_note(Long id_note) {
        this.id_note = id_note;
    }

    public String getMatiere() {
        return matiere;
    }

    public void setMatiere(String matiere) {
        this.matiere = matiere;
    }

    public double getValeur() {
        return valeur;
    }

    public void setValeur(double valeur) {
        this.valeur = valeur;
    }

    public int getCoefficient() {
        return coefficient;
    }

    public void setCoefficient(int coefficient) {
        this.coefficient = coefficient;
    }

    public Date getDate_note() {
        return date_note;
    }

    public void setDate_note(Date date_note) {
        this.date_note = date_note;
    }

    public EleveModel getEleve() {
        return eleve;
    }

    public void setEleve(EleveModel eleve) {
        this.eleve = eleve;
    }
}