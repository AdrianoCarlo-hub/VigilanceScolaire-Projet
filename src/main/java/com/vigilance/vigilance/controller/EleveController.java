package com.vigilance.vigilance.controller;

import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.ParentModel;
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
import java.util.*;

@Controller
@RequestMapping("/eleve")
public class EleveController {

    private final EleveService eleveService;
    private final ClasseService classeService;
    private final ParentService parentService;
    private final UtilisateurService utilisateurService;
    private final ExportExcelService exportExcelService;
    private final ExportPdfService exportPdfService;

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

    // Utilisation d'un dossier externe au projet pour éviter les 404 et conflits de build
    private final String uploadDir = "C:/vigilance-uploads/";

    @GetMapping("/all")
    public String listeSimple(Model model) {
        model.addAttribute("elevesByClass", eleveService.getElevesGroupedByClass());
        return "eleve/list";
    }

    @GetMapping("/add")
    public String ajouter(Model model) {
        EleveModel eleve = new EleveModel();
        eleve.setId_eleve(null); // CRUCIAL : S'assure que l'ID est null pour un nouvel ajout
        model.addAttribute("eleve", eleve);
        model.addAttribute("classes", classeService.getAllClasses());
        model.addAttribute("parents", parentService.getAllParents());
        return "eleve/add";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute EleveModel eleve,
                       @RequestParam(value = "file", required = false) MultipartFile file,
                       RedirectAttributes redirectAttributes) {
        try {
            boolean isNew = (eleve.getId_eleve() == null || eleve.getId_eleve() <= 0);

            // Si c'est un nouvel élève, forcer l'ID à null et vider l'état de l'image
            if (isNew) {
                eleve.setId_eleve(null);
                eleve.setPhoto(null);
            }

            Files.createDirectories(Paths.get(uploadDir));

            // Gestion de l'upload de photo (vérifie si le fichier a un nom réel et n'est pas vide)
            if (file != null && !file.isEmpty() && file.getOriginalFilename() != null && !file.getOriginalFilename().isEmpty()) {
                String originalFilename = file.getOriginalFilename();
                String extension = (originalFilename.contains(".")) ?
                        originalFilename.substring(originalFilename.lastIndexOf(".")) : "";

                String fileName = UUID.randomUUID().toString() + extension;
                Path path = Paths.get(uploadDir + fileName);
                Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);

                // Si modification, supprimer l'ancienne photo
                if (!isNew) {
                    EleveModel existing = eleveService.getEleveById(eleve.getId_eleve());
                    if (existing != null && existing.getPhoto() != null) {
                        Files.deleteIfExists(Paths.get(uploadDir + existing.getPhoto()));
                    }
                }
                eleve.setPhoto(fileName);
            } else if (!isNew) {
                // Si aucune nouvelle image n'est uploadée en mode modification, garder l'ancienne
                EleveModel existing = eleveService.getEleveById(eleve.getId_eleve());
                if (existing != null) {
                    eleve.setPhoto(existing.getPhoto());
                }
            }

            // Attacher les objets réels (Classe et Parent) via leurs IDs respectifs
            if (eleve.getClasse() != null && eleve.getClasse().getId_classe() != null) {
                ClasseModel realClasse = classeService.getClasseById(eleve.getClasse().getId_classe());
                eleve.setClasse(realClasse);
            }

            if (eleve.getParent() != null && eleve.getParent().getId_parent() != null) {
                ParentModel realParent = parentService.getParentById(eleve.getParent().getId_parent());
                eleve.setParent(realParent);
            }

            eleveService.saveEleve(eleve);
            redirectAttributes.addFlashAttribute("success", "Élève enregistré avec succès !");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Erreur fichier : " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement : " + e.getMessage());
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
                Files.deleteIfExists(Paths.get(uploadDir + eleve.getPhoto()));
            }
            eleveService.deleteEleve(id);
            redirectAttributes.addFlashAttribute("success", "Élève supprimé !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression");
        }
        return "redirect:/eleve";
    }

    // ========== API pour les absences ==========

    /**
     * API standard - retourne l'objet EleveModel complet
     */
    @GetMapping("/byClasse/{classeId}")
    @ResponseBody
    public List<EleveModel> getElevesByClasse(@PathVariable Long classeId) {
        List<EleveModel> liste = eleveService.getElevesByClasseId(classeId);
        System.out.println("Nombre d'élèves trouvés : " + liste.size());
        return liste;
    }

    /**
     * API simplifiée - retourne uniquement id, nom et prenom des élèves
     * Utilisé pour l'ajout d'absences en masse
     */
    @GetMapping("/byClasse/simple/{classeId}")
    @ResponseBody
    public List<Map<String, Object>> getElevesSimpleByClasse(@PathVariable Long classeId) {
        List<EleveModel> eleves = eleveService.getElevesByClasseId(classeId);
        List<Map<String, Object>> result = new ArrayList<>();

        for (EleveModel eleve : eleves) {
            Map<String, Object> map = new HashMap<>();
            map.put("id_eleve", eleve.getId_eleve());
            map.put("nom", eleve.getNom());
            map.put("prenom", eleve.getPrenom());
            result.add(map);
        }
        System.out.println("API simplifiée - " + result.size() + " élèves retournés");
        return result;
    }

    @GetMapping("/api/{id}")
    @ResponseBody
    public EleveModel getEleveApi(@PathVariable Long id) {
        return eleveService.getEleveById(id);
    }

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