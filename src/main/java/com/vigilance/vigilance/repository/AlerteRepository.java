package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.AlerteModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AlerteRepository extends JpaRepository<AlerteModel, Long> {

    // ADMIN : alertes en attente (toutes)
    @Query("SELECT a FROM AlerteModel a WHERE a.statut = 'EN_ATTENTE' ORDER BY a.dateAlerte DESC")
    List<AlerteModel> findAlertesEnAttente();

    // PROFESSEUR : alertes en attente de SES élèves
    @Query("SELECT a FROM AlerteModel a WHERE a.statut = 'EN_ATTENTE' AND a.eleve.classe.utilisateur.id_utilisateur = :profId ORDER BY a.dateAlerte DESC")
    List<AlerteModel> findAlertesEnAttenteByProfesseurId(@Param("profId") Long profId);

    // ADMIN : toutes les alertes
    @Query("SELECT a FROM AlerteModel a ORDER BY a.dateAlerte DESC")
    List<AlerteModel> findAllOrderByDateDesc();

    // PROFESSEUR : alertes de SES élèves
    @Query("SELECT a FROM AlerteModel a WHERE a.eleve.classe.utilisateur.id_utilisateur = :profId ORDER BY a.dateAlerte DESC")
    List<AlerteModel> findAlertesByProfesseurId(@Param("profId") Long profId);

    // ADMIN : alertes envoyées
    @Query("SELECT a FROM AlerteModel a WHERE a.statut = 'ENVOYE' ORDER BY a.dateEnvoi DESC")
    List<AlerteModel> findAlertesEnvoyees();

    // PROFESSEUR : alertes envoyées de SES élèves
    @Query("SELECT a FROM AlerteModel a WHERE a.statut = 'ENVOYE' AND a.eleve.classe.utilisateur.id_utilisateur = :profId ORDER BY a.dateEnvoi DESC")
    List<AlerteModel> findAlertesEnvoyeesByProfesseurId(@Param("profId") Long profId);

    // ========== MÉTHODES POUR LES ALERTES (ajoutées) ==========

    /**
     * Vérifie si une alerte existe déjà pour une référence donnée
     * Utilisé pour éviter les doublons
     */
    boolean existsByIdReferenceAndTypeReference(Long idReference, String typeReference);

    /**
     * Récupère une alerte par sa référence
     */
    @Query("SELECT a FROM AlerteModel a WHERE a.idReference = :idReference AND a.typeReference = :typeReference")
    List<AlerteModel> findByIdReferenceAndTypeReference(@Param("idReference") Long idReference,
                                                        @Param("typeReference") String typeReference);

    /**
     * Récupère les alertes d'un élève
     */
    @Query("SELECT a FROM AlerteModel a WHERE a.eleve.id_eleve = :eleveId ORDER BY a.dateAlerte DESC")
    List<AlerteModel> findByEleveId(@Param("eleveId") Long eleveId);

    /**
     * Récupère les alertes par type
     */
    @Query("SELECT a FROM AlerteModel a WHERE a.type = :type ORDER BY a.dateAlerte DESC")
    List<AlerteModel> findByType(@Param("type") String type);

    /**
     * Récupère les alertes par statut
     */
    @Query("SELECT a FROM AlerteModel a WHERE a.statut = :statut ORDER BY a.dateAlerte DESC")
    List<AlerteModel> findByStatut(@Param("statut") String statut);
}