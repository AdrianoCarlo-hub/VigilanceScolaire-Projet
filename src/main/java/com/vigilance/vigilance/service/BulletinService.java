package com.vigilance.vigilance.service;

import com.vigilance.vigilance.dto.BulletinDTO;
import com.vigilance.vigilance.dto.ClassementEleveDTO;
import com.vigilance.vigilance.dto.MatiereNoteDTO;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.NoteModel;
import com.vigilance.vigilance.repository.EleveRepository;
import com.vigilance.vigilance.repository.NoteRepository;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class BulletinService {

    private final EleveRepository eleveRepository;
    private final NoteRepository noteRepository;

    // Périodes des trimestres avec dates complètes
    private static final Map<Integer, String[]> PERIODES = new HashMap<>();

    static {
        // Pour l'année scolaire 2025-2026
        PERIODES.put(1, new String[]{"2025-09-01", "2025-11-30", "1er Trimestre (Septembre - Novembre 2025)"});
        PERIODES.put(2, new String[]{"2025-12-01", "2026-02-28", "2ème Trimestre (Décembre 2025 - Février 2026)"});
        PERIODES.put(3, new String[]{"2026-03-01", "2026-05-31", "3ème Trimestre (Mars - Mai 2026)"});
        PERIODES.put(0, new String[]{"2025-09-01", "2026-05-31", "Année Scolaire 2025-2026"});
    }

    public BulletinService(EleveRepository eleveRepository, NoteRepository noteRepository) {
        this.eleveRepository = eleveRepository;
        this.noteRepository = noteRepository;
    }

    /**
     * Génère le bulletin pour un élève sur une période donnée
     */
    public BulletinDTO genererBulletin(Long eleveId, int trimestre) {
        EleveModel eleve = eleveRepository.findById(eleveId).orElse(null);
        if (eleve == null) return null;

        String[] periodeInfo = PERIODES.get(trimestre);
        if (periodeInfo == null) {
            periodeInfo = PERIODES.get(1);
        }

        Date dateDebut = parseDate(periodeInfo[0]);
        Date dateFin = parseDate(periodeInfo[1]);

        BulletinDTO bulletin = new BulletinDTO();
        bulletin.setEleve(eleve);
        bulletin.setClasse(eleve.getClasse());
        bulletin.setPeriode(periodeInfo[2]);
        bulletin.setDateEdition(new Date());

        // Récupérer les notes de l'élève entre les dates
        List<NoteModel> notes = noteRepository.findNotesByEleveIdAndDateRange(eleveId, dateDebut, dateFin);

        System.out.println("=== BULLETIN DEBUG ===");
        System.out.println("Élève: " + eleve.getNom() + " " + eleve.getPrenom());
        System.out.println("Période: " + periodeInfo[2]);
        System.out.println("Date début: " + dateDebut);
        System.out.println("Date fin: " + dateFin);
        System.out.println("Nombre de notes trouvées: " + notes.size());

        for (NoteModel n : notes) {
            System.out.println("  - " + n.getMatiere() + ": " + n.getValeur() + " (coeff " + n.getCoefficient() + ")");
        }

        // Calculer les moyennes par matière
        List<MatiereNoteDTO> matieres = calculerMoyennesParMatiere(notes);
        bulletin.setMatieres(matieres);

        // Calculer la moyenne générale
        double moyenneGenerale = calculerMoyenneGenerale(notes);
        bulletin.setMoyenneGenerale(Math.round(moyenneGenerale * 100.0) / 100.0);

        // Calculer le rang dans la classe
        int rang = calculerRangDansClasse(eleve, dateDebut, dateFin);
        bulletin.setRang(rang);

        // Nombre total d'élèves dans la classe
        int totalEleves = eleveRepository.findElevesByClasseId(eleve.getClasse().getId_classe()).size();
        bulletin.setTotalEleves(totalEleves);

        // Nom du professeur principal
        if (eleve.getClasse() != null && eleve.getClasse().getUtilisateur() != null) {
            bulletin.setNomProfesseurPrincipal(eleve.getClasse().getUtilisateur().getUsername());
        }

        // Appréciation automatique basée sur la moyenne
        bulletin.setAppreciation(genererAppreciation(moyenneGenerale));

        return bulletin;
    }

    /**
     * Parse une date au format yyyy-MM-dd
     */
    private Date parseDate(String dateStr) {
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            return sdf.parse(dateStr);
        } catch (java.text.ParseException e) {
            return new Date();
        }
    }

    /**
     * Calcule les moyennes par matière à partir des notes
     */
    private List<MatiereNoteDTO> calculerMoyennesParMatiere(List<NoteModel> notes) {
        Map<String, List<NoteModel>> notesParMatiere = new HashMap<>();

        for (NoteModel note : notes) {
            notesParMatiere.computeIfAbsent(note.getMatiere(), k -> new ArrayList<>()).add(note);
        }

        List<MatiereNoteDTO> resultats = new ArrayList<>();
        for (Map.Entry<String, List<NoteModel>> entry : notesParMatiere.entrySet()) {
            String matiere = entry.getKey();
            List<NoteModel> notesMatiere = entry.getValue();

            double sommePonderee = 0;
            int sommeCoeffs = 0;

            for (NoteModel note : notesMatiere) {
                sommePonderee += note.getValeur() * note.getCoefficient();
                sommeCoeffs += note.getCoefficient();
            }

            double moyenne = (sommeCoeffs > 0) ? sommePonderee / sommeCoeffs : 0;
            double total = sommePonderee;

            MatiereNoteDTO dto = new MatiereNoteDTO(matiere,
                    Math.round(moyenne * 100.0) / 100.0,
                    sommeCoeffs,
                    Math.round(total * 100.0) / 100.0);
            resultats.add(dto);
        }

        resultats.sort(Comparator.comparing(MatiereNoteDTO::getMatiere));
        return resultats;
    }

    /**
     * Calcule la moyenne générale à partir des notes
     */
    private double calculerMoyenneGenerale(List<NoteModel> notes) {
        if (notes == null || notes.isEmpty()) return 0;

        double sommePonderee = 0;
        int sommeCoeffs = 0;

        for (NoteModel note : notes) {
            sommePonderee += note.getValeur() * note.getCoefficient();
            sommeCoeffs += note.getCoefficient();
        }

        return (sommeCoeffs > 0) ? sommePonderee / sommeCoeffs : 0;
    }

    /**
     * Calcule le rang de l'élève dans sa classe
     */
    private int calculerRangDansClasse(EleveModel eleve, Date dateDebut, Date dateFin) {
        List<EleveModel> elevesClasse = eleveRepository.findElevesByClasseId(eleve.getClasse().getId_classe());

        List<ClassementEleveDTO> classement = new ArrayList<>();
        for (EleveModel e : elevesClasse) {
            List<NoteModel> notes = noteRepository.findNotesByEleveIdAndDateRange(e.getId_eleve(), dateDebut, dateFin);
            double moyenne = calculerMoyenneGenerale(notes);
            classement.add(new ClassementEleveDTO(e.getId_eleve(), e.getNom(), e.getPrenom(), moyenne, 0));
        }

        classement.sort((a, b) -> Double.compare(b.getMoyenneGenerale(), a.getMoyenneGenerale()));

        for (int i = 0; i < classement.size(); i++) {
            classement.get(i).setRang(i + 1);
            if (classement.get(i).getIdEleve().equals(eleve.getId_eleve())) {
                return i + 1;
            }
        }

        return classement.size();
    }

    /**
     * Génère une appréciation automatique basée sur la moyenne
     */
    private String genererAppreciation(double moyenne) {
        if (moyenne >= 16) {
            return "Excellent travail ! Félicitations pour vos résultats exceptionnels. Continuez ainsi !";
        } else if (moyenne >= 14) {
            return "Très bon travail. Vous maîtrisez bien les matières. Quelques progrès possibles pour atteindre l'excellence.";
        } else if (moyenne >= 12) {
            return "Bon travail. Des résultats satisfaisants. Continuez vos efforts pour vous améliorer encore.";
        } else if (moyenne >= 10) {
            return "Travail correct. Vous avez les bases, mais vous pouvez faire mieux. Plus de régularité dans le travail serait bénéfique.";
        } else if (moyenne >= 8) {
            return "Des difficultés sont constatées. Une révision régulière et plus de travail personnel sont nécessaires.";
        } else {
            return "Résultats insuffisants. Un travail plus soutenu et une aide supplémentaire sont recommandés.";
        }
    }

    /**
     * Récupère le classement complet de la classe
     */
    public List<ClassementEleveDTO> getClassementClasse(Long classeId, int trimestre) {
        String[] periodeInfo = PERIODES.get(trimestre);
        if (periodeInfo == null) {
            periodeInfo = PERIODES.get(1);
        }

        Date dateDebut = parseDate(periodeInfo[0]);
        Date dateFin = parseDate(periodeInfo[1]);

        List<EleveModel> eleves = eleveRepository.findElevesByClasseId(classeId);

        List<ClassementEleveDTO> classement = new ArrayList<>();
        for (EleveModel eleve : eleves) {
            List<NoteModel> notes = noteRepository.findNotesByEleveIdAndDateRange(eleve.getId_eleve(), dateDebut, dateFin);
            double moyenne = calculerMoyenneGenerale(notes);
            classement.add(new ClassementEleveDTO(eleve.getId_eleve(), eleve.getNom(), eleve.getPrenom(), moyenne, 0));
        }

        classement.sort((a, b) -> Double.compare(b.getMoyenneGenerale(), a.getMoyenneGenerale()));

        for (int i = 0; i < classement.size(); i++) {
            classement.get(i).setRang(i + 1);
        }

        return classement;
    }
}