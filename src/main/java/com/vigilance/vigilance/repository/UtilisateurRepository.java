package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.UtilisateurModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UtilisateurRepository extends JpaRepository<UtilisateurModel, Long> {

    Optional<UtilisateurModel> findByUsername(String username);

    // CORRECTION : Utiliser le rôle exact comme dans la base
    List<UtilisateurModel> findByRole(String role);
}