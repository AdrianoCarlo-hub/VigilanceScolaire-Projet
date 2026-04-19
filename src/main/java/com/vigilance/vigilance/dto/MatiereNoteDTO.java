package com.vigilance.vigilance.dto;

public class MatiereNoteDTO {
    private String matiere;
    private double note;
    private int coefficient;
    private double total;
    private double moyenneClasse;

    public MatiereNoteDTO() {}

    public MatiereNoteDTO(String matiere, double note, int coefficient, double total) {
        this.matiere = matiere;
        this.note = note;
        this.coefficient = coefficient;
        this.total = total;
    }

    // Getters et Setters
    public String getMatiere() { return matiere; }
    public void setMatiere(String matiere) { this.matiere = matiere; }

    public double getNote() { return note; }
    public void setNote(double note) { this.note = note; }

    public int getCoefficient() { return coefficient; }
    public void setCoefficient(int coefficient) { this.coefficient = coefficient; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public double getMoyenneClasse() { return moyenneClasse; }
    public void setMoyenneClasse(double moyenneClasse) { this.moyenneClasse = moyenneClasse; }
}