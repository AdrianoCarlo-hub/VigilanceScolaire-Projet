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
}