package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.repository.UtilisateurRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UtilisateurService {

    private final UtilisateurRepository repository;
    private final PasswordEncoder passwordEncoder;

    public UtilisateurService(UtilisateurRepository repository, PasswordEncoder passwordEncoder) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    // ========== MÉTHODES DE BASE ==========

    /**
     * Récupère un utilisateur par son nom d'utilisateur
     */
    public UtilisateurModel findByUsername(String username) {
        return repository.findByUsername(username).orElse(null);
    }

    /**
     * Récupère tous les utilisateurs
     */
    public List<UtilisateurModel> getAllUtilisateurs() {
        return repository.findAll();
    }

    /**
     * Récupère un utilisateur par son ID
     */
    public UtilisateurModel getUtilisateurById(Long id) {
        return repository.findById(id).orElse(null);
    }

    /**
     * Sauvegarde ou met à jour un utilisateur
     */
    public void saveUtilisateur(UtilisateurModel utilisateur) {
        // Hache le mot de passe seulement s'il est nouveau ou modifié
        if (utilisateur.getPassword() != null && !utilisateur.getPassword().isEmpty()) {
            // Vérifier si le mot de passe n'est pas déjà hashé
            if (!utilisateur.getPassword().startsWith("$2a$")) {
                utilisateur.setPassword(passwordEncoder.encode(utilisateur.getPassword()));
            }
        }
        repository.save(utilisateur);
    }

    /**
     * Supprime un utilisateur par son ID
     */
    public void deleteUtilisateur(Long id) {
        repository.deleteById(id);
    }

    // ========== MÉTHODES POUR LES RÔLES ==========

    /**
     * Récupère tous les utilisateurs ayant le rôle PROFESSEUR
     * Gère les deux formats possibles : "PROFESSEUR" et "ROLE_PROFESSEUR"
     */
    public List<UtilisateurModel> getProfesseurs() {
        List<UtilisateurModel> allUsers = repository.findAll();
        return allUsers.stream()
                .filter(user -> user.getRole() != null &&
                        (user.getRole().equals("PROFESSEUR") ||
                                user.getRole().equals("ROLE_PROFESSEUR")))
                .collect(Collectors.toList());
    }

    /**
     * Récupère tous les utilisateurs ayant le rôle ADMIN
     * Gère les deux formats possibles : "ADMIN" et "ROLE_ADMIN"
     */
    public List<UtilisateurModel> getAdmins() {
        List<UtilisateurModel> allUsers = repository.findAll();
        return allUsers.stream()
                .filter(user -> user.getRole() != null &&
                        (user.getRole().equals("ADMIN") ||
                                user.getRole().equals("ROLE_ADMIN")))
                .collect(Collectors.toList());
    }

    /**
     * Récupère tous les utilisateurs ayant un rôle spécifique (version alternative)
     */
    public List<UtilisateurModel> getUtilisateursByRole(String role) {
        return repository.findByRole(role);
    }
}