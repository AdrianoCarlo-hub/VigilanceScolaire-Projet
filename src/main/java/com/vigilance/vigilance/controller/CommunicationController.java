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
                               @RequestParam String messagePersonnalise) {
        alerteService.envoyerCommunication(idAlerte, messagePersonnalise);
        return "redirect:/communication/alertes";
    }
}