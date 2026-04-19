package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.EvenementModel;
import com.vigilance.vigilance.repository.EvenementRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EvenementService {

    private final EvenementRepository repository;

    public EvenementService(EvenementRepository repository) {
        this.repository = repository;
    }

    public List<EvenementModel> getAllEvenements() {
        return repository.findAll();
    }

    public EvenementModel getEvenementById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void saveEvenement(EvenementModel evenement) {
        repository.save(evenement);
    }

    public void deleteEvenement(Long id) {
        repository.deleteById(id);
    }
}