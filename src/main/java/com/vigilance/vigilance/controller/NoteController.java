package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.NoteModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.NoteService;
import com.vigilance.vigilance.service.UtilisateurService;
import com.vigilance.vigilance.service.EleveService;  // ← AJOUTÉ
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/note")
public class NoteController {

    private final NoteService service;
    private final UtilisateurService utilisateurService;
    private final EleveService eleveService;  // ← AJOUTÉ

    public NoteController(NoteService service, UtilisateurService utilisateurService, EleveService eleveService) {
        this.service = service;
        this.utilisateurService = utilisateurService;
        this.eleveService = eleveService;  // ← AJOUTÉ
    }

    @GetMapping("")
    public String liste(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        List<NoteModel> notesList;

        if (roles.contains("ROLE_ADMIN")) {
            notesList = service.getAllNotes();
        } else {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (user != null) {
                notesList = service.getNotesByProfesseurId(user.getId_utilisateur());
            } else {
                notesList = java.util.Collections.emptyList();
            }
        }

        // Vérifier si la liste est vide ou nulle
        if (notesList == null || notesList.isEmpty()) {
            model.addAttribute("notes", java.util.Collections.emptyList());
            model.addAttribute("notesByClass", java.util.Collections.emptyMap());
            return "note/list";
        }

        // Regroupement des notes par nom de classe
        Map<String, List<NoteModel>> notesByClass = notesList.stream()
                .filter(n -> n.getEleve() != null && n.getEleve().getClasse() != null)
                .collect(Collectors.groupingBy(n -> n.getEleve().getClasse().getNom()));

        model.addAttribute("notes", notesList);
        model.addAttribute("notesByClass", notesByClass);
        return "note/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model, Authentication authentication) {
        model.addAttribute("note", new NoteModel());

        // Récupérer les élèves pour la liste déroulante
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("eleves", eleveService.getAllEleves());
        } else {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (user != null) {
                model.addAttribute("eleves", eleveService.getElevesByProf(user.getId_utilisateur()));
            } else {
                model.addAttribute("eleves", java.util.Collections.emptyList());
            }
        }

        return "note/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute NoteModel note, RedirectAttributes redirectAttributes) {
        try {
            service.saveNote(note);
            redirectAttributes.addFlashAttribute("success", "Note enregistrée avec succès !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
        }
        return "redirect:/note";
    }

    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model, Authentication authentication) {
        NoteModel note = service.getNoteById(id);
        if (note == null) {
            return "redirect:/note";
        }

        model.addAttribute("note", note);

        // Récupérer les élèves pour la liste déroulante
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("eleves", eleveService.getAllEleves());
        } else {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (user != null) {
                model.addAttribute("eleves", eleveService.getElevesByProf(user.getId_utilisateur()));
            } else {
                model.addAttribute("eleves", java.util.Collections.emptyList());
            }
        }

        return "note/edit";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            service.deleteNote(id);
            redirectAttributes.addFlashAttribute("success", "Note supprimée avec succès !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
        }
        return "redirect:/note";
    }

    /**
     * Endpoint pour déclencher manuellement les alertes pour les notes existantes
     * Utile pour la maintenance ou le débogage
     */
    @GetMapping("/check-alertes")
    public String checkAlertes(RedirectAttributes redirectAttributes) {
        try {
            int count = service.checkAndCreateAlertesForExistingNotes();
            redirectAttributes.addFlashAttribute("success", count + " alertes créées pour les notes insuffisantes existantes.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la vérification : " + e.getMessage());
        }
        return "redirect:/note";
    }
}