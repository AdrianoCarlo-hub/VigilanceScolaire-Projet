package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.AbsenceModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.AbsenceService;
import com.vigilance.vigilance.service.EleveService;
import com.vigilance.vigilance.service.ClasseService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Set;

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

    /**
     * Affiche la liste des absences (Groupées par classe)
     */
    @GetMapping("")
    public String liste(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("absencesByClass", absenceService.getAbsencesGroupedByClass());
        } else if (user != null) {
            // Un professeur ne voit que les absences des élèves de SES classes
            model.addAttribute("absencesByClass", absenceService.getAbsencesGroupedByClassForProf(user.getId_utilisateur()));
        }
        return "absence/list";
    }

    /**
     * Formulaire d'ajout d'une absence
     */
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
     * Enregistrement de l'absence
     */
    @PostMapping("/save")
    public String save(@ModelAttribute AbsenceModel absence) {
        // Logique de secours pour le motif
        if (absence.getMotif() == null || absence.getMotif().trim().isEmpty()) {
            absence.setMotif("Inconnu");
        }



        absenceService.saveAbsence(absence);
        return "redirect:/absence";
    }

    /**
     * Formulaire de modification
     */
    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model) {
        AbsenceModel absence = absenceService.getAbsenceById(id);
        if (absence == null) return "redirect:/absence";

        model.addAttribute("absence", absence);
        // On renvoie vers une vue d'édition spécifique ou le même formulaire
        return "absence/edit";
    }

    /**
     * Suppression
     */
    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id) {
        absenceService.deleteAbsence(id);
        return "redirect:/absence";
    }

    /**
     * API pour récupérer les détails d'une absence en JSON (utile pour des modales)
     */
    @GetMapping("/api/{id}")
    @ResponseBody
    public AbsenceModel getAbsenceApi(@PathVariable Long id) {
        return absenceService.getAbsenceById(id);
    }
}