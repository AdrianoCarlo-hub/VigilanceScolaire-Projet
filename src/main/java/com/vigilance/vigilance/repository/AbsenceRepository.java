package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.AbsenceModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

public interface AbsenceRepository extends JpaRepository<AbsenceModel, Long> {

    // ADMIN : toutes les absences avec infos
    @Query("SELECT a FROM AbsenceModel a LEFT JOIN FETCH a.eleve e LEFT JOIN FETCH e.classe ORDER BY e.classe.nom, e.nom, e.prenom, a.date_absence DESC")
    List<AbsenceModel> findAllWithEleveAndClasse();

    // PROFESSEUR : absences des élèves de SES classes
    @Query("SELECT a FROM AbsenceModel a LEFT JOIN FETCH a.eleve e LEFT JOIN FETCH e.classe WHERE e.classe.utilisateur.id_utilisateur = :profId ORDER BY e.classe.nom, e.nom, e.prenom, a.date_absence DESC")
    List<AbsenceModel> findAbsencesByProfesseurId(@Param("profId") Long profId);

    // ADMIN : toutes les classes avec absences
    @Query("SELECT DISTINCT e.classe.nom FROM AbsenceModel a JOIN a.eleve e WHERE e.classe IS NOT NULL ORDER BY e.classe.nom")
    List<String> findAllDistinctClassNamesWithAbsences();

    // PROFESSEUR : classes du prof avec absences
    @Query("SELECT DISTINCT e.classe.nom FROM AbsenceModel a JOIN a.eleve e WHERE e.classe IS NOT NULL AND e.classe.utilisateur.id_utilisateur = :profId ORDER BY e.classe.nom")
    List<String> findClassNamesWithAbsencesByProfesseurId(@Param("profId") Long profId);

    @Query("SELECT COUNT(a) FROM AbsenceModel a WHERE a.eleve.id_eleve = :idEleve AND a.justifie = false")
    long compterAbsencesNonJustifiees(@Param("idEleve") Long idEleve);
}