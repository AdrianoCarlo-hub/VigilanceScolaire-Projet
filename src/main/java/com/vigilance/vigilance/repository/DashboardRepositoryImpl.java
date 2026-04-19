package com.vigilance.vigilance.repository;

import com.vigilance.vigilance.dto.AdminDashboardDTO;
import com.vigilance.vigilance.dto.ProfessorDashboardDTO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Repository
public class DashboardRepositoryImpl implements DashboardRepository {

    @PersistenceContext
    private EntityManager em;

    // ========== ADMIN ==========

    @Override
    public long countTotalEleves() {
        Query query = em.createNativeQuery("SELECT COUNT(*) FROM eleve");
        return ((Number) query.getSingleResult()).longValue();
    }

    @Override
    public long countTotalProfesseurs() {
        Query query = em.createNativeQuery("SELECT COUNT(*) FROM utilisateur WHERE role = 'PROFESSEUR'");
        return ((Number) query.getSingleResult()).longValue();
    }

    @Override
    public long countTotalClasses() {
        Query query = em.createNativeQuery("SELECT COUNT(*) FROM classe");
        return ((Number) query.getSingleResult()).longValue();
    }

    @Override
    public Map<String, Long> getElevesParClasse() {
        Query query = em.createNativeQuery(
                "SELECT c.nom, COUNT(e.id_eleve) FROM classe c " +
                        "LEFT JOIN eleve e ON e.id_classe = c.id_classe " +
                        "GROUP BY c.nom ORDER BY c.nom"
        );
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put((String) row[0], ((Number) row[1]).longValue());
        }
        return map;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map<String, Long> getAbsencesParMois() {
        String sql = """
            SELECT 
                TO_CHAR(date_absence, 'Mon') as mois,
                COUNT(*) as total
            FROM absence 
            WHERE EXTRACT(YEAR FROM date_absence) = EXTRACT(YEAR FROM CURRENT_DATE)
            GROUP BY EXTRACT(MONTH FROM date_absence), TO_CHAR(date_absence, 'Mon')
            ORDER BY EXTRACT(MONTH FROM date_absence)
        """;
        Query query = em.createNativeQuery(sql);
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put((String) row[0], ((Number) row[1]).longValue());
        }
        return map;
    }

    @Override
    public Map<String, Long> getAbsencesJustifieesStats() {
        Query query = em.createNativeQuery(
                "SELECT " +
                        "CASE WHEN justifie = true THEN 'Justifiées' ELSE 'Non justifiées' END as type, " +
                        "COUNT(*) FROM absence GROUP BY justifie"
        );
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new HashMap<>();
        for (Object[] row : results) {
            map.put((String) row[0], ((Number) row[1]).longValue());
        }
        if (!map.containsKey("Justifiées")) map.put("Justifiées", 0L);
        if (!map.containsKey("Non justifiées")) map.put("Non justifiées", 0L);
        return map;
    }

    @Override
    public List<AdminDashboardDTO.AlerteDTO> getTop5AlertesRecentes() {
        Query query = em.createNativeQuery(
                "SELECT a.id_alerte, a.message, a.type, a.date_alerte, CONCAT(e.nom, ' ', e.prenom) " +
                        "FROM alerte a LEFT JOIN eleve e ON a.id_eleve = e.id_eleve " +
                        "ORDER BY a.date_alerte DESC LIMIT 5"
        );
        List<Object[]> results = query.getResultList();
        List<AdminDashboardDTO.AlerteDTO> alertes = new ArrayList<>();
        for (Object[] row : results) {
            AdminDashboardDTO.AlerteDTO alerte = new AdminDashboardDTO.AlerteDTO();
            alerte.setId(((Number) row[0]).longValue());
            alerte.setMessage((String) row[1]);
            alerte.setType((String) row[2]);
            alerte.setDate(row[3] != null ? row[3].toString() : "");
            alerte.setEleveNom((String) row[4]);
            alertes.add(alerte);
        }
        return alertes;
    }

    // ========== PROFESSEUR ==========

    @Override
    public String getProfesseurNom(Long professeurId) {
        Query query = em.createNativeQuery("SELECT username FROM utilisateur WHERE id_utilisateur = ?");
        query.setParameter(1, professeurId);
        return (String) query.getSingleResult();
    }

    @Override
    public long countElevesByProfesseurId(Long professeurId) {
        Query query = em.createNativeQuery(
                "SELECT COUNT(DISTINCT e.id_eleve) FROM classe c " +
                        "JOIN eleve e ON e.id_classe = c.id_classe " +
                        "WHERE c.id_utilisateur = ?"
        );
        query.setParameter(1, professeurId);
        return ((Number) query.getSingleResult()).longValue();
    }

    @Override
    public long countClassesByProfesseurId(Long professeurId) {
        Query query = em.createNativeQuery("SELECT COUNT(*) FROM classe WHERE id_utilisateur = ?");
        query.setParameter(1, professeurId);
        return ((Number) query.getSingleResult()).longValue();
    }

    @Override
    public Map<String, ProfessorDashboardDTO.ClasseStatsDTO> getStatsClassesByProfesseur(Long professeurId) {
        Query query = em.createNativeQuery(
                "SELECT " +
                        "c.nom, " +
                        "COUNT(DISTINCT e.id_eleve) as nb_eleves, " +
                        "COUNT(a.id_absence) as total_absences, " +
                        "SUM(CASE WHEN a.justifie = true THEN 1 ELSE 0 END) as abs_justifiees, " +
                        "SUM(CASE WHEN a.justifie = false THEN 1 ELSE 0 END) as abs_non_justifiees " +
                        "FROM classe c " +
                        "LEFT JOIN eleve e ON e.id_classe = c.id_classe " +
                        "LEFT JOIN absence a ON a.id_eleve = e.id_eleve " +
                        "WHERE c.id_utilisateur = ? " +
                        "GROUP BY c.id_classe, c.nom"
        );
        query.setParameter(1, professeurId);
        List<Object[]> results = query.getResultList();
        Map<String, ProfessorDashboardDTO.ClasseStatsDTO> map = new LinkedHashMap<>();

        for (Object[] row : results) {
            ProfessorDashboardDTO.ClasseStatsDTO stats = new ProfessorDashboardDTO.ClasseStatsDTO();
            stats.setClasseNom((String) row[0]);
            long nbEleves = ((Number) row[1]).longValue();
            stats.setNombreEleves(nbEleves);
            long totalAbsences = ((Number) row[2]).longValue();
            stats.setAbsencesJustifiees(((Number) row[3]).longValue());
            stats.setAbsencesNonJustifiees(((Number) row[4]).longValue());

            if (nbEleves > 0) {
                double taux = (totalAbsences * 100.0) / (nbEleves * 20);
                stats.setTauxAbsence(Math.round(taux * 100.0) / 100.0);
            }
            map.put(stats.getClasseNom(), stats);
        }
        return map;
    }

    @Override
    public Map<String, Long> getAbsencesParClasseByProfesseur(Long professeurId) {
        Query query = em.createNativeQuery(
                "SELECT c.nom, COUNT(a.id_absence) " +
                        "FROM classe c " +
                        "LEFT JOIN eleve e ON e.id_classe = c.id_classe " +
                        "LEFT JOIN absence a ON a.id_eleve = e.id_eleve " +
                        "WHERE c.id_utilisateur = ? " +
                        "GROUP BY c.nom ORDER BY c.nom"
        );
        query.setParameter(1, professeurId);
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            map.put((String) row[0], ((Number) row[1]).longValue());
        }
        return map;
    }

    @Override
    public Map<String, Long> getAbsencesJustifieesParClasseByProfesseur(Long professeurId) {
        Query query = em.createNativeQuery(
                "SELECT c.nom, COUNT(a.id_absence) " +
                        "FROM classe c " +
                        "LEFT JOIN eleve e ON e.id_classe = c.id_classe " +
                        "LEFT JOIN absence a ON a.id_eleve = e.id_eleve " +
                        "WHERE c.id_utilisateur = ? AND a.justifie = true " +
                        "GROUP BY c.nom ORDER BY c.nom"
        );
        query.setParameter(1, professeurId);
        List<Object[]> results = query.getResultList();
        Map<String, Long> map = new LinkedHashMap<>();
        for (Object[] row : results) {
            Long val = row[1] != null ? ((Number) row[1]).longValue() : 0L;
            map.put((String) row[0], val);
        }
        return map;
    }
}