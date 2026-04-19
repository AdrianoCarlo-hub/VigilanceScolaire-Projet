package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.ClasseModel;
import com.vigilance.vigilance.repository.ClasseRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ClasseService {

    private final ClasseRepository repository;

    public ClasseService(ClasseRepository repository) {
        this.repository = repository;
    }

    public List<ClasseModel> getAllClasses() {
        return repository.findAll();
    }

    public List<ClasseModel> getClassesByProfesseurId(Long professeurId) {
        return repository.findByUtilisateurId(professeurId);
    }

    public ClasseModel getClasseById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void saveClasse(ClasseModel classe) {
        repository.save(classe);
    }

    public void deleteClasse(Long id) {
        repository.deleteById(id);
    }
}