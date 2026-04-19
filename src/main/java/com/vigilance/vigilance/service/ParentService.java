package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.ParentModel;
import com.vigilance.vigilance.repository.ParentRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ParentService {

    private final ParentRepository repository;

    public ParentService(ParentRepository repository) {
        this.repository = repository;
    }

    public List<ParentModel> getAllParents() {
        return repository.findAll();
    }

    public ParentModel getParentById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void saveParent(ParentModel parent) {
        repository.save(parent);
    }

    public void deleteParent(Long id) {
        repository.deleteById(id);
    }
}