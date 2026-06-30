package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.dto.CommunicationDTO;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.AlerteService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/communication")
public class CommunicationController {

    private final AlerteService alerteService;
    private final UtilisateurService utilisateurService;

    public CommunicationController(AlerteService alerteService, UtilisateurService utilisateurService) {
        this.alerteService = alerteService;
        this.utilisateurService = utilisateurService;
    }

    @GetMapping("")
    public String redirectToAlertes() {
        return "redirect:/communication/alertes";
    }

    @GetMapping("/alertes")
    public String listerAlertesEnAttente(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        List<CommunicationDTO> alertes;
        if (roles.contains("ROLE_ADMIN")) {
            alertes = alerteService.getAlertesEnAttente();
        } else if (user != null) {
            alertes = alerteService.getAlertesEnAttenteForProf(user.getId_utilisateur());
        } else {
            alertes = java.util.Collections.emptyList();
        }

        model.addAttribute("alertes", alertes);
        return "communication/alertes";
    }

    @GetMapping("/envoyer/{idAlerte}")
    public String formulaireEnvoi(@PathVariable Long idAlerte, Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        List<CommunicationDTO> alertes;
        if (roles.contains("ROLE_ADMIN")) {
            alertes = alerteService.getAlertesEnAttente();
        } else if (user != null) {
            alertes = alerteService.getAlertesEnAttenteForProf(user.getId_utilisateur());
        } else {
            alertes = java.util.Collections.emptyList();
        }

        CommunicationDTO alerte = alertes.stream()
                .filter(a -> a.getIdAlerte().equals(idAlerte))
                .findFirst()
                .orElse(null);

        if (alerte == null) {
            return "redirect:/communication/alertes";
        }

        model.addAttribute("alerte", alerte);
        return "communication/formulaire";
    }

    @PostMapping("/envoyer")
    public String traiterEnvoi(@RequestParam Long idAlerte,
                               @RequestParam(required = false) String messagePersonnalise,
                               RedirectAttributes redirectAttributes) {
        try {
            alerteService.envoyerCommunication(idAlerte, messagePersonnalise);
            redirectAttributes.addFlashAttribute("success", "Alerte envoyee avec succes !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'envoi : " + e.getMessage());
        }
        return "redirect:/communication/alertes";
    }

    /**
     * Envoie toutes les alertes en attente
     */
    @PostMapping("/envoyer-toutes")
    public String envoyerToutesAlertes(RedirectAttributes redirectAttributes) {
        try {
            int count = alerteService.envoyerAlertesEnAttente();
            redirectAttributes.addFlashAttribute("success", count + " alerte(s) envoyee(s) avec succes !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'envoi : " + e.getMessage());
        }
        return "redirect:/communication/alertes";
    }

    /**
     * Supprime une alerte en attente
     */
    @GetMapping("/supprimer/{idAlerte}")
    public String supprimerAlerte(@PathVariable Long idAlerte, RedirectAttributes redirectAttributes) {
        try {
            alerteService.deleteAlerte(idAlerte);
            redirectAttributes.addFlashAttribute("success", "Alerte supprimee avec succes !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
        }
        return "redirect:/communication/alertes";
    }
}