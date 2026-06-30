package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.EleveModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EleveRepository extends JpaRepository<EleveModel, Long> {

    // ========== MÉTHODES EXISTANTES ==========

    /**
     * Récupère tous les élèves groupés par classe (nom, classe, élève)
     */
    @Query("SELECT e.classe.nom as className, e FROM EleveModel e ORDER BY e.classe.nom, e.nom, e.prenom")
    List<Object[]> findAllGroupedByClass();

    /**
     * Récupère les élèves d'une classe spécifique triés par nom et prénom
     */
    List<EleveModel> findByClasseNomOrderByNomAscPrenomAsc(String classeNom);

    /**
     * Récupère la liste de tous les noms de classes distincts
     */
    @Query("SELECT DISTINCT e.classe.nom FROM EleveModel e WHERE e.classe IS NOT NULL ORDER BY e.classe.nom")
    List<String> findAllDistinctClassNames();

    /**
     * Récupère les élèves d'une classe par son ID
     */
    @Query("SELECT e FROM EleveModel e WHERE e.classe.id_classe = :classeId")
    List<EleveModel> findElevesByClasseId(@Param("classeId") Long classeId);

    // ========== MÉTHODES POUR LE FILTRAGE PAR PROFESSEUR ==========

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

    // ========== MÉTHODES POUR LES RELATIONS ET ALERTES ==========

    /**
     * Récupère un élève avec ses relations (parent, classe) chargées
     * Utile pour les alertes où on a besoin des données complètes
     */
    @Query("SELECT e FROM EleveModel e LEFT JOIN FETCH e.parent LEFT JOIN FETCH e.classe WHERE e.id_eleve = :id")
    Optional<EleveModel> findEleveWithRelationsById(@Param("id") Long id);

    /**
     * Récupère les élèves d'une classe avec leurs relations (parent)
     * Utile pour les exports et les bulletins
     */
    @Query("SELECT e FROM EleveModel e LEFT JOIN FETCH e.parent WHERE e.classe.id_classe = :classeId")
    List<EleveModel> findElevesByClasseWithRelations(@Param("classeId") Long classeId);

    /**
     * Récupère tous les élèves avec leurs relations (parent, classe)
     * Utile pour les exports complets
     */
    @Query("SELECT e FROM EleveModel e LEFT JOIN FETCH e.parent LEFT JOIN FETCH e.classe")
    List<EleveModel> findAllWithRelations();

    /**
     * Vérifie si un élève existe par son ID
     */
    boolean existsById(Long id);

    /**
     * Récupère le nombre d'élèves par classe
     */
    @Query("SELECT COUNT(e) FROM EleveModel e WHERE e.classe.id_classe = :classeId")
    long countByClasseId(@Param("classeId") Long classeId);
}