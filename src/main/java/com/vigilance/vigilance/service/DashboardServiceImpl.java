package com.vigilance.vigilance.service;

import com.vigilance.vigilance.dto.AdminDashboardDTO;
import com.vigilance.vigilance.dto.ChartDataDTO;
import com.vigilance.vigilance.dto.ProfessorDashboardDTO;
import com.vigilance.vigilance.repository.DashboardRepository;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class DashboardServiceImpl implements DashboardService {

    private final DashboardRepository dashboardRepository;

    public DashboardServiceImpl(DashboardRepository dashboardRepository) {
        this.dashboardRepository = dashboardRepository;
    }

    @Override
    public AdminDashboardDTO getAdminDashboard() {
        AdminDashboardDTO dto = new AdminDashboardDTO();

        // Stats globales
        dto.setTotalEleves(dashboardRepository.countTotalEleves());
        dto.setTotalProfesseurs(dashboardRepository.countTotalProfesseurs());
        dto.setTotalClasses(dashboardRepository.countTotalClasses());

        // Calcul taux assiduité
        Map<String, Long> absencesMois = dashboardRepository.getAbsencesParMois();
        long totalAbsences = absencesMois.values().stream().mapToLong(Long::longValue).sum();
        long joursEcole = 20;
        double taux;
        if (dto.getTotalEleves() > 0) {
            taux = ((dto.getTotalEleves() * joursEcole - totalAbsences) * 100.0) / (dto.getTotalEleves() * joursEcole);
        } else {
            taux = 0;
        }
        dto.setTauxAssiduiteGlobal(Math.round(Math.max(0, taux) * 100.0) / 100.0);

        // Graphique 1: Répartition des élèves par classe
        Map<String, Long> elevesParClasse = dashboardRepository.getElevesParClasse();

        List<String> classLabels = new ArrayList<>(elevesParClasse.keySet());
        List<Long> classData = new ArrayList<>(elevesParClasse.values());

        // Données d'exemple si vides
        if (classLabels.isEmpty()) {
            classLabels = Arrays.asList("Terminale", "7ème", "6ème", "5ème");
            classData = Arrays.asList(25L, 30L, 28L, 22L);
        }

        dto.setRepartitionClassesChart(new ChartDataDTO(classLabels, classData));
        dto.setElevesParClasse(elevesParClasse);

        // Graphique 2: Absences par mois
        Map<String, Long> absencesParMois = dashboardRepository.getAbsencesParMois();

        List<String> moisLabels = new ArrayList<>(absencesParMois.keySet());
        List<Long> moisData = new ArrayList<>(absencesParMois.values());

        if (moisLabels.isEmpty()) {
            moisLabels = Arrays.asList("Jan", "Fév", "Mar", "Avr", "Mai", "Juin");
            moisData = Arrays.asList(12L, 15L, 8L, 10L, 14L, 9L);
        }

        dto.setAssiduiteMensuelleChart(new ChartDataDTO(moisLabels, moisData));

        // Graphique 3: Absences justifiées vs non justifiées
        Map<String, Long> absencesJustifiees = dashboardRepository.getAbsencesJustifieesStats();

        List<String> justifieLabels = new ArrayList<>(absencesJustifiees.keySet());
        List<Long> justifieData = new ArrayList<>(absencesJustifiees.values());

        if (justifieLabels.isEmpty()) {
            justifieLabels = Arrays.asList("Justifiées", "Non justifiées");
            justifieData = Arrays.asList(18L, 42L);
        }

        dto.setAbsencesJustifieesChart(new ChartDataDTO(justifieLabels, justifieData));

        // Alertes
        dto.setAlertesRecentes(dashboardRepository.getTop5AlertesRecentes());

        return dto;
    }

    @Override
    public ProfessorDashboardDTO getProfessorDashboard(Long professeurId) {
        ProfessorDashboardDTO dto = new ProfessorDashboardDTO();

        dto.setProfesseurNom(dashboardRepository.getProfesseurNom(professeurId));
        dto.setTotalEleves(dashboardRepository.countElevesByProfesseurId(professeurId));
        dto.setTotalClasses(dashboardRepository.countClassesByProfesseurId(professeurId));

        Map<String, ProfessorDashboardDTO.ClasseStatsDTO> stats = dashboardRepository.getStatsClassesByProfesseur(professeurId);
        dto.setStatsParClasse(stats);

        double avgTaux = stats.values().stream().mapToDouble(ProfessorDashboardDTO.ClasseStatsDTO::getTauxAbsence).average().orElse(0);
        dto.setTauxAbsenceGlobal(Math.round(avgTaux * 100.0) / 100.0);

        // Graphique absences par classe
        Map<String, Long> absencesParClasse = dashboardRepository.getAbsencesParClasseByProfesseur(professeurId);
        List<String> classeLabels = new ArrayList<>(absencesParClasse.keySet());
        List<Long> classeData = new ArrayList<>(absencesParClasse.values());

        if (classeLabels.isEmpty()) {
            classeLabels = Arrays.asList("Terminale", "7ème");
            classeData = Arrays.asList(25L, 30L);
        }
        dto.setAbsenceParClasseChart(new ChartDataDTO(classeLabels, classeData));

        // Graphique absences justifiées par classe
        Map<String, Long> absencesJustifiees = dashboardRepository.getAbsencesJustifieesParClasseByProfesseur(professeurId);
        List<String> justifieLabels = new ArrayList<>(absencesJustifiees.keySet());
        List<Long> justifieData = new ArrayList<>(absencesJustifiees.values());

        if (justifieLabels.isEmpty()) {
            justifieLabels = Arrays.asList("Terminale", "7ème");
            justifieData = Arrays.asList(10L, 12L);
        }
        dto.setAbsenceJustifieeParClasseChart(new ChartDataDTO(justifieLabels, justifieData));

        // Actions
        List<ProfessorDashboardDTO.ActionDTO> actions = new ArrayList<>();
        ProfessorDashboardDTO.ActionDTO action1 = new ProfessorDashboardDTO.ActionDTO();
        action1.setTitre("📝 Relevé des absences");
        action1.setDescription("Mettre à jour les absences de la semaine");
        action1.setDate(LocalDate.now().plusDays(1).format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        action1.setType("warning");
        action1.setLien("/absence/add");
        actions.add(action1);

        ProfessorDashboardDTO.ActionDTO action2 = new ProfessorDashboardDTO.ActionDTO();
        action2.setTitre("📊 Saisie des notes");
        action2.setDescription("Les notes du dernier examen doivent être saisies");
        action2.setDate(LocalDate.now().plusDays(3).format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        action2.setType("info");
        action2.setLien("/note/add");
        actions.add(action2);

        dto.setProchainesActions(actions);

        return dto;
    }
}