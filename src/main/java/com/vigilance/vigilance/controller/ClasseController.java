package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.ClasseService;
import com.vigilance.vigilance.service.UtilisateurService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.List;
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

    // ==================== Gestion des vues ====================

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
                model.addAttribute("classes", Collections.emptyList());
            }
        }
        return "classe/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model) {
        model.addAttribute("classe", new ClasseModel());
        model.addAttribute("professeurs", utilisateurService.getProfesseurs());
        return "classe/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute ClasseModel classe, RedirectAttributes redirectAttributes) {
        try {
            // Vérifier si c'est une création ou une modification
            boolean isNew = (classe.getId_classe() == null || classe.getId_classe() <= 0);

            service.saveClasse(classe);

            if (isNew) {
                redirectAttributes.addFlashAttribute("success", "✅ Classe \"" + classe.getNom() + "\" créée avec succès !");
            } else {
                redirectAttributes.addFlashAttribute("success", "✅ Classe \"" + classe.getNom() + "\" modifiée avec succès !");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "❌ Erreur lors de l'enregistrement : " + e.getMessage());
        }
        return "redirect:/classe";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        ClasseModel classe = service.getClasseById(id);
        if (classe == null) {
            redirectAttributes.addFlashAttribute("error", "❌ Classe non trouvée !");
            return "redirect:/classe";
        }
        model.addAttribute("classe", classe);
        model.addAttribute("professeurs", utilisateurService.getProfesseurs());
        return "classe/edit";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            ClasseModel classe = service.getClasseById(id);
            if (classe == null) {
                redirectAttributes.addFlashAttribute("error", " Classe non trouvée !");
                return "redirect:/classe";
            }

            String nomClasse = classe.getNom();
            service.deleteClasse(id);
            redirectAttributes.addFlashAttribute("success", " Classe \"" + nomClasse + "\" supprimée avec succès !");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", " Erreur lors de la suppression : " + e.getMessage());
        }
        return "redirect:/classe";
    }

    // ==================== API REST pour AJAX ====================

    @GetMapping("/api/classes")
    @ResponseBody
    public ResponseEntity<List<ClasseModel>> getClassesApi(Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        List<ClasseModel> classes;

        if (roles.contains("ROLE_ADMIN")) {
            classes = service.getAllClasses();
        } else {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            if (user != null) {
                classes = service.getClassesByProfesseurId(user.getId_utilisateur());
            } else {
                classes = Collections.emptyList();
            }
        }
        return ResponseEntity.ok(classes != null ? classes : Collections.emptyList());
    }

    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<ClasseModel> getClasseApi(@PathVariable Long id) {
        ClasseModel classe = service.getClasseById(id);
        if (classe == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(classe);
    }
}