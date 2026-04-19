package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.EleveModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface EleveRepository extends JpaRepository<EleveModel, Long> {

    // --- Méthodes existantes ---

    @Query("SELECT e.classe.nom as className, e FROM EleveModel e ORDER BY e.classe.nom, e.nom, e.prenom")
    List<Object[]> findAllGroupedByClass();

    List<EleveModel> findByClasseNomOrderByNomAscPrenomAsc(String classeNom);

    @Query("SELECT DISTINCT e.classe.nom FROM EleveModel e WHERE e.classe IS NOT NULL ORDER BY e.classe.nom")
    List<String> findAllDistinctClassNames();

    @Query("SELECT e FROM EleveModel e WHERE e.classe.id_classe = :classeId")
    List<EleveModel> findElevesByClasseId(@Param("classeId") Long classeId);

    // --- NOUVELLES MÉTHODES POUR LE FILTRAGE PAR PROFESSEUR ---

    /**
     * Récupère tous les élèves des classes gérées par un utilisateur (professeur) spécifique
     */
    @Query("SELECT e FROM EleveModel e WHERE e.classe.utilisateur.id_utilisateur = :userId")
    List<EleveModel> findByProfesseurId(@Param("userId") Long userId);

    /**
     * Récupère uniquement les noms des classes gérées par un professeur spécifique
     */
    @Query("SELECT DISTINCT e.classe.nom FROM EleveModel e WHERE e.classe.utilisateur.id_utilisateur = :userId")
    List<String> findClassNamesByProfesseurId(@Param("userId") Long userId);
}