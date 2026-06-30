package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.AbsenceModel;
import com.vigilance.vigilance.model.AlerteModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.repository.AbsenceRepository;
import com.vigilance.vigilance.repository.AlerteRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

@Service
public class AbsenceService {

    private final AbsenceRepository repository;
    private final AlerteService alerteService;
    private final AlerteRepository alerteRepository;

    public AbsenceService(AbsenceRepository repository, AlerteService alerteService, AlerteRepository alerteRepository) {
        this.repository = repository;
        this.alerteService = alerteService;
        this.alerteRepository = alerteRepository;
    }

    // Récupération paginée et filtrée (Recherche AJAX)
    public Page<AbsenceModel> getAbsencesPaginated(String search, Long profId, Pageable pageable) {
        String safeSearch = search == null ? "" : search.trim().toLowerCase();
        if (profId == null) {
            return repository.findAllWithEleveAndClassePaginated(safeSearch, pageable);
        } else {
            return repository.findAbsencesByProfesseurIdPaginated(profId, safeSearch, pageable);
        }
    }

    public List<AbsenceModel> getAbsencesByClasseId(Long classId) {
        return repository.findAbsencesByClassId(classId);
    }

    public AbsenceModel getAbsenceById(Long id) {
        return repository.findById(id).orElse(null);
    }

    @Transactional
    public void saveAbsence(AbsenceModel absence) {
        repository.save(absence);

        if (!absence.isJustifie()) {
            long nbAbsences = repository.compterAbsencesNonJustifiees(absence.getEleve().getId_eleve());

            if (nbAbsences >= 3) {
                declencherVigilanceAbsence(absence, nbAbsences);
            }
        }
    }

    private void declencherVigilanceAbsence(AbsenceModel absence, long total) {
        AlerteModel alerteAuto = new AlerteModel();
        alerteAuto.setEleve(absence.getEleve());
        alerteAuto.setType("ABSENCE_REPETEE");
        alerteAuto.setCanal("SMS");

        String message = "Vigilance Scolaire : L'élève " + absence.getEleve().getPrenom() + " " + absence.getEleve().getNom() +
                " totalise désormais " + total + " absences non justifiées. " +
                "Merci de contacter l'établissement rapidement.";

        alerteAuto.setMessage(message);
        alerteAuto.setStatut("NON_LU");
        alerteAuto.setDateAlerte(java.time.LocalDateTime.now());

        alerteRepository.save(alerteAuto);
    }

    public void deleteAbsence(Long id) {
        repository.deleteById(id);
    }

    // Statistiques du Dashboard
    public Map<String, Object> getStatistiques(UtilisateurModel user, boolean isAdmin) {
        Long profId = isAdmin ? null : (user != null ? user.getId_utilisateur() : null);

        Map<String, Object> stats = new HashMap<>();
        stats.put("total", repository.countTotalAbsences(profId));
        stats.put("justifiees", repository.countJustifie(profId));
        stats.put("nonJustifiees", repository.countNonJustifie(profId));
        stats.put("absentsAujourdHui", repository.countAbsentsAujourdHui(LocalDate.now(), profId));

        List<Object[]> classeMax = repository.findClassePlusTouchee(profId);
        stats.put("classePlusTouchee", classeMax.isEmpty() ? "Aucune" : classeMax.get(0)[0]);

        List<Object[]> eleveMax = repository.findElevePlusAbsent(profId);
        stats.put("elevePlusAbsent", eleveMax.isEmpty() ? "Aucun" : eleveMax.get(0)[1] + " " + eleveMax.get(0)[0]);

        return stats;
    }
}