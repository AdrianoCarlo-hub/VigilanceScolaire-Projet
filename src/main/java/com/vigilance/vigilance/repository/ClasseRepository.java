package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.ClasseModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ClasseRepository extends JpaRepository<ClasseModel, Long> {

    // SOLUTION 1 : Utiliser @Query avec JPQL (RECOMMANDÉ)
    @Query("SELECT c FROM ClasseModel c WHERE c.utilisateur.id_utilisateur = :utilisateurId")
    List<ClasseModel> findByUtilisateurId(@Param("utilisateurId") Long utilisateurId);
}