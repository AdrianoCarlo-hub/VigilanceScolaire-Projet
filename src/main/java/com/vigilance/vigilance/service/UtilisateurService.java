package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.repository.UtilisateurRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UtilisateurService {

    private final UtilisateurRepository repository;
    private final PasswordEncoder passwordEncoder;

    public UtilisateurService(UtilisateurRepository repository, PasswordEncoder passwordEncoder) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    // --- NOUVELLE MÉTHODE POUR LE CONTRÔLEUR ---
    public UtilisateurModel findByUsername(String username) {
        return repository.findByUsername(username).orElse(null);
    }

    public List<UtilisateurModel> getAllUtilisateurs() {
        return repository.findAll();
    }

    public UtilisateurModel getUtilisateurById(Long id) {
        return repository.findById(id).orElse(null);
    }

    public void saveUtilisateur(UtilisateurModel utilisateur) {
        // IMPORTANT : Hache le mot de passe avant d'envoyer à PostgreSQL
        if (utilisateur.getPassword() != null && !utilisateur.getPassword().isEmpty()) {
            utilisateur.setPassword(passwordEncoder.encode(utilisateur.getPassword()));
        }
        repository.save(utilisateur);
    }

    public void deleteUtilisateur(Long id) {
        repository.deleteById(id);
    }
}