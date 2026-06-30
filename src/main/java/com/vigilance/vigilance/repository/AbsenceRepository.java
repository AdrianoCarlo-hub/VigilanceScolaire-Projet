package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.AbsenceModel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AbsenceRepository extends JpaRepository<AbsenceModel, Long> {

    // ADMIN : toutes les absences avec jointures et recherche dynamique paginée
    @Query("SELECT a FROM AbsenceModel a LEFT JOIN FETCH a.eleve e LEFT JOIN FETCH e.classe c WHERE " +
            "(:search = '' OR LOWER(e.nom) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR LOWER(e.prenom) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR LOWER(a.motif) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR LOWER(c.nom) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR CAST(e.id_eleve AS string) LIKE %:search%)")
    Page<AbsenceModel> findAllWithEleveAndClassePaginated(@Param("search") String search, Pageable pageable);

    // PROFESSEUR : absences des élèves de SES classes avec recherche dynamique paginée
    @Query("SELECT a FROM AbsenceModel a LEFT JOIN FETCH a.eleve e LEFT JOIN FETCH e.classe c WHERE " +
            "e.classe.utilisateur.id_utilisateur = :profId AND " +
            "(:search = '' OR LOWER(e.nom) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR LOWER(e.prenom) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR LOWER(a.motif) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR LOWER(c.nom) LIKE LOWER(CONCAT('%', :search, '%')) " +
            "OR CAST(e.id_eleve AS string) LIKE %:search%)")
    Page<AbsenceModel> findAbsencesByProfesseurIdPaginated(@Param("profId") Long profId, @Param("search") String search, Pageable pageable);

    // Récupération des absences selon l'identifiant de la classe
    @Query("SELECT a FROM AbsenceModel a LEFT JOIN FETCH a.eleve e LEFT JOIN FETCH e.classe c WHERE c.id_classe = :classId")
    List<AbsenceModel> findAbsencesByClassId(@Param("classId") Long classId);

    // ADMIN : toutes les classes avec absences
    @Query("SELECT DISTINCT e.classe.nom FROM AbsenceModel a JOIN a.eleve e WHERE e.classe IS NOT NULL ORDER BY e.classe.nom")
    List<String> findAllDistinctClassNamesWithAbsences();

    // PROFESSEUR : classes du prof avec absences
    @Query("SELECT DISTINCT e.classe.nom FROM AbsenceModel a JOIN a.eleve e WHERE e.classe IS NOT NULL AND e.classe.utilisateur.id_utilisateur = :profId ORDER BY e.classe.nom")
    List<String> findClassNamesWithAbsencesByProfesseurId(@Param("profId") Long profId);

    @Query("SELECT COUNT(a) FROM AbsenceModel a WHERE a.eleve.id_eleve = :idEleve AND a.justifie = false")
    long compterAbsencesNonJustifiees(@Param("idEleve") Long idEleve);

    // Statistiques Dashboard
    @Query("SELECT COUNT(a) FROM AbsenceModel a WHERE (:profId IS NULL OR a.eleve.classe.utilisateur.id_utilisateur = :profId)")
    long countTotalAbsences(@Param("profId") Long profId);

    @Query("SELECT COUNT(a) FROM AbsenceModel a WHERE a.justifie = true AND (:profId IS NULL OR a.eleve.classe.utilisateur.id_utilisateur = :profId)")
    long countJustifie(@Param("profId") Long profId);

    @Query("SELECT COUNT(a) FROM AbsenceModel a WHERE a.justifie = false AND (:profId IS NULL OR a.eleve.classe.utilisateur.id_utilisateur = :profId)")
    long countNonJustifie(@Param("profId") Long profId);

    @Query("SELECT COUNT(a) FROM AbsenceModel a WHERE a.date_absence = :today AND (:profId IS NULL OR a.eleve.classe.utilisateur.id_utilisateur = :profId)")
    long countAbsentsAujourdHui(@Param("today") LocalDate today, @Param("profId") Long profId);

    @Query("SELECT a.eleve.classe.nom, COUNT(a) FROM AbsenceModel a WHERE (:profId IS NULL OR a.eleve.classe.utilisateur.id_utilisateur = :profId) GROUP BY a.eleve.classe.nom ORDER BY COUNT(a) DESC")
    List<Object[]> findClassePlusTouchee(@Param("profId") Long profId);

    @Query("SELECT a.eleve.nom, a.eleve.prenom, COUNT(a) FROM AbsenceModel a WHERE (:profId IS NULL OR a.eleve.classe.utilisateur.id_utilisateur = :profId) GROUP BY a.eleve.id_eleve, a.eleve.nom, a.eleve.prenom ORDER BY COUNT(a) DESC")
    List<Object[]> findElevePlusAbsent(@Param("profId") Long profId);
}