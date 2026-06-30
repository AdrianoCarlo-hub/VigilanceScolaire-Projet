package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Set;

@Controller
public class UtilisateurController {

    private final UtilisateurService service;

    public UtilisateurController(UtilisateurService service) {
        this.service = service;
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/home")
    public String defaultAfterLogin(Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (roles.contains("ROLE_ADMIN")) {
            return "redirect:/utilisateur";
        } else if (roles.contains("ROLE_PROFESSEUR")) {
            return "redirect:/eleve";
        }
        return "redirect:/login";
    }

    @GetMapping("/utilisateur")
    public String liste(Model model) {
        model.addAttribute("utilisateurs", service.getAllUtilisateurs());
        return "utilisateur/list";
    }

    @GetMapping("/utilisateur/add")
    public String ajouter(Model model) {
        model.addAttribute("utilisateur", new UtilisateurModel());
        return "utilisateur/add";
    }

    @PostMapping("/utilisateur/save")
    public String save(@ModelAttribute UtilisateurModel utilisateur) {
        service.saveUtilisateur(utilisateur);
        return "redirect:/utilisateur";
    }

    // NOUVEAU : Cette méthode intercepte la mise à jour depuis le formulaire d'édition
    @PostMapping("/utilisateur/update")
    public String update(@ModelAttribute UtilisateurModel utilisateur) {
        service.saveUtilisateur(utilisateur); // En JPA/Spring Data, save() gère aussi bien l'insertion que la mise à jour si l'ID existe
        return "redirect:/utilisateur";
    }

    @GetMapping("/utilisateur/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model) {
        model.addAttribute("utilisateur", service.getUtilisateurById(id));
        return "utilisateur/edit";
    }

    @GetMapping("/utilisateur/supprimer/{id}")
    public String supprimer(@PathVariable Long id) {
        service.deleteUtilisateur(id);
        return "redirect:/utilisateur";
    }
}