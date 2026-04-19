package com.vigilance.vigilance.model;

import jakarta.persistence.*;

@Entity
@Table(name = "parent")
public class ParentModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_parent;

    private String nom;
    private String prenom;
    private String telephone;
    private String email;
    private String adresse;

    //getter setter


    public Long getId_parent() {
        return id_parent;
    }

    public void setId_parent(Long id_parent) {
        this.id_parent = id_parent;
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

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }
}