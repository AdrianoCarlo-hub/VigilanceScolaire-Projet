package com.vigilance.vigilance.dto;

import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.model.EleveModel;
import java.util.Date;
import java.util.List;

public class BulletinDTO {
    private EleveModel eleve;
    private ClasseModel classe;
    private String periode;
    private Date dateDebut;
    private Date dateFin;
    private Date dateEdition;
    private List<MatiereNoteDTO> matieres;
    private double moyenneGenerale;
    private int rang;
    private int totalEleves;
    private String appreciation;
    private String nomProfesseurPrincipal;

    public BulletinDTO() {}

    // Getters et Setters
    public EleveModel getEleve() { return eleve; }
    public void setEleve(EleveModel eleve) { this.eleve = eleve; }

    public ClasseModel getClasse() { return classe; }
    public void setClasse(ClasseModel classe) { this.classe = classe; }

    public String getPeriode() { return periode; }
    public void setPeriode(String periode) { this.periode = periode; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public Date getDateEdition() { return dateEdition; }
    public void setDateEdition(Date dateEdition) { this.dateEdition = dateEdition; }

    public List<MatiereNoteDTO> getMatieres() { return matieres; }
    public void setMatieres(List<MatiereNoteDTO> matieres) { this.matieres = matieres; }

    public double getMoyenneGenerale() { return moyenneGenerale; }
    public void setMoyenneGenerale(double moyenneGenerale) { this.moyenneGenerale = moyenneGenerale; }

    public int getRang() { return rang; }
    public void setRang(int rang) { this.rang = rang; }

    public int getTotalEleves() { return totalEleves; }
    public void setTotalEleves(int totalEleves) { this.totalEleves = totalEleves; }

    public String getAppreciation() { return appreciation; }
    public void setAppreciation(String appreciation) { this.appreciation = appreciation; }

    public String getNomProfesseurPrincipal() { return nomProfesseurPrincipal; }
    public void setNomProfesseurPrincipal(String nomProfesseurPrincipal) { this.nomProfesseurPrincipal = nomProfesseurPrincipal; }
}