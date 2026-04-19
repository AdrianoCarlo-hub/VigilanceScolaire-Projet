package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.ParentModel;
import com.vigilance.vigilance.service.ParentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/parent")
public class ParentController {

    private final ParentService service;

    public ParentController(ParentService service) {
        this.service = service;
    }

    @GetMapping("")
    public String liste(Model model) {
        model.addAttribute("parents", service.getAllParents());
        return "parent/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model) {
        model.addAttribute("parent", new ParentModel());
        return "parent/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute ParentModel parent) {
        service.saveParent(parent);
        return "redirect:/parent";
    }

    @GetMapping("/modifier/{id}")
    public String modifier(@PathVariable Long id, Model model) {
        model.addAttribute("parent", service.getParentById(id));
        return "parent/edit";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimer(@PathVariable Long id) {
        service.deleteParent(id);
        return "redirect:/parent";
    }
}