package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.service.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.*;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Controller
@RequestMapping("/eleve")
public class EleveController {

    private final EleveService eleveService;
    private final ClasseService classeService;
    private final ParentService parentService;
    private final UtilisateurService utilisateurService;
    private final ExportExcelService exportExcelService;
    private final ExportPdfService exportPdfService;

    // Constructeur mis à jour
    public EleveController(EleveService eleveService, ClasseService classeService,
                           ParentService parentService, UtilisateurService utilisateurService,
                           ExportExcelService exportExcelService, ExportPdfService exportPdfService) {
        this.eleveService = eleveService;
        this.classeService = classeService;
        this.parentService = parentService;
        this.utilisateurService = utilisateurService;
        this.exportExcelService = exportExcelService;
        this.exportPdfService = exportPdfService;
    }

    @GetMapping("/all")
    public String listeSimple(Model model) {
        model.addAttribute("elevesByClass", eleveService.getElevesGroupedByClass());
        return "eleve/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model) {
        model.addAttribute("eleve", new EleveModel());
        model.addAttribute("classes", classeService.getAllClasses());
        model.addAttribute("parents", parentService.getAllParents());
        return "eleve/add";
    }

    // Modifie la variable uploadDir dans tes méthodes save et supprimer
    String uploadDir = "C:/Users/ASUS AMD/Pictures/vigilance/";

    @PostMapping("/save")
    public String save(@ModelAttribute EleveModel eleve,
                       @RequestParam(value = "file", required = false) MultipartFile file,
                       RedirectAttributes redirectAttributes) {
        try {
            // 1. Définir le dossier externe
            String uploadDir = "C:/Users/ASUS AMD/Pictures/vigilance/";
            Files.createDirectories(Paths.get(uploadDir));

            if (file != null && !file.isEmpty()) {
                String originalFilename = file.getOriginalFilename();
                String extension = (originalFilename != null && originalFilename.contains(".")) ?
                        originalFilename.substring(originalFilename.lastIndexOf(".")) : "";

                String fileName = UUID.randomUUID().toString() + extension;
                Path path = Paths.get(uploadDir + fileName);
                Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);

                // Supprimer l'ancienne photo si modification
                if (eleve.getId_eleve() != null) {
                    EleveModel existing = eleveService.getEleveById(eleve.getId_eleve());
                    if (existing != null && existing.getPhoto() != null) {
                        Files.deleteIfExists(Paths.get(uploadDir + existing.getPhoto()));
                    }
                }
                eleve.setPhoto(fileName);
            } else if (eleve.getId_eleve() != null) {
                EleveModel existing = eleveService.getEleveById(eleve.getId_eleve());
                if (existing != null) eleve.setPhoto(existing.getPhoto());
            }

            eleveService.saveEleve(eleve);
            redirectAttributes.addFlashAttribute("success", "Élève enregistré !");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Erreur : " + e.getMessage());
        }
        return "redirect:/eleve";
    }

    @GetMapping("/edit/{id}")
    public String modifier(@PathVariable Long id, Model model) {
        EleveModel eleve = eleveService.getEleveById(id);
        if (eleve == null) {
            return "redirect:/eleve";
        }
        model.addAttribute("eleve", eleve);
        model.addAttribute("classes", classeService.getAllClasses());
        model.addAttribute("parents", parentService.getAllParents());
        return "eleve/edit";
    }

    @GetMapping("/delete/{id}")
    public String supprimer(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            EleveModel eleve = eleveService.getEleveById(id);
            if (eleve != null && eleve.getPhoto() != null) {
                String uploadDir = "C:/Users/ASUS AMD/Pictures/vigilance/";
                Files.deleteIfExists(Paths.get(uploadDir + eleve.getPhoto()));
            }
            eleveService.deleteEleve(id);
            redirectAttributes.addFlashAttribute("success", "Élève supprimé !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression");
        }
        return "redirect:/eleve";
    }

    @GetMapping("/byClasse/{classeId}")
    @ResponseBody
    public List<EleveModel> getElevesByClasse(@PathVariable Long classeId) {
        List<EleveModel> liste = eleveService.getElevesByClasseId(classeId);
        System.out.println("Nombre d'élèves trouvés : " + liste.size());
        return liste;
    }

    @GetMapping("/api/{id}")
    @ResponseBody
    public EleveModel getEleveApi(@PathVariable Long id) {
        return eleveService.getEleveById(id);
    }

    // MÉTHODE PRINCIPALE POUR LA LISTE (URL: /eleve)
    @GetMapping("")
    public String liste(Model model, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());

        if (roles.contains("ROLE_ADMIN")) {
            model.addAttribute("elevesByClass", eleveService.getElevesGroupedByClass());
        } else {
            if (user != null) {
                model.addAttribute("elevesByClass", eleveService.getElevesGroupedByClassForProf(user.getId_utilisateur()));
            }
        }
        return "eleve/list";
    }

    // ========== EXPORTS ==========

    /**
     * Export Excel des élèves d'une classe
     */
    @GetMapping("/export/excel/{classeId}")
    public ResponseEntity<byte[]> exportExcelByClasse(@PathVariable Long classeId, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        if (!roles.contains("ROLE_ADMIN")) {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            ClasseModel classe = classeService.getClasseById(classeId);
            if (classe == null || classe.getUtilisateur() == null ||
                    !classe.getUtilisateur().getId_utilisateur().equals(user.getId_utilisateur())) {
                return ResponseEntity.status(403).build();
            }
        }

        List<EleveModel> eleves = eleveService.getElevesByClasseId(classeId);
        ClasseModel classe = classeService.getClasseById(classeId);
        String classeNom = classe != null ? classe.getNom() : "classe";

        byte[] excelData = exportExcelService.exportElevesToExcel(eleves, classeNom);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", "eleves_" + classeNom.replaceAll(" ", "_") + ".xlsx");

        return ResponseEntity.ok().headers(headers).body(excelData);
    }

    /**
     * Export PDF des élèves d'une classe
     */
    @GetMapping("/export/pdf/{classeId}")
    public ResponseEntity<byte[]> exportPdfByClasse(@PathVariable Long classeId, Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        if (!roles.contains("ROLE_ADMIN")) {
            UtilisateurModel user = utilisateurService.findByUsername(authentication.getName());
            ClasseModel classe = classeService.getClasseById(classeId);
            if (classe == null || classe.getUtilisateur() == null ||
                    !classe.getUtilisateur().getId_utilisateur().equals(user.getId_utilisateur())) {
                return ResponseEntity.status(403).build();
            }
        }

        List<EleveModel> eleves = eleveService.getElevesByClasseId(classeId);
        ClasseModel classe = classeService.getClasseById(classeId);
        String classeNom = classe != null ? classe.getNom() : "classe";

        byte[] pdfData = exportPdfService.exportElevesToPdf(eleves, classeNom);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", "eleves_" + classeNom.replaceAll(" ", "_") + ".pdf");

        return ResponseEntity.ok().headers(headers).body(pdfData);
    }
}