package com.vigilance.vigilance.dto;

import java.util.List;
import java.util.Map;

public class AdminDashboardDTO {
    // Statistiques globales
    private long totalEleves;
    private long totalProfesseurs;
    private long totalClasses;
    private double tauxAssiduiteGlobal;

    // Graphiques
    private ChartDataDTO repartitionClassesChart;
    private ChartDataDTO assiduiteMensuelleChart;
    private ChartDataDTO absencesJustifieesChart;

    // Alertes récentes
    private List<AlerteDTO> alertesRecentes;

    // Données brutes
    private Map<String, Long> elevesParClasse;

    // Inner class pour les alertes
    public static class AlerteDTO {
        private Long id;
        private String message;
        private String type;
        private String date;
        private String eleveNom;

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public String getEleveNom() { return eleveNom; }
        public void setEleveNom(String eleveNom) { this.eleveNom = eleveNom; }
    }

    // Getters et Setters
    public long getTotalEleves() { return totalEleves; }
    public void setTotalEleves(long totalEleves) { this.totalEleves = totalEleves; }
    public long getTotalProfesseurs() { return totalProfesseurs; }
    public void setTotalProfesseurs(long totalProfesseurs) { this.totalProfesseurs = totalProfesseurs; }
    public long getTotalClasses() { return totalClasses; }
    public void setTotalClasses(long totalClasses) { this.totalClasses = totalClasses; }
    public double getTauxAssiduiteGlobal() { return tauxAssiduiteGlobal; }
    public void setTauxAssiduiteGlobal(double tauxAssiduiteGlobal) { this.tauxAssiduiteGlobal = tauxAssiduiteGlobal; }
    public ChartDataDTO getRepartitionClassesChart() { return repartitionClassesChart; }
    public void setRepartitionClassesChart(ChartDataDTO repartitionClassesChart) { this.repartitionClassesChart = repartitionClassesChart; }
    public ChartDataDTO getAssiduiteMensuelleChart() { return assiduiteMensuelleChart; }
    public void setAssiduiteMensuelleChart(ChartDataDTO assiduiteMensuelleChart) { this.assiduiteMensuelleChart = assiduiteMensuelleChart; }
    public ChartDataDTO getAbsencesJustifieesChart() { return absencesJustifieesChart; }
    public void setAbsencesJustifieesChart(ChartDataDTO absencesJustifieesChart) { this.absencesJustifieesChart = absencesJustifieesChart; }
    public List<AlerteDTO> getAlertesRecentes() { return alertesRecentes; }
    public void setAlertesRecentes(List<AlerteDTO> alertesRecentes) { this.alertesRecentes = alertesRecentes; }
    public Map<String, Long> getElevesParClasse() { return elevesParClasse; }
    public void setElevesParClasse(Map<String, Long> elevesParClasse) { this.elevesParClasse = elevesParClasse; }
}