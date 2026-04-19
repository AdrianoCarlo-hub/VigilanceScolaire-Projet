package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.UtilisateurModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional; // IMPORTANT : N'oublie pas cet import

@Repository
public interface UtilisateurRepository extends JpaRepository<UtilisateurModel, Long> {

    // Une seule méthode suffit. On utilise Optional pour pouvoir utiliser .orElse(null) dans le Service
    Optional<UtilisateurModel> findByUsername(String username);

}