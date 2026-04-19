package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.EvenementModel;
import com.vigilance.vigilance.service.EvenementService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/evenement")
public class EvenementController {

    private final EvenementService service;

    public EvenementController(EvenementService service) {
        this.service = service;
    }

    @GetMapping("")
    public String liste(Model model) {
        model.addAttribute("evenements", service.getAllEvenements());
        return "evenement/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model) {
        model.addAttribute("evenement", new EvenementModel());
        return "evenement/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute EvenementModel evenement) {
        service.saveEvenement(evenement);
        return "redirect:/evenement";
    }

    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model) {
        model.addAttribute("evenement", service.getEvenementById(id));
        return "evenement/edit";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id) {
        service.deleteEvenement(id);
        return "redirect:/evenement";
    }
}