package com.vigilance.vigilance.service;

import com.vigilance.vigilance.dto.AlerteHistoriqueDTO;
import com.vigilance.vigilance.dto.CommunicationDTO;
import com.vigilance.vigilance.model.AlerteModel;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.ParentModel;
import com.vigilance.vigilance.repository.AlerteRepository;
import com.vigilance.vigilance.repository.EleveRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AlerteService {

    private final AlerteRepository alerteRepository;
    private final EleveRepository eleveRepository;
    private final SmsService smsService;
    private final EmailService emailService;

    public AlerteService(AlerteRepository alerteRepository,
                         EleveRepository eleveRepository,
                         SmsService smsService,
                         EmailService emailService) {
        this.alerteRepository = alerteRepository;
        this.eleveRepository = eleveRepository;
        this.smsService = smsService;
        this.emailService = emailService;
    }

    // ========== MÉTHODES EXISTANTES ==========

    public List<AlerteModel> getAllAlertes() {
        return alerteRepository.findAllOrderByDateDesc();
    }

    /**
     * Récupère toutes les alertes (historique + en attente) pour un professeur spécifique
     */
    public List<AlerteModel> getAlertesByProfesseurId(Long profId) {
        return alerteRepository.findAlertesByProfesseurId(profId);
    }

    public AlerteModel getAlerteById(Long id) {
        return alerteRepository.findById(id).orElse(null);
    }

    public void saveAlerte(AlerteModel alerte) {
        alerteRepository.save(alerte);
    }

    public void deleteAlerte(Long id) {
        alerteRepository.deleteById(id);
    }

    // ========== MÉTHODES POUR ALERTES EN ATTENTE ==========

    public List<CommunicationDTO> getAlertesEnAttente() {
        List<AlerteModel> alertes = alerteRepository.findAlertesEnAttente();
        List<CommunicationDTO> resultats = new ArrayList<>();

        for (AlerteModel alerte : alertes) {
            CommunicationDTO dto = new CommunicationDTO();
            dto.setIdAlerte(alerte.getIdAlerte());
            dto.setIdEleve(alerte.getEleve().getId_eleve());
            dto.setNomEleve(alerte.getEleve().getNom());
            dto.setPrenomEleve(alerte.getEleve().getPrenom());
            dto.setTypeAlerte(alerte.getType());
            dto.setMessageAuto(alerte.getMessage());

            EleveModel eleve = alerte.getEleve();
            if (eleve != null && eleve.getParent() != null) {
                ParentModel parent = eleve.getParent();
                dto.setEmailParent(parent.getEmail());
                dto.setTelephoneParent(parent.getTelephone());
            }

            resultats.add(dto);
        }

        return resultats;
    }

    // ========== NOUVELLE MÉTHODE AVEC HISTORIQUE ==========

    @Transactional
    public boolean envoyerCommunication(Long idAlerte, String messagePersonnalise) {
        AlerteModel alerte = alerteRepository.findById(idAlerte).orElse(null);
        if (alerte == null) {
            System.err.println("❌ Alerte non trouvée");
            return false;
        }

        EleveModel eleve = alerte.getEleve();
        if (eleve == null || eleve.getParent() == null) {
            System.err.println("❌ Parent non trouvé");
            return false;
        }

        ParentModel parent = eleve.getParent();
        String messageAuto = alerte.getMessage();

        // Envoyer SMS avec toutes les infos
        boolean smsOk = smsService.envoyerSmsAvecInfosEleve(parent, eleve, messagePersonnalise, messageAuto);

        // Envoyer Email avec toutes les infos
        boolean emailOk = emailService.envoyerEmailAvecInfosEleve(parent, eleve, messagePersonnalise, messageAuto);

        if (smsOk && emailOk) {
            // Mettre à jour l'alerte sans l'effacer (garder historique)
            alerte.setStatut("ENVOYE");
            alerte.setCanal("SMS_EMAIL");
            alerte.setDateEnvoi(LocalDateTime.now());

            // Sauvegarder le contenu envoyé pour l'historique
            String messageComplet = construireMessageCompletPourHistorique(parent, eleve, messagePersonnalise, messageAuto);
            alerte.setContenuEmail(messageComplet);
            alerte.setContenuSms(messageComplet);

            alerteRepository.save(alerte);
            System.out.println("✅ Communication envoyée et sauvegardée dans l'historique");
            return true;
        }

        return false;
    }

    /**
     * Construit le message complet pour l'historique
     */
    private String construireMessageCompletPourHistorique(ParentModel parent, EleveModel eleve, String messagePersonnalise, String messageAuto) {
        StringBuilder sb = new StringBuilder();

        sb.append("📢 ALERTE VIGILANCE\n");
        sb.append("═".repeat(50)).append("\n\n");

        if (messagePersonnalise != null && !messagePersonnalise.trim().isEmpty()) {
            sb.append("✏️ MESSAGE DU PROFESSEUR :\n");
            sb.append(messagePersonnalise).append("\n\n");
        }

        sb.append("👨‍🎓 INFORMATIONS ÉLÈVE :\n");
        sb.append("   Nom: ").append(eleve.getPrenom()).append(" ").append(eleve.getNom()).append("\n");
        sb.append("   Matricule: ").append(eleve.getMatricule()).append("\n");
        if (eleve.getClasse() != null) {
            sb.append("   Classe: ").append(eleve.getClasse().getNom()).append("\n");
        }
        sb.append("\n");

        sb.append("👪 INFORMATIONS PARENT :\n");
        sb.append("   Nom: ").append(parent.getPrenom()).append(" ").append(parent.getNom()).append("\n");
        sb.append("   Email: ").append(parent.getEmail()).append("\n");
        sb.append("   Téléphone: ").append(parent.getTelephone()).append("\n\n");

        sb.append("⚠️ ALERTE :\n");
        sb.append(messageAuto).append("\n\n");

        sb.append("═".repeat(50)).append("\n");
        sb.append("Email envoyé le: ").append(LocalDateTime.now()).append("\n");

        return sb.toString();
    }

    // ========== NOUVELLE MÉTHODE POUR L'HISTORIQUE ==========

    /**
     * Récupère l'historique de toutes les alertes envoyées
     */
    public List<AlerteHistoriqueDTO> getHistoriqueAlertes() {
        List<AlerteModel> alertes = alerteRepository.findAllOrderByDateDesc();

        return alertes.stream()
                .filter(a -> "ENVOYE".equals(a.getStatut()))
                .map(this::convertToHistoriqueDTO)
                .collect(Collectors.toList());
    }

    /**
     * Convertit une AlerteModel en AlerteHistoriqueDTO
     */
    private AlerteHistoriqueDTO convertToHistoriqueDTO(AlerteModel alerte) {
        AlerteHistoriqueDTO dto = new AlerteHistoriqueDTO();
        dto.setIdAlerte(alerte.getIdAlerte());
        dto.setTypeAlerte(alerte.getType());
        dto.setMessageAuto(alerte.getMessage());
        dto.setMessageEnvoye(alerte.getContenuEmail());
        dto.setStatut(alerte.getStatut());
        dto.setDateAlerte(alerte.getDateAlerte());
        dto.setDateEnvoi(alerte.getDateEnvoi());

        if (alerte.getEleve() != null) {
            EleveModel eleve = alerte.getEleve();
            dto.setNomEleve(eleve.getNom());
            dto.setPrenomEleve(eleve.getPrenom());
            dto.setMatricule(eleve.getMatricule());

            if (eleve.getParent() != null) {
                ParentModel parent = eleve.getParent();
                dto.setNomParent(parent.getNom());
                dto.setPrenomParent(parent.getPrenom());
                dto.setEmailParent(parent.getEmail());
                dto.setTelephoneParent(parent.getTelephone());
            }
        }

        return dto;
    }

    @Transactional
    public void envoyerEtSauvegarder(AlerteModel alerte) {
        if (alerte.getEleve() != null && alerte.getEleve().getParent() != null) {
            ParentModel parent = alerte.getEleve().getParent();
            EleveModel eleve = alerte.getEleve();
            String messageAuto = alerte.getMessage();

            smsService.envoyerSmsAvecInfosEleve(parent, eleve, alerte.getMessage(), messageAuto);
            emailService.envoyerEmailAvecInfosEleve(parent, eleve, alerte.getMessage(), messageAuto);
        }

        alerte.setDateAlerte(LocalDateTime.now());
        alerte.setDateEnvoi(LocalDateTime.now());
        alerte.setStatut("ENVOYE");
        alerte.setCanal("MANUEL");
        alerteRepository.save(alerte);
    }

    // ========== NOUVELLES MÉTHODES AVEC FILTRAGE PAR PROFESSEUR ==========

    /**
     * Récupère les alertes en attente pour un professeur spécifique
     */
    public List<CommunicationDTO> getAlertesEnAttenteForProf(Long profId) {
        List<AlerteModel> alertes = alerteRepository.findAlertesEnAttenteByProfesseurId(profId);
        return convertToCommunicationDTOList(alertes);
    }

    /**
     * Récupère l'historique des alertes pour un professeur spécifique
     */
    public List<AlerteHistoriqueDTO> getHistoriqueAlertesForProf(Long profId) {
        List<AlerteModel> alertes = alerteRepository.findAlertesEnvoyeesByProfesseurId(profId);
        return alertes.stream()
                .map(this::convertToHistoriqueDTO)
                .collect(Collectors.toList());
    }

    /**
     * Méthode utilitaire pour convertir une liste d'alertes en CommunicationDTO
     */
    private List<CommunicationDTO> convertToCommunicationDTOList(List<AlerteModel> alertes) {
        List<CommunicationDTO> resultats = new ArrayList<>();

        for (AlerteModel alerte : alertes) {
            CommunicationDTO dto = new CommunicationDTO();
            dto.setIdAlerte(alerte.getIdAlerte());
            dto.setIdEleve(alerte.getEleve().getId_eleve());
            dto.setNomEleve(alerte.getEleve().getNom());
            dto.setPrenomEleve(alerte.getEleve().getPrenom());
            dto.setTypeAlerte(alerte.getType());
            dto.setMessageAuto(alerte.getMessage());

            if (alerte.getEleve() != null && alerte.getEleve().getParent() != null) {
                ParentModel parent = alerte.getEleve().getParent();
                dto.setEmailParent(parent.getEmail());
                dto.setTelephoneParent(parent.getTelephone());
            }

            resultats.add(dto);
        }

        return resultats;
    }
}