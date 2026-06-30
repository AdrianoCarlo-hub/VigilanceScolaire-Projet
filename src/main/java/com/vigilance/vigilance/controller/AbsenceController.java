package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.AbsenceModel;
import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.AbsenceService;
import com.vigilance.vigilance.service.EleveService;
import com.vigilance.vigilance.service.ClasseService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequestMapping("/absence")
public class AbsenceController {

    private final AbsenceService absenceService;
    private final EleveService eleveService;
    private final ClasseService classeService;
    private final UtilisateurService utilisateurService;

    public AbsenceController(AbsenceService absenceService, EleveService eleveService,
                             ClasseService classeService, UtilisateurService utilisateurService) {
        this.absenceService = absenceService;
        this.eleveService = eleveService;
        this.classeService = classeService;
        this.utilisateurService = utilisateurService;
    }

    @GetMapping("")
    public String liste(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        boolean isAdmin = roles.contains("ROLE_ADMIN");
        model.addAttribute("stats", absenceService.getStatistiques(user, isAdmin));
        return "absence/list";
    }

    @GetMapping("/api/user-classes")
    @ResponseBody
    public ResponseEntity<List<ClasseModel>> getUserClasses(Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        if (roles.contains("ROLE_ADMIN")) {
            return ResponseEntity.ok(classeService.getAllClasses());
        } else {
            return ResponseEntity.ok(classeService.getClassesByProfesseurId(user.getId_utilisateur()));
        }
    }

    @GetMapping("/api/classe/{classId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAbsencesByClasse(@PathVariable Long classId, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
        boolean isAdmin = roles.contains("ROLE_ADMIN");

        List<AbsenceModel> absences = absenceService.getAbsencesByClasseId(classId);

        Map<String, Object> response = new HashMap<>();
        response.put("content", absences);
        response.put("stats", absenceService.getStatistiques(user, isAdmin));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/add")
    public String ajouter(Model model, Authentication authentication) {
        model.addAttribute("absence", new AbsenceModel());

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
        return "absence/add";
    }

    /**
     * Sauvegarde une absence unique
     */
    @PostMapping("/save")
    public String save(@ModelAttribute AbsenceModel absence, RedirectAttributes redirectAttributes) {
        try {
            boolean isNew = (absence.getId_absence() == null || absence.getId_absence() <= 0);

            if (absence.getMotif() == null || absence.getMotif().trim().isEmpty()) {
                absence.setMotif("Inconnu");
            }

            absenceService.saveAbsence(absence);

            String eleveNom = absence.getEleve() != null ?
                    absence.getEleve().getNom() + " " + absence.getEleve().getPrenom() : "Eleve";

            if (isNew) {
                redirectAttributes.addFlashAttribute("success", "Absence ajoutee avec succes pour " + eleveNom + " !");
            } else {
                redirectAttributes.addFlashAttribute("success", "Absence modifiee avec succes pour " + eleveNom + " !");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
        }
        return "redirect:/absence";
    }

    /**
     * Sauvegarde de multiples absences (ajout en masse)
     */
    @PostMapping("/save-multiple")
    public String saveMultiple(@RequestParam("elevesIds") String elevesIdsStr,
                               @RequestParam("date_absence") String dateAbsence,
                               @RequestParam(value = "motif", required = false) String motif,
                               @RequestParam(value = "justifie", required = false) boolean justifie,
                               RedirectAttributes redirectAttributes) {
        try {
            // Convertir la chaîne d'IDs en liste
            List<Long> elevesIds = new ArrayList<>();
            if (elevesIdsStr != null && !elevesIdsStr.isEmpty()) {
                String[] ids = elevesIdsStr.split(",");
                for (String id : ids) {
                    try {
                        elevesIds.add(Long.parseLong(id.trim()));
                    } catch (NumberFormatException e) {
                        System.err.println("ID invalide: " + id);
                    }
                }
            }

            if (elevesIds.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Aucun eleve selectionne !");
                return "redirect:/absence/add";
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateAbsence, formatter);
            String motifFinal = (motif == null || motif.trim().isEmpty()) ? "Inconnu" : motif;

            int count = 0;
            for (Long eleveId : elevesIds) {
                EleveModel eleve = eleveService.getEleveById(eleveId);
                if (eleve != null) {
                    AbsenceModel absence = new AbsenceModel();
                    absence.setEleve(eleve);
                    absence.setDate_absence(date);  // ✅ CORRECTION : LocalDate directement
                    absence.setMotif(motifFinal);
                    absence.setJustifie(justifie);
                    absenceService.saveAbsence(absence);
                    count++;
                }
            }

            redirectAttributes.addFlashAttribute("success", count + " absence(s) enregistree(s) avec succes !");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
        }
        return "redirect:/absence";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        AbsenceModel absence = absenceService.getAbsenceById(id);
        if (absence == null) {
            redirectAttributes.addFlashAttribute("error", "Absence non trouvee !");
            return "redirect:/absence";
        }
        model.addAttribute("absence", absence);
        return "absence/edit";
    }

    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        return edit(id, model, redirectAttributes);
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            AbsenceModel absence = absenceService.getAbsenceById(id);
            if (absence == null) {
                redirectAttributes.addFlashAttribute("error", "Absence non trouvee !");
                return "redirect:/absence";
            }

            String eleveNom = absence.getEleve() != null ?
                    absence.getEleve().getNom() + " " + absence.getEleve().getPrenom() : "Eleve";

            absenceService.deleteAbsence(id);
            redirectAttributes.addFlashAttribute("success", "Absence supprimee avec succes pour " + eleveNom + " !");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
        }
        return "redirect:/absence";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        return delete(id, redirectAttributes);
    }

    @GetMapping("/api/{id}")
    @ResponseBody
    public AbsenceModel getAbsenceApi(@PathVariable Long id) {
        return absenceService.getAbsenceById(id);
    }
}