package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.ParentModel;
import com.vigilance.vigilance.service.ParentService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/parent")
public class ParentController {

    private final ParentService service;

    public ParentController(ParentService service) {
        this.service = service;
    }

    /**
     * Affiche la liste des parents
     */
    @GetMapping("")
    public String liste(Model model) {
        List<ParentModel> parents = service.getAllParents();
        model.addAttribute("parents", parents != null ? parents : Collections.emptyList());
        return "parent/list";
    }

    /**
     * Affiche le formulaire d'ajout
     */
    @GetMapping("/add")
    public String ajouter(Model model) {
        model.addAttribute("parent", new ParentModel());
        return "parent/add";
    }

    /**
     * Sauvegarde un parent (création ou modification)
     */
    @PostMapping("/save")
    public String save(@ModelAttribute ParentModel parent, RedirectAttributes redirectAttributes) {
        try {
            boolean isNew = (parent.getId_parent() == null || parent.getId_parent() <= 0);

            // Validation des champs
            if (parent.getNom() == null || parent.getNom().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le nom est obligatoire");
                return isNew ? "redirect:/parent/add" : "redirect:/parent/edit/" + parent.getId_parent();
            }

            if (parent.getPrenom() == null || parent.getPrenom().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le prenom est obligatoire");
                return isNew ? "redirect:/parent/add" : "redirect:/parent/edit/" + parent.getId_parent();
            }

            if (parent.getTelephone() == null || parent.getTelephone().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Le telephone est obligatoire");
                return isNew ? "redirect:/parent/add" : "redirect:/parent/edit/" + parent.getId_parent();
            }

            if (parent.getEmail() == null || parent.getEmail().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "L'email est obligatoire");
                return isNew ? "redirect:/parent/add" : "redirect:/parent/edit/" + parent.getId_parent();
            }

            if (parent.getAdresse() == null || parent.getAdresse().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "L'adresse est obligatoire");
                return isNew ? "redirect:/parent/add" : "redirect:/parent/edit/" + parent.getId_parent();
            }

            service.saveParent(parent);

            String nomComplet = parent.getNom() + " " + parent.getPrenom();
            if (isNew) {
                redirectAttributes.addFlashAttribute("success", "Parent \"" + nomComplet + "\" ajoute avec succes !");
            } else {
                redirectAttributes.addFlashAttribute("success", "Parent \"" + nomComplet + "\" modifie avec succes !");
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
        }
        return "redirect:/parent";
    }

    /**
     * Affiche le formulaire de modification (URL avec "edit")
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            ParentModel parent = service.getParentById(id);
            if (parent == null) {
                redirectAttributes.addFlashAttribute("error", "Parent non trouve !");
                return "redirect:/parent";
            }
            model.addAttribute("parent", parent);
            return "parent/edit";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur : " + e.getMessage());
            return "redirect:/parent";
        }
    }

    /**
     * Affiche le formulaire de modification (URL avec "modifier" - compatibilité)
     */
    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        return edit(id, model, redirectAttributes);
    }

    /**
     * Supprime un parent
     */
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            ParentModel parent = service.getParentById(id);
            if (parent == null) {
                redirectAttributes.addFlashAttribute("error", "Parent non trouve !");
                return "redirect:/parent";
            }
            String nomComplet = parent.getNom() + " " + parent.getPrenom();
            service.deleteParent(id);
            redirectAttributes.addFlashAttribute("success", "Parent \"" + nomComplet + "\" supprime avec succes !");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
        }
        return "redirect:/parent";
    }

    /**
     * Endpoint API REST pour AJAX - recupere la liste des parents
     */
    @GetMapping("/api/parents")
    @ResponseBody
    public ResponseEntity<List<ParentModel>> getParentsApi() {
        List<ParentModel> parents = service.getAllParents();
        return ResponseEntity.ok(parents != null ? parents : Collections.emptyList());
    }

    /**
     * Endpoint API REST pour AJAX - recupere un parent par son ID
     */
    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<ParentModel> getParentApi(@PathVariable Long id) {
        ParentModel parent = service.getParentById(id);
        if (parent == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(parent);
    }
}