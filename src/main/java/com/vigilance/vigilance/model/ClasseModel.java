package com.vigilance.vigilance.model;

import jakarta.persistence.*;

@Entity
@Table(name = "classe")
public class ClasseModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_classe;

    private String nom;
    private String niveau;
    private String annee_scolaire;

    // AJOUT DE LA RELATION AVEC L'UTILISATEUR (LE PROFESSEUR)
    @ManyToOne
    @JoinColumn(name = "id_utilisateur") // Doit correspondre à la colonne SQL dans ta table 'classe'
    private UtilisateurModel utilisateur;

    // Getters et Setters existants
    public Long getId_classe() { return id_classe; }
    public void setId_classe(Long id_classe) { this.id_classe = id_classe; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getNiveau() { return niveau; }
    public void setNiveau(String niveau) { this.niveau = niveau; }

    public String getAnnee_scolaire() { return annee_scolaire; }
    public void setAnnee_scolaire(String annee_scolaire) { this.annee_scolaire = annee_scolaire; }

    // NOUVEAUX GETTER / SETTER POUR L'UTILISATEUR
    public UtilisateurModel getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(UtilisateurModel utilisateur) {
        this.utilisateur = utilisateur;
    }
}