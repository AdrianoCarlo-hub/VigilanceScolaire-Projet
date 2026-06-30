package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.repository.EleveRepository;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class EleveService {

    private final EleveRepository repository;

    public EleveService(EleveRepository repository) {
        this.repository = repository;
    }

    public List<EleveModel> getAllEleves() {
        return repository.findAll();
    }

    public Map<String, List<EleveModel>> getElevesGroupedByClass() {
        Map<String, List<EleveModel>> groupedMap = new LinkedHashMap<>();
        List<String> classNames = repository.findAllDistinctClassNames();

        for (String className : classNames) {
            List<EleveModel> eleves = repository.findByClasseNomOrderByNomAscPrenomAsc(className);
            groupedMap.put(className, eleves);
        }
        return groupedMap;
    }

    /**
     * Filtrage des élèves groupés par classe selon l'utilisateur (professeur) connecté
     */
    public Map<String, List<EleveModel>> getElevesGroupedByClassForProf(Long userId) {
        Map<String, List<EleveModel>> groupedMap = new LinkedHashMap<>();
        List<String> classNames = repository.findClassNamesByProfesseurId(userId);

        for (String className : classNames) {
            List<EleveModel> eleves = repository.findByClasseNomOrderByNomAscPrenomAsc(className);
            groupedMap.put(className, eleves);
        }
        return groupedMap;
    }

    public List<EleveModel> getElevesByProf(Long userId) {
        return repository.findByProfesseurId(userId);
    }

    public List<EleveModel> getElevesByClasseId(Long classeId) {
        return repository.findElevesByClasseId(classeId);
    }

    public EleveModel getEleveById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void saveEleve(EleveModel eleve) {
        repository.save(eleve);
    }

    public void deleteEleve(Long id) {
        repository.deleteById(id);
    }

    // ========== MÉTHODES AJOUTÉES POUR LES ALERTES ET NOTES ==========

    /**
     * Récupère un élève avec ses relations (classe, parent) chargées
     * Utile pour les alertes où on a besoin des données complètes
     */
    public EleveModel getEleveWithRelations(Long id) {
        return repository.findEleveWithRelationsById(id).orElse(null);
    }

    /**
     * Récupère les élèves d'une classe avec leurs relations
     */
    public List<EleveModel> getElevesByClasseWithRelations(Long classeId) {
        return repository.findElevesByClasseWithRelations(classeId);
    }

    /**
     * Vérifie si un élève a un parent associé
     */
    public boolean hasParent(Long eleveId) {
        EleveModel eleve = getEleveById(eleveId);
        return eleve != null && eleve.getParent() != null;
    }

    /**
     * Récupère le nom complet d'un élève
     */
    public String getFullName(Long eleveId) {
        EleveModel eleve = getEleveById(eleveId);
        return eleve != null ? eleve.getNom() + " " + eleve.getPrenom() : "Inconnu";
    }
}