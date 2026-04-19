package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.dto.BulletinDTO;
import com.vigilance.vigilance.dto.ClassementEleveDTO;
import com.vigilance.vigilance.dto.MatiereNoteDTO;
import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.NoteModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.ClasseService;
import com.vigilance.vigilance.service.EleveService;
import com.vigilance.vigilance.service.NoteService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/bulletin")
public class BulletinController {

    private final NoteService noteService;
    private final EleveService eleveService;
    private final ClasseService classeService;
    private final UtilisateurService utilisateurService;

    // Périodes des trimestres pour l'année scolaire 2025-2026
    private static final Map<Integer, String[]> PERIODES = new HashMap<>();

    static {
        // 1er Trimestre: Septembre - Novembre 2025
        PERIODES.put(1, new String[]{"2025-09-01", "2025-11-30", "1er Trimestre (Septembre - Novembre 2025)"});
        // 2ème Trimestre: Décembre 2025 - Février 2026
        PERIODES.put(2, new String[]{"2025-12-01", "2026-02-28", "2ème Trimestre (Décembre - Février)"});
        // 3ème Trimestre: Mars - Mai 2026
        PERIODES.put(3, new String[]{"2026-03-01", "2026-05-31", "3ème Trimestre (Mars - Mai 2026)"});
        // Annuel
        PERIODES.put(0, new String[]{"2025-09-01", "2026-05-31", "Année Scolaire 2025-2026"});
    }

    public BulletinController(NoteService noteService, EleveService eleveService,
                              ClasseService classeService, UtilisateurService utilisateurService) {
        this.noteService = noteService;
        this.eleveService = eleveService;
        this.classeService = classeService;
        this.utilisateurService = utilisateurService;
    }

    @GetMapping("")
    public String index(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("classes", classeService.getAllClasses());
        } else {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (user != null) {
                model.addAttribute("classes", classeService.getClassesByProfesseurId(user.getId_utilisateur()));
            } else {
                model.addAttribute("classes", new ArrayList<>());
            }
        }

        model.addAttribute("trimestres", Arrays.asList(1, 2, 3, 0));
        model.addAttribute("libelles", Map.of(
                1, "1er Trimestre",
                2, "2ème Trimestre",
                3, "3ème Trimestre",
                0, "Année complète"
        ));

        return "bulletin/index";
    }

    @GetMapping("/classe/{classeId}")
    public String listeElevesParClasse(@PathVariable Long classeId,
                                       @RequestParam(defaultValue = "1") int trimestre,
                                       Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (!roles.contains("ROLE_ADMIN")) {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            ClasseModel classe = classeService.getClasseById(classeId);
            if (classe == null || classe.getUtilisateur() == null ||
                    !classe.getUtilisateur().getId_utilisateur().equals(user.getId_utilisateur())) {
                return "redirect:/bulletin";
            }
        }

        String[] periodeInfo = PERIODES.get(trimestre);
        Date dateDebut = parseDate(periodeInfo[0]);
        Date dateFin = parseDate(periodeInfo[1]);

        List<EleveModel> eleves = eleveService.getElevesByClasseId(classeId);
        List<ClassementEleveDTO> classement = getClassementClasse(classeId, dateDebut, dateFin);

        model.addAttribute("classe", classeService.getClasseById(classeId));
        model.addAttribute("eleves", eleves);
        model.addAttribute("classement", classement);
        model.addAttribute("trimestre", trimestre);
        model.addAttribute("periodeLibelle", periodeInfo[2]);

        return "bulletin/eleves";
    }

    @GetMapping("/eleve/{eleveId}")
    public String afficherBulletin(@PathVariable Long eleveId,
                                   @RequestParam(defaultValue = "1") int trimestre,
                                   Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        EleveModel eleve = eleveService.getEleveById(eleveId);

        if (eleve == null) {
            return "redirect:/bulletin";
        }

        if (!roles.contains("ROLE_ADMIN")) {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (eleve.getClasse() == null || eleve.getClasse().getUtilisateur() == null ||
                    !eleve.getClasse().getUtilisateur().getId_utilisateur().equals(user.getId_utilisateur())) {
                return "redirect:/bulletin";
            }
        }

        BulletinDTO bulletin = genererBulletin(eleveId, trimestre);
        model.addAttribute("bulletin", bulletin);
        model.addAttribute("trimestre", trimestre);

        return "bulletin/bulletin";
    }

    private BulletinDTO genererBulletin(Long eleveId, int trimestre) {
        EleveModel eleve = eleveService.getEleveById(eleveId);
        if (eleve == null) return null;

        String[] periodeInfo = PERIODES.get(trimestre);
        Date dateDebut = parseDate(periodeInfo[0]);
        Date dateFin = parseDate(periodeInfo[1]);

        List<NoteModel> notes = noteService.getNotesByEleveIdAndDateRange(eleveId, dateDebut, dateFin);

        BulletinDTO bulletin = new BulletinDTO();
        bulletin.setEleve(eleve);
        bulletin.setClasse(eleve.getClasse());
        bulletin.setPeriode(periodeInfo[2]);
        bulletin.setDateDebut(dateDebut);
        bulletin.setDateFin(dateFin);
        bulletin.setDateEdition(new Date());

        // Calcul des moyennes par matière
        Map<String, Double> moyennes = noteService.calculerMoyennesParMatiere(notes);
        Map<String, Double> totaux = noteService.calculerTotauxParMatiere(notes);
        Map<String, Integer> coeffs = new HashMap<>();

        for (NoteModel note : notes) {
            coeffs.put(note.getMatiere(), coeffs.getOrDefault(note.getMatiere(), 0) + note.getCoefficient());
        }

        List<MatiereNoteDTO> matieres = new ArrayList<>();
        for (String matiere : moyennes.keySet()) {
            matieres.add(new MatiereNoteDTO(matiere,
                    Math.round(moyennes.get(matiere) * 100.0) / 100.0,
                    coeffs.get(matiere),
                    Math.round(totaux.get(matiere) * 100.0) / 100.0));
        }
        matieres.sort(Comparator.comparing(MatiereNoteDTO::getMatiere));
        bulletin.setMatieres(matieres);

        // Moyenne générale
        double moyenneGenerale = noteService.calculerMoyenneGenerale(notes);
        bulletin.setMoyenneGenerale(Math.round(moyenneGenerale * 100.0) / 100.0);

        // Rang dans la classe
        List<ClassementEleveDTO> classement = getClassementClasse(eleve.getClasse().getId_classe(), dateDebut, dateFin);
        for (ClassementEleveDTO c : classement) {
            if (c.getIdEleve().equals(eleveId)) {
                bulletin.setRang(c.getRang());
                break;
            }
        }
        bulletin.setTotalEleves(classement.size());

        // Professeur principal
        if (eleve.getClasse() != null && eleve.getClasse().getUtilisateur() != null) {
            bulletin.setNomProfesseurPrincipal(eleve.getClasse().getUtilisateur().getUsername());
        }

        // Appréciation automatique
        bulletin.setAppreciation(genererAppreciation(moyenneGenerale));

        return bulletin;
    }

    private List<ClassementEleveDTO> getClassementClasse(Long classeId, Date dateDebut, Date dateFin) {
        List<EleveModel> eleves = eleveService.getElevesByClasseId(classeId);
        List<ClassementEleveDTO> classement = new ArrayList<>();

        for (EleveModel eleve : eleves) {
            List<NoteModel> notes = noteService.getNotesByEleveIdAndDateRange(eleve.getId_eleve(), dateDebut, dateFin);
            double moyenne = noteService.calculerMoyenneGenerale(notes);
            classement.add(new ClassementEleveDTO(eleve.getId_eleve(), eleve.getNom(), eleve.getPrenom(),
                    eleve.getMatricule(), moyenne, 0));
        }

        classement.sort((a, b) -> Double.compare(b.getMoyenneGenerale(), a.getMoyenneGenerale()));
        for (int i = 0; i < classement.size(); i++) {
            classement.get(i).setRang(i + 1);
        }

        return classement;
    }

    private String genererAppreciation(double moyenne) {
        if (moyenne >= 16) return "Excellent travail ! Félicitations pour vos résultats exceptionnels. Continuez ainsi !";
        if (moyenne >= 14) return "Très bon travail. Vous maîtrisez bien les matières. Quelques progrès possibles pour atteindre l'excellence.";
        if (moyenne >= 12) return "Bon travail. Des résultats satisfaisants. Continuez vos efforts pour vous améliorer encore.";
        if (moyenne >= 10) return "Travail correct. Vous avez les bases, mais vous pouvez faire mieux. Plus de régularité dans le travail serait bénéfique.";
        if (moyenne >= 8) return "Des difficultés sont constatées. Une révision régulière et plus de travail personnel sont nécessaires.";
        return "Résultats insuffisants. Un travail plus soutenu et une aide supplémentaire sont recommandés.";
    }

    private Date parseDate(String dateStr) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
        } catch (Exception e) {
            return new Date();
        }
    }
}