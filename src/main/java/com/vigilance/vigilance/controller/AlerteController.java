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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
            model.addAttribute("alertes", service.getAllAlertesModel());
        } else if (user != null) {
            model.addAttribute("alertes", service.getAlertesByProfModel(user.getId_utilisateur()));
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
    public String save(@ModelAttribute AlerteModel alerte, RedirectAttributes redirectAttributes) {
        try {
            // Créer l'alerte en base (statut = EN_ATTENTE) sans l'envoyer
            AlerteModel createdAlerte = service.creerAlerte(alerte);
            redirectAttributes.addFlashAttribute("success",
                    "Alerte creee avec succes ! Elle est en attente d'envoi.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de la creation de l'alerte : " + e.getMessage());
        }
        return "redirect:/alerte";
    }

    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model, Authentication authentication) {
        AlerteModel alerte = service.getAlerteById(id);
        if (alerte == null) {
            return "redirect:/alerte";
        }

        model.addAttribute("alerte", alerte);

        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("eleves", eleveService.getAllEleves());
        } else if (user != null) {
            model.addAttribute("eleves", eleveService.getElevesByProf(user.getId_utilisateur()));
        } else {
            model.addAttribute("eleves", java.util.Collections.emptyList());
        }
        return "alerte/edit";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute AlerteModel alerte, RedirectAttributes redirectAttributes) {
        try {
            // Mettre à jour l'alerte existante
            service.creerAlerte(alerte);
            redirectAttributes.addFlashAttribute("success", "Alerte modifiee avec succes !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la modification : " + e.getMessage());
        }
        return "redirect:/alerte";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            service.deleteAlerte(id);
            redirectAttributes.addFlashAttribute("success", "Alerte supprimee avec succes !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
        }
        return "redirect:/alerte";
    }

    /**
     * Endpoint pour envoyer une alerte specifique
     */
    @GetMapping("/envoyer/{id}")
    public String envoyerAlerte(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            service.envoyerAlerte(id);
            redirectAttributes.addFlashAttribute("success", "Alerte envoyee avec succes !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'envoi : " + e.getMessage());
        }
        return "redirect:/alerte";
    }
}