package com.vigilance.vigilance.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    @GetMapping("/")
    public String home(){
        return "redirect:/login"; // Ne pas retourner "index", mais rediriger vers la route de login
    }
}