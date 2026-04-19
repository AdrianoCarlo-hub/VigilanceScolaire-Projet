package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.ClasseService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.Set;

@Controller
@RequestMapping("/classe")
public class ClasseController {

    private final ClasseService service;
    private final UtilisateurService utilisateurService;

    public ClasseController(ClasseService service, UtilisateurService utilisateurService) {
        this.service = service;
        this.utilisateurService = utilisateurService;
    }

    @GetMapping("")
    public String liste(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("classes", service.getAllClasses());
        } else {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (user != null) {
                model.addAttribute("classes", service.getClassesByProfesseurId(user.getId_utilisateur()));
            } else {
                model.addAttribute("classes", java.util.Collections.emptyList());
            }
        }
        return "classe/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model) {
        model.addAttribute("classe", new ClasseModel());
        return "classe/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute ClasseModel classe) {
        service.saveClasse(classe);
        return "redirect:/classe";
    }

    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model) {
        model.addAttribute("classe", service.getClasseById(id));
        return "classe/edit";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id) {
        service.deleteClasse(id);
        return "redirect:/classe";
    }
}