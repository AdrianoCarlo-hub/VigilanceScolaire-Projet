package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.AlerteModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.AlerteService;
import com.vigilance.vigilance.service.EleveService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.Set;

@Controller
@RequestMapping("/alerte")
public class AlerteController {

    private final AlerteService service;
    private final EleveService eleveService;
    private final UtilisateurService utilisateurService;

    public AlerteController(AlerteService service, EleveService eleveService, UtilisateurService utilisateurService) {
        this.service = service;
        this.eleveService = eleveService;
        this.utilisateurService = utilisateurService;
    }

    @GetMapping("")
    public String liste(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("alertes", service.getAllAlertes());
        } else if (user != null) {
            model.addAttribute("alertes", service.getAlertesByProfesseurId(user.getId_utilisateur()));
        } else {
            model.addAttribute("alertes", java.util.Collections.emptyList());
        }
        return "alerte/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model, Authentication authentication) {
        model.addAttribute("alerte", new AlerteModel());

        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("eleves", eleveService.getAllEleves());
        } else if (user != null) {
            model.addAttribute("eleves", eleveService.getElevesByProf(user.getId_utilisateur()));
        } else {
            model.addAttribute("eleves", java.util.Collections.emptyList());
        }
        return "alerte/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute AlerteModel alerte) {
        service.envoyerEtSauvegarder(alerte);
        return "redirect:/alerte";
    }

    // Ajoutez ici vos méthodes modifier et supprimer si elles existent
}