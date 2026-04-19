package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.dto.AlerteHistoriqueDTO;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.AlerteService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/historique")
public class HistoriqueController {

    private final AlerteService alerteService;
    private final UtilisateurService utilisateurService;

    public HistoriqueController(AlerteService alerteService, UtilisateurService utilisateurService) {
        this.alerteService = alerteService;
        this.utilisateurService = utilisateurService;
    }

    @GetMapping("/alertes")
    public String afficherHistorique(Model model, Authentication authentication) {
        try {
            Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

            List<AlerteHistoriqueDTO> historique;
            if (roles.contains("ROLE_ADMIN")) {
                historique = alerteService.getHistoriqueAlertes();
            } else if (user != null) {
                historique = alerteService.getHistoriqueAlertesForProf(user.getId_utilisateur());
            } else {
                historique = java.util.Collections.emptyList();
            }

            model.addAttribute("historique", historique);
        } catch (Exception e) {
            System.err.println("❌ Erreur dans HistoriqueController: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("erreur", e.getMessage());
            model.addAttribute("historique", java.util.Collections.emptyList());
        }
        return "historique/alertes";
    }
}