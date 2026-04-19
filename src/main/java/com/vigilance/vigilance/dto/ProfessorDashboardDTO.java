package com.vigilance.vigilance.dto;

import java.util.List;
import java.util.Map;

public class ProfessorDashboardDTO {
    private String professeurNom;
    private long totalEleves;
    private long totalClasses;
    private double tauxAbsenceGlobal;

    private Map<String, ClasseStatsDTO> statsParClasse;
    private ChartDataDTO absenceParClasseChart;
    private ChartDataDTO absenceJustifieeParClasseChart;
    private List<ActionDTO> prochainesActions;

    public static class ClasseStatsDTO {
        private String classeNom;
        private long nombreEleves;
        private double tauxAbsence;
        private long absencesJustifiees;
        private long absencesNonJustifiees;

        public String getClasseNom() { return classeNom; }
        public void setClasseNom(String classeNom) { this.classeNom = classeNom; }
        public long getNombreEleves() { return nombreEleves; }
        public void setNombreEleves(long nombreEleves) { this.nombreEleves = nombreEleves; }
        public double getTauxAbsence() { return tauxAbsence; }
        public void setTauxAbsence(double tauxAbsence) { this.tauxAbsence = tauxAbsence; }
        public long getAbsencesJustifiees() { return absencesJustifiees; }
        public void setAbsencesJustifiees(long absencesJustifiees) { this.absencesJustifiees = absencesJustifiees; }
        public long getAbsencesNonJustifiees() { return absencesNonJustifiees; }
        public void setAbsencesNonJustifiees(long absencesNonJustifiees) { this.absencesNonJustifiees = absencesNonJustifiees; }
    }

    public static class ActionDTO {
        private String titre;
        private String description;
        private String date;
        private String type;
        private String lien;

        public String getTitre() { return titre; }
        public void setTitre(String titre) { this.titre = titre; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public String getLien() { return lien; }
        public void setLien(String lien) { this.lien = lien; }
    }

    // Getters et Setters
    public String getProfesseurNom() { return professeurNom; }
    public void setProfesseurNom(String professeurNom) { this.professeurNom = professeurNom; }
    public long getTotalEleves() { return totalEleves; }
    public void setTotalEleves(long totalEleves) { this.totalEleves = totalEleves; }
    public long getTotalClasses() { return totalClasses; }
    public void setTotalClasses(long totalClasses) { this.totalClasses = totalClasses; }
    public double getTauxAbsenceGlobal() { return tauxAbsenceGlobal; }
    public void setTauxAbsenceGlobal(double tauxAbsenceGlobal) { this.tauxAbsenceGlobal = tauxAbsenceGlobal; }
    public Map<String, ClasseStatsDTO> getStatsParClasse() { return statsParClasse; }
    public void setStatsParClasse(Map<String, ClasseStatsDTO> statsParClasse) { this.statsParClasse = statsParClasse; }
    public ChartDataDTO getAbsenceParClasseChart() { return absenceParClasseChart; }
    public void setAbsenceParClasseChart(ChartDataDTO absenceParClasseChart) { this.absenceParClasseChart = absenceParClasseChart; }
    public ChartDataDTO getAbsenceJustifieeParClasseChart() { return absenceJustifieeParClasseChart; }
    public void setAbsenceJustifieeParClasseChart(ChartDataDTO absenceJustifieeParClasseChart) { this.absenceJustifieeParClasseChart = absenceJustifieeParClasseChart; }
    public List<ActionDTO> getProchainesActions() { return prochainesActions; }
    public void setProchainesActions(List<ActionDTO> prochainesActions) { this.prochainesActions = prochainesActions; }
}