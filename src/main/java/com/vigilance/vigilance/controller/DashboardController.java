package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.dto.AdminDashboardDTO;
import com.vigilance.vigilance.dto.ProfessorDashboardDTO;
import com.vigilance.vigilance.service.DashboardService;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.repository.UtilisateurRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    private final DashboardService dashboardService;
    private final UtilisateurRepository utilisateurRepository;

    public DashboardController(DashboardService dashboardService, UtilisateurRepository utilisateurRepository) {
        this.dashboardService = dashboardService;
        this.utilisateurRepository = utilisateurRepository;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        UtilisateurModel user = utilisateurRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouve: " + username));

        String role = user.getRole();
        System.out.println("=== DASHBOARD ===");
        System.out.println("Utilisateur: " + username);
        System.out.println("Role: " + role);

        // Admin - afficher le dashboard administrateur
        if ("ADMIN".equals(role) || "ROLE_ADMIN".equals(role)) {
            System.out.println("Chargement du Dashboard ADMIN");
            AdminDashboardDTO dashboard = dashboardService.getAdminDashboard();
            model.addAttribute("dashboard", dashboard);
            return "dashboard/admin";
        }
        // Professeur - afficher le dashboard professeur
        else if ("PROFESSEUR".equals(role) || "ROLE_PROFESSEUR".equals(role)) {
            System.out.println("Chargement du Dashboard PROFESSEUR");
            ProfessorDashboardDTO dashboard = dashboardService.getProfessorDashboard(user.getId_utilisateur());
            model.addAttribute("dashboard", dashboard);
            return "dashboard/professor";
        }

        System.out.println("Role non reconnu: " + role);
        return "redirect:/home";
    }
}