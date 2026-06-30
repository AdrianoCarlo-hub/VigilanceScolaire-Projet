package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.NoteModel;
import com.vigilance.vigilance.model.AlerteModel;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.repository.NoteRepository;
import com.vigilance.vigilance.repository.AlerteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class NoteService {

    private final NoteRepository repository;
    private final AlerteService alerteService;
    private final AlerteRepository alerteRepository;
    private final EleveService eleveService;

    // Seuil pour déclencher une alerte (note < 10/20)
    private static final double SEUIL_ALERTE = 10.0;

    public NoteService(NoteRepository repository, AlerteService alerteService,
                       AlerteRepository alerteRepository, EleveService eleveService) {
        this.repository = repository;
        this.alerteService = alerteService;
        this.alerteRepository = alerteRepository;
        this.eleveService = eleveService;
    }

    // ========== MÉTHODES EXISTANTES ==========

    public List<NoteModel> getAllNotes() {
        return repository.findAllNotesOrderByDateDesc();
    }

    public List<NoteModel> getNotesByProfesseurId(Long profId) {
        return repository.findNotesByProfesseurId(profId);
    }

    @Transactional
    public void saveNote(NoteModel note) {
        // 1. Sauvegarder la note
        NoteModel savedNote = repository.save(note);
        System.out.println("Note sauvegardee avec ID: " + savedNote.getId_note());

        // 2. Vérifier si la note est inférieure au seuil (10/20)
        if (savedNote.getValeur() < SEUIL_ALERTE) {
            System.out.println("Note inferieure a " + SEUIL_ALERTE + "/20 : " + savedNote.getValeur());
            creerAlerteNoteInsuffisante(savedNote);
        }
    }

    /**
     * Crée une alerte pour note insuffisante (seuil 10/20)
     * L'alerte est créée avec statut "EN_ATTENTE" - SANS ENVOI AUTOMATIQUE
     */
    @Transactional
    public void creerAlerteNoteInsuffisante(NoteModel note) {
        try {
            // Vérifier que l'élève existe dans la note
            if (note.getEleve() == null) {
                System.err.println("Erreur: L'eleve est null pour la note ID: " + note.getId_note());
                return;
            }

            // Récupérer l'élève complet depuis la base de données
            EleveModel eleve = eleveService.getEleveById(note.getEleve().getId_eleve());
            if (eleve == null) {
                System.err.println("Erreur: Eleve introuvable avec ID: " + note.getEleve().getId_eleve());
                return;
            }

            System.out.println("Eleve trouve: " + eleve.getNom() + " " + eleve.getPrenom());

            // Vérifier que l'élève a un parent
            if (eleve.getParent() == null) {
                System.err.println("Aucun parent associe a l'eleve: " + eleve.getNom() + " " + eleve.getPrenom());
                System.err.println("   Alerte non creee pour cet eleve.");
                return;
            }

            System.out.println("Parent trouve: " + eleve.getParent().getNom() + " " + eleve.getParent().getPrenom());

            // Vérifier si une alerte existe déjà pour cette note (éviter les doublons)
            boolean alerteExists = alerteRepository.existsByIdReferenceAndTypeReference(
                    note.getId_note(), "NOTE"
            );

            if (alerteExists) {
                System.out.println("Une alerte existe deja pour cette note (ID: " + note.getId_note() + ")");
                return;
            }

            // Créer l'alerte avec les bonnes données
            AlerteModel alerte = new AlerteModel();
            alerte.setEleve(eleve);
            alerte.setType("NOTE_INSUFFISANTE");
            alerte.setStatut("EN_ATTENTE");  // ← IMPORTANT : Pas envoyé automatiquement
            alerte.setDateAlerte(LocalDateTime.now());
            alerte.setCanal("SMS,EMAIL");

            String message = "Alerte Vigilance : " + eleve.getNom() + " " + eleve.getPrenom() +
                    " a obtenu " + note.getValeur() + "/20 en " + note.getMatiere() +
                    ". Cette note est inferieure a la moyenne attendue (10/20).";
            alerte.setMessage(message);

            alerte.setIdReference(note.getId_note());
            alerte.setTypeReference("NOTE");

            // Sauvegarder l'alerte en base (SANS ENVOI)
            alerteService.creerAlerte(alerte);

            System.out.println(" Alerte NOTE_INSUFFISANTE creee (en attente d'envoi) pour l'eleve " +
                    eleve.getNom() + " " + eleve.getPrenom());

        } catch (Exception e) {
            System.err.println("Erreur lors de la creation de l'alerte: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * (Optionnel) Alerte pour note inférieure à la moyenne de la classe
     */
    private void creerAlerteVigilanceNote(NoteModel note, Double moyenne) {
        try {
            // Récupérer l'élève complet
            EleveModel eleve = eleveService.getEleveById(note.getEleve().getId_eleve());
            if (eleve == null || eleve.getParent() == null) {
                return;
            }

            // Vérifier si une alerte existe déjà
            boolean alerteExists = alerteRepository.existsByIdReferenceAndTypeReference(
                    note.getId_note(), "NOTE"
            );

            if (alerteExists) {
                return;
            }

            AlerteModel alerteAuto = new AlerteModel();
            alerteAuto.setEleve(eleve);
            alerteAuto.setType("PERFORMANCE_BASSE");
            alerteAuto.setStatut("EN_ATTENTE");
            alerteAuto.setDateAlerte(LocalDateTime.now());
            alerteAuto.setCanal("EMAIL");

            String message = "Alerte Vigilance : " + eleve.getNom() + " " + eleve.getPrenom() +
                    " a obtenu la note de " + note.getValeur() + "/20 en " + note.getMatiere() +
                    ". Cette note est inferieure a la moyenne de la classe (" + String.format("%.2f", moyenne) + ").";
            alerteAuto.setMessage(message);
            alerteAuto.setIdReference(note.getId_note());
            alerteAuto.setTypeReference("NOTE");

            alerteService.creerAlerte(alerteAuto);
            System.out.println(" Alerte PERFORMANCE_BASSE creee (en attente d'envoi)");

        } catch (Exception e) {
            System.err.println("Erreur lors de la creation de l'alerte performance: " + e.getMessage());
        }
    }

    public NoteModel getNoteById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void deleteNote(Long id) {
        repository.deleteById(id);
    }

    // ========== MÉTHODES POUR LE BULLETIN ==========

    public List<NoteModel> getNotesByEleveId(Long eleveId) {
        return repository.findNotesByEleveId(eleveId);
    }

    public List<NoteModel> getNotesByEleveIdAndDateRange(Long eleveId, java.util.Date dateDebut, java.util.Date dateFin) {
        return repository.findNotesByEleveIdAndDateRange(eleveId, dateDebut, dateFin);
    }

    public List<NoteModel> getNotesByClasseIdAndDateRange(Long classeId, java.util.Date dateDebut, java.util.Date dateFin) {
        return repository.findNotesByClasseIdAndDateRange(classeId, dateDebut, dateFin);
    }

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

    public Map<String, Double> calculerTotauxParMatiere(List<NoteModel> notes) {
        Map<String, Double> totaux = new HashMap<>();

        for (NoteModel note : notes) {
            String matiere = note.getMatiere();
            double total = note.getValeur() * note.getCoefficient();
            totaux.put(matiere, totaux.getOrDefault(matiere, 0.0) + total);
        }

        return totaux;
    }

    /**
     * Méthode utilitaire pour déclencher manuellement les alertes pour les notes existantes
     */
    @Transactional
    public int checkAndCreateAlertesForExistingNotes() {
        List<NoteModel> notesFaibles = repository.findByValeurLessThan(SEUIL_ALERTE);
        System.out.println(" " + notesFaibles.size() + " notes inferieures a " + SEUIL_ALERTE + "/20 trouvees");

        int createdCount = 0;
        for (NoteModel note : notesFaibles) {
            // Vérifier si une alerte existe déjà pour cette note
            boolean alerteExists = alerteRepository.existsByIdReferenceAndTypeReference(
                    note.getId_note(), "NOTE"
            );

            if (!alerteExists) {
                creerAlerteNoteInsuffisante(note);
                createdCount++;
            } else {
                System.out.println(" Alerte deja existante pour la note ID: " + note.getId_note());
            }
        }

        System.out.println(" " + createdCount + " nouvelles alertes creees");
        return createdCount;
    }
}