package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.NoteModel;
import com.vigilance.vigilance.model.AlerteModel;
import com.vigilance.vigilance.repository.NoteRepository;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

@Service
public class NoteService {

    private final NoteRepository repository;
    private final AlerteService alerteService;

    public NoteService(NoteRepository repository, AlerteService alerteService) {
        this.repository = repository;
        this.alerteService = alerteService;
    }

    // ========== MÉTHODES EXISTANTES (gardez-les) ==========

    public List<NoteModel> getAllNotes() {
        return repository.findAllNotesOrderByDateDesc();
    }

    public List<NoteModel> getNotesByProfesseurId(Long profId) {
        return repository.findNotesByProfesseurId(profId);
    }

    public void saveNote(NoteModel note) {
        repository.save(note);
        Double moyenneMatiere = repository.calculerMoyenneParMatiere(note.getMatiere());
        if (moyenneMatiere != null && note.getValeur() < moyenneMatiere) {
            declencherVigilanceNote(note, moyenneMatiere);
        }
    }

    private void declencherVigilanceNote(NoteModel note, Double moyenne) {
        AlerteModel alerteAuto = new AlerteModel();
        alerteAuto.setEleve(note.getEleve());
        alerteAuto.setType("PERFORMANCE_BASSE");
        alerteAuto.setCanal("EMAIL");
        String message = "Alerte Vigilance : " + note.getEleve().getNom() +
                " a obtenu la note de " + note.getValeur() +
                " en " + note.getMatiere() + ". Cette note est inférieure à la moyenne de la classe (" +
                String.format("%.2f", moyenne) + ").";
        alerteAuto.setMessage(message);
        alerteService.envoyerEtSauvegarder(alerteAuto);
    }

    public NoteModel getNoteById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void deleteNote(Long id) {
        repository.deleteById(id);
    }

    // ========== NOUVELLES MÉTHODES POUR LE BULLETIN ==========

    /**
     * Récupère toutes les notes d'un élève
     */
    public List<NoteModel> getNotesByEleveId(Long eleveId) {
        return repository.findNotesByEleveId(eleveId);
    }

    /**
     * Récupère les notes d'un élève entre deux dates
     */
    public List<NoteModel> getNotesByEleveIdAndDateRange(Long eleveId, Date dateDebut, Date dateFin) {
        return repository.findNotesByEleveIdAndDateRange(eleveId, dateDebut, dateFin);
    }

    /**
     * Récupère toutes les notes d'une classe entre deux dates
     */
    public List<NoteModel> getNotesByClasseIdAndDateRange(Long classeId, Date dateDebut, Date dateFin) {
        return repository.findNotesByClasseIdAndDateRange(classeId, dateDebut, dateFin);
    }

    /**
     * Calcule la moyenne par matière à partir des notes
     */
    public Map<String, Double> calculerMoyennesParMatiere(List<NoteModel> notes) {
        Map<String, Double> sommePonderee = new HashMap<>();
        Map<String, Integer> sommeCoeffs = new HashMap<>();

        for (NoteModel note : notes) {
            String matiere = note.getMatiere();
            sommePonderee.put(matiere, sommePonderee.getOrDefault(matiere, 0.0) + note.getValeur() * note.getCoefficient());
            sommeCoeffs.put(matiere, sommeCoeffs.getOrDefault(matiere, 0) + note.getCoefficient());
        }

        Map<String, Double> moyennes = new HashMap<>();
        for (String matiere : sommePonderee.keySet()) {
            int coeffs = sommeCoeffs.get(matiere);
            moyennes.put(matiere, coeffs > 0 ? sommePonderee.get(matiere) / coeffs : 0);
        }

        return moyennes;
    }

    /**
     * Calcule la moyenne générale à partir des notes (moyenne pondérée)
     */
    public double calculerMoyenneGenerale(List<NoteModel> notes) {
        if (notes == null || notes.isEmpty()) return 0;

        double sommePonderee = 0;
        int sommeCoeffs = 0;

        for (NoteModel note : notes) {
            sommePonderee += note.getValeur() * note.getCoefficient();
            sommeCoeffs += note.getCoefficient();
        }

        return sommeCoeffs > 0 ? sommePonderee / sommeCoeffs : 0;
    }

    /**
     * Calcule le total par matière (note × coeff)
     */
    public Map<String, Double> calculerTotauxParMatiere(List<NoteModel> notes) {
        Map<String, Double> totaux = new HashMap<>();

        for (NoteModel note : notes) {
            String matiere = note.getMatiere();
            double total = note.getValeur() * note.getCoefficient();
            totaux.put(matiere, totaux.getOrDefault(matiere, 0.0) + total);
        }

        return totaux;
    }
}