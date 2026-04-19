package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.AbsenceModel;
import com.vigilance.vigilance.model.AlerteModel;
import com.vigilance.vigilance.repository.AbsenceRepository;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class AbsenceService {

    private final AbsenceRepository repository;
    private final AlerteService alerteService;

    public AbsenceService(AbsenceRepository repository, AlerteService alerteService) {
        this.repository = repository;
        this.alerteService = alerteService;
    }

    // ADMIN : toutes les absences
    public List<AbsenceModel> getAllAbsences() {
        return repository.findAllWithEleveAndClasse();
    }

    // PROFESSEUR : absences de ses classes
    public List<AbsenceModel> getAbsencesByProfesseurId(Long profId) {
        return repository.findAbsencesByProfesseurId(profId);
    }

    // ADMIN : groupées par classe
    public Map<String, List<AbsenceModel>> getAbsencesGroupedByClass() {
        Map<String, List<AbsenceModel>> groupedMap = new LinkedHashMap<>();
        List<String> classNames = repository.findAllDistinctClassNamesWithAbsences();

        for (String className : classNames) {
            List<AbsenceModel> absences = new ArrayList<>();
            for (AbsenceModel absence : repository.findAllWithEleveAndClasse()) {
                if (absence.getEleve() != null && absence.getEleve().getClasse() != null
                        && className.equals(absence.getEleve().getClasse().getNom())) {
                    absences.add(absence);
                }
            }
            if (!absences.isEmpty()) {
                groupedMap.put(className, absences);
            }
        }
        return groupedMap;
    }

    // PROFESSEUR : absences groupées par SES classes
    public Map<String, List<AbsenceModel>> getAbsencesGroupedByClassForProf(Long profId) {
        Map<String, List<AbsenceModel>> groupedMap = new LinkedHashMap<>();
        List<String> classNames = repository.findClassNamesWithAbsencesByProfesseurId(profId);
        List<AbsenceModel> profAbsences = repository.findAbsencesByProfesseurId(profId);

        for (String className : classNames) {
            List<AbsenceModel> absences = new ArrayList<>();
            for (AbsenceModel absence : profAbsences) {
                if (absence.getEleve() != null && absence.getEleve().getClasse() != null
                        && className.equals(absence.getEleve().getClasse().getNom())) {
                    absences.add(absence);
                }
            }
            if (!absences.isEmpty()) {
                groupedMap.put(className, absences);
            }
        }
        return groupedMap;
    }

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

        String message = "Vigilance Scolaire : L'élève " + absence.getEleve().getNom() +
                " totalise désormais " + total + " absences non justifiées. " +
                "Merci de contacter l'établissement rapidement.";

        alerteAuto.setMessage(message);

        alerteService.envoyerEtSauvegarder(alerteAuto);
    }

    public AbsenceModel getAbsenceById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void deleteAbsence(Long id) {
        repository.deleteById(id);
    }
}