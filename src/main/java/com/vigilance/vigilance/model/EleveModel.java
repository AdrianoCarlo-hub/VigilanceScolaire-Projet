package com.vigilance.vigilance.model;

import jakarta.persistence.*;
import org.springframework.format.annotation.DateTimeFormat; // Import nécessaire
import java.util.Date;

@Entity
@Table(name = "eleve")
public class EleveModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_eleve;

    private String nom;
    private String prenom;

    // CORRECTION : Permet à Spring de convertir le String du formulaire en Date Java
    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date date_naissance;

    private String sexe;
    private String photo;
    private String matricule;

    @ManyToOne
    @JoinColumn(name = "id_parent", referencedColumnName = "id_parent")
    private ParentModel parent;

    @ManyToOne
    @JoinColumn(name = "id_classe", referencedColumnName = "id_classe")
    private ClasseModel classe;

    // --- GETTERS ET SETTERS ---

    public Long getId_eleve() {
        return id_eleve;
    }

    public void setId_eleve(Long id_eleve) {
        this.id_eleve = id_eleve;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public Date getDate_naissance() {
        return date_naissance;
    }

    public void setDate_naissance(Date date_naissance) {
        this.date_naissance = date_naissance;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getMatricule() {
        return matricule;
    }

    public void setMatricule(String matricule) {
        this.matricule = matricule;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public ParentModel getParent() {
        return parent;
    }

    public void setParent(ParentModel parent) {
        this.parent = parent;
    }

    public ClasseModel getClasse() {
        return classe;
    }

    public void setClasse(ClasseModel classe) {
        this.classe = classe;
    }
}