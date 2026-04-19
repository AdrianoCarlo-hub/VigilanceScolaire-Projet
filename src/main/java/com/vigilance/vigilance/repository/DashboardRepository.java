package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.dto.AdminDashboardDTO;
import com.vigilance.vigilance.dto.ProfessorDashboardDTO;
import java.util.List;
import java.util.Map;

public interface DashboardRepository {

    // ========== ADMIN ==========
    long countTotalEleves();
    long countTotalProfesseurs();
    long countTotalClasses();
    Map<String, Long> getElevesParClasse();
    Map<String, Long> getAbsencesParMois();
    Map<String, Long> getAbsencesJustifieesStats();
    List<AdminDashboardDTO.AlerteDTO> getTop5AlertesRecentes();

    // ========== PROFESSEUR ==========
    String getProfesseurNom(Long professeurId);
    long countElevesByProfesseurId(Long professeurId);
    long countClassesByProfesseurId(Long professeurId);
    Map<String, ProfessorDashboardDTO.ClasseStatsDTO> getStatsClassesByProfesseur(Long professeurId);
    Map<String, Long> getAbsencesParClasseByProfesseur(Long professeurId);
    Map<String, Long> getAbsencesJustifieesParClasseByProfesseur(Long professeurId);
}