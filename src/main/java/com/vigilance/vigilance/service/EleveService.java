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
//admin prof
// Nouvelle méthode pour le filtrage par prof
public Map<String, List<EleveModel>> getElevesGroupedByClassForProf(Long userId) {
    Map<String, List<EleveModel>> groupedMap = new LinkedHashMap<>();

    // On ne récupère que les noms des classes gérées par CE prof
    List<String> classNames = repository.findClassNamesByProfesseurId(userId);

    for (String className : classNames) {
        List<EleveModel> eleves = repository.findByClasseNomOrderByNomAscPrenomAsc(className);
        groupedMap.put(className, eleves);
    }
    return groupedMap;
}

    // Pour récupérer la liste simple si besoin
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


}