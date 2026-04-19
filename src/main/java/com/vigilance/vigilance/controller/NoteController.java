package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.NoteModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.NoteService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.Set;

@Controller
@RequestMapping("/note")
public class NoteController {

    private final NoteService service;
    private final UtilisateurService utilisateurService;

    public NoteController(NoteService service, UtilisateurService utilisateurService) {
        this.service = service;
        this.utilisateurService = utilisateurService;
    }

    @GetMapping("")
    public String liste(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("notes", service.getAllNotes());
        } else {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (user != null) {
                model.addAttribute("notes", service.getNotesByProfesseurId(user.getId_utilisateur()));
            } else {
                model.addAttribute("notes", java.util.Collections.emptyList());
            }
        }
        return "note/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model) {
        model.addAttribute("note", new NoteModel());
        return "note/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute NoteModel note) {
        service.saveNote(note);
        return "redirect:/note";
    }

    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model) {
        model.addAttribute("note", service.getNoteById(id));
        return "note/edit";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id) {
        service.deleteNote(id);
        return "redirect:/note";
    }
}