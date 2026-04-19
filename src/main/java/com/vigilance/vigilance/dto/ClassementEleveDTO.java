package com.vigilance.vigilance.dto;

public class ClassementEleveDTO {
    private Long idEleve;
    private String nom;
    private String prenom;
    private String matricule;
    private double moyenneGenerale;
    private int rang;

    // Constructeur avec 4 paramètres (sans matricule)
    public ClassementEleveDTO(Long idEleve, String nom, String prenom, double moyenneGenerale, int rang) {
        this.idEleve = idEleve;
        this.nom = nom;
        this.prenom = prenom;
        this.matricule = "";
        this.moyenneGenerale = moyenneGenerale;
        this.rang = rang;
    }

    // Constructeur avec 5 paramètres (avec matricule)
    public ClassementEleveDTO(Long idEleve, String nom, String prenom, String matricule, double moyenneGenerale, int rang) {
        this.idEleve = idEleve;
        this.nom = nom;
        this.prenom = prenom;
        this.matricule = matricule;
        this.moyenneGenerale = moyenneGenerale;
        this.rang = rang;
    }

    // Constructeur par défaut
    public ClassementEleveDTO() {}

    // Getters et Setters
    public Long getIdEleve() { return idEleve; }
    public void setIdEleve(Long idEleve) { this.idEleve = idEleve; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public double getMoyenneGenerale() { return moyenneGenerale; }
    public void setMoyenneGenerale(double moyenneGenerale) { this.moyenneGenerale = moyenneGenerale; }

    public int getRang() { return rang; }
    public void setRang(int rang) { this.rang = rang; }
}