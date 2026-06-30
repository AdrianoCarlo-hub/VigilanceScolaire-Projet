package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.model.NoteModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.Date;
import java.util.List;

public interface NoteRepository extends JpaRepository<NoteModel, Long> {

    // Calcule la moyenne de tous les élèves pour une matière spécifique
    @Query("SELECT AVG(n.valeur) FROM NoteModel n WHERE n.matiere = :matiere")
    Double calculerMoyenneParMatiere(@Param("matiere") String matiere);

    // ADMIN : voir toutes les notes
    @Query("SELECT n FROM NoteModel n ORDER BY n.date_note DESC")
    List<NoteModel> findAllNotesOrderByDateDesc();

    // PROFESSEUR : voir uniquement les notes des élèves de SES classes
    @Query("SELECT n FROM NoteModel n WHERE n.eleve.classe.utilisateur.id_utilisateur = :profId ORDER BY n.date_note DESC")
    List<NoteModel> findNotesByProfesseurId(@Param("profId") Long profId);

    // ========== MÉTHODES POUR LE BULLETIN ==========

    /**
     * Récupère toutes les notes d'un élève
     */
    @Query("SELECT n FROM NoteModel n WHERE n.eleve.id_eleve = :eleveId")
    List<NoteModel> findNotesByEleveId(@Param("eleveId") Long eleveId);

    /**
     * Récupère les notes d'un élève entre deux dates (pour le trimestre)
     */
    @Query("SELECT n FROM NoteModel n WHERE n.eleve.id_eleve = :eleveId AND n.date_note BETWEEN :dateDebut AND :dateFin")
    List<NoteModel> findNotesByEleveIdAndDateRange(@Param("eleveId") Long eleveId,
                                                   @Param("dateDebut") Date dateDebut,
                                                   @Param("dateFin") Date dateFin);

    /**
     * Récupère toutes les notes d'une classe entre deux dates (pour le classement)
     */
    @Query("SELECT n FROM NoteModel n WHERE n.eleve.classe.id_classe = :classeId AND n.date_note BETWEEN :dateDebut AND :dateFin")
    List<NoteModel> findNotesByClasseIdAndDateRange(@Param("classeId") Long classeId,
                                                    @Param("dateDebut") Date dateDebut,
                                                    @Param("dateFin") Date dateFin);

    // ========== MÉTHODES POUR LES ALERTES ==========

    /**
     * Récupère toutes les notes inférieures à un seuil donné
     * Utilisé pour déclencher les alertes automatiques
     */
    @Query("SELECT n FROM NoteModel n WHERE n.valeur < :seuil")
    List<NoteModel> findByValeurLessThan(@Param("seuil") double seuil);

    /**
     * Calcule la moyenne des notes pour une matière et un élève donnés
     * Utilisé pour vérifier si une note est inférieure à la moyenne de l'élève dans cette matière
     */
    @Query("SELECT AVG(n.valeur) FROM NoteModel n WHERE n.matiere = :matiere AND n.eleve.id_eleve = :eleveId")
    Double calculerMoyenneEleveParMatiere(@Param("eleveId") Long eleveId, @Param("matiere") String matiere);

    /**
     * Récupère toutes les notes d'un élève pour une matière spécifique
     */
    @Query("SELECT n FROM NoteModel n WHERE n.eleve.id_eleve = :eleveId AND n.matiere = :matiere")
    List<NoteModel> findNotesByEleveIdAndMatiere(@Param("eleveId") Long eleveId, @Param("matiere") String matiere);

    /**
     * Récupère les 5 dernières notes d'un élève
     */
    @Query("SELECT n FROM NoteModel n WHERE n.eleve.id_eleve = :eleveId ORDER BY n.date_note DESC")
    List<NoteModel> findTop5ByEleveIdOrderByDateDesc(@Param("eleveId") Long eleveId);
}