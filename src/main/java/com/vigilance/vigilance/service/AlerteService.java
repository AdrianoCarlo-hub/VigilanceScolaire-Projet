package com.vigilance.vigilance.service;

import com.vigilance.vigilance.dto.AlerteHistoriqueDTO;
import com.vigilance.vigilance.dto.CommunicationDTO;
import com.vigilance.vigilance.model.AlerteModel;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.ParentModel;
import com.vigilance.vigilance.repository.AlerteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AlerteService {

    private final AlerteRepository alerteRepository;
    private final EmailService emailService;
    private final SmsService smsService;

    public AlerteService(AlerteRepository alerteRepository, EmailService emailService, SmsService smsService) {
        this.alerteRepository = alerteRepository;
        this.emailService = emailService;
        this.smsService = smsService;
    }

    // ========== CRÉATION ET ENVOI ==========

    @Transactional
    public AlerteModel creerAlerte(AlerteModel alerte) {
        if (alerte.getDateAlerte() == null) {
            alerte.setDateAlerte(LocalDateTime.now());
        }
        if (alerte.getStatut() == null) {
            alerte.setStatut("EN_ATTENTE");
        }
        return alerteRepository.save(alerte);
    }

    @Transactional
    public void envoyerAlerte(Long alerteId) {
        AlerteModel alerte = alerteRepository.findById(alerteId)
                .orElseThrow(() -> new RuntimeException("Alerte non trouvee"));
        envoyerAlerte(alerte);
    }

    @Transactional
    public void envoyerAlerte(AlerteModel alerte) {
        EleveModel eleve = alerte.getEleve();
        if (eleve == null) {
            throw new RuntimeException("Eleve non trouve pour cette alerte");
        }

        ParentModel parent = eleve.getParent();
        if (parent == null) {
            throw new RuntimeException("Parent non trouve pour cette alerte");
        }

        String emailParent = parent.getEmail();
        String telephoneParent = parent.getTelephone();

        if (emailParent != null && !emailParent.isEmpty()) {
            emailService.envoyerEmailAvecInfosEleve(parent, eleve, null, alerte.getMessage());
        }

        if (telephoneParent != null && !telephoneParent.isEmpty()) {
            smsService.envoyerSmsAvecInfosEleve(parent, eleve, null, alerte.getMessage());
        }

        alerte.setStatut("ENVOYE");
        alerte.setDateEnvoi(LocalDateTime.now());
        alerteRepository.save(alerte);
    }

    @Transactional
    public int envoyerAlertesEnAttente() {
        List<AlerteModel> alertes = alerteRepository.findAlertesEnAttente();
        int count = 0;
        for (AlerteModel alerte : alertes) {
            envoyerAlerte(alerte);
            count++;
        }
        return count;
    }

    @Transactional
    public void envoyerCommunication(Long idAlerte, String messagePersonnalise) {
        AlerteModel alerte = getAlerteById(idAlerte);
        if (alerte == null) {
            throw new RuntimeException("Alerte non trouvee");
        }

        if (messagePersonnalise != null && !messagePersonnalise.trim().isEmpty()) {
            String messageComplet = "Message du professeur : " + messagePersonnalise + "\n\n" + alerte.getMessage();
            alerte.setMessage(messageComplet);
        }

        envoyerAlerte(alerte);
    }

    // ========== MÉTHODES RETOURNANT CommunicationDTO ==========

    public List<CommunicationDTO> getAlertesEnAttente() {
        return alerteRepository.findAlertesEnAttente().stream()
                .map(this::convertToCommunicationDTO)
                .collect(Collectors.toList());
    }

    public List<CommunicationDTO> getAlertesEnAttenteForProf(Long profId) {
        return alerteRepository.findAlertesEnAttenteByProfesseurId(profId).stream()
                .map(this::convertToCommunicationDTO)
                .collect(Collectors.toList());
    }

    // ========== MÉTHODES RETOURNANT AlerteHistoriqueDTO ==========

    public List<AlerteHistoriqueDTO> getHistoriqueAlertes() {
        return alerteRepository.findAllOrderByDateDesc().stream()
                .filter(alerte -> alerte.getStatut() != null && alerte.getStatut().equals("ENVOYE"))
                .map(this::convertToHistoriqueDTO)
                .collect(Collectors.toList());
    }

    public List<AlerteHistoriqueDTO> getHistoriqueAlertesForProf(Long profId) {
        return alerteRepository.findAlertesByProfesseurId(profId).stream()
                .filter(alerte -> alerte.getStatut() != null && alerte.getStatut().equals("ENVOYE"))
                .map(this::convertToHistoriqueDTO)
                .collect(Collectors.toList());
    }

    // ========== MÉTHODES DE CONVERSION ==========

    private CommunicationDTO convertToCommunicationDTO(AlerteModel alerte) {
        CommunicationDTO dto = new CommunicationDTO();
        dto.setIdAlerte(alerte.getIdAlerte());
        dto.setMessageAuto(alerte.getMessage());
        dto.setTypeAlerte(alerte.getType());
        dto.setDetails(alerte);

        if (alerte.getEleve() != null) {
            EleveModel eleve = alerte.getEleve();
            dto.setIdEleve(eleve.getId_eleve());
            dto.setNomEleve(eleve.getNom());
            dto.setPrenomEleve(eleve.getPrenom());
        }

        if (alerte.getEleve() != null && alerte.getEleve().getParent() != null) {
            ParentModel parent = alerte.getEleve().getParent();
            dto.setEmailParent(parent.getEmail());
            dto.setTelephoneParent(parent.getTelephone());
        }

        return dto;
    }

    private AlerteHistoriqueDTO convertToHistoriqueDTO(AlerteModel alerte) {
        AlerteHistoriqueDTO dto = new AlerteHistoriqueDTO();

        // Informations de l'alerte
        dto.setIdAlerte(alerte.getIdAlerte());
        dto.setDateAlerte(alerte.getDateAlerte());
        dto.setDateEnvoi(alerte.getDateEnvoi() != null ? alerte.getDateEnvoi() : alerte.getDateAlerte());
        dto.setTypeAlerte(alerte.getType());
        dto.setMessageAuto(alerte.getMessage());
        dto.setMessageEnvoye(alerte.getMessage()); // Le message envoyé est le même que le message auto
        dto.setStatut(alerte.getStatut());

        if (alerte.getEleve() != null) {
            EleveModel eleve = alerte.getEleve();
            dto.setNomEleve(eleve.getNom());
            dto.setPrenomEleve(eleve.getPrenom());

            dto.setSexeEleve(eleve.getSexe());
        }

        if (alerte.getEleve() != null && alerte.getEleve().getParent() != null) {
            ParentModel parent = alerte.getEleve().getParent();
            dto.setNomParent(parent.getNom());
            dto.setPrenomParent(parent.getPrenom());
            dto.setEmailParent(parent.getEmail());
            dto.setTelephoneParent(parent.getTelephone());
        }

        return dto;
    }

    // ========== MÉTHODES POUR COMPATIBILITÉ (retournent AlerteModel) ==========

    public List<AlerteModel> getAlertesEnAttenteModel() {
        return alerteRepository.findAlertesEnAttente();
    }

    public List<AlerteModel> getAlertesEnAttenteByProfModel(Long profId) {
        return alerteRepository.findAlertesEnAttenteByProfesseurId(profId);
    }

    public List<AlerteModel> getAllAlertesModel() {
        return alerteRepository.findAllOrderByDateDesc();
    }

    public List<AlerteModel> getAlertesByProfModel(Long profId) {
        return alerteRepository.findAlertesByProfesseurId(profId);
    }

    public AlerteModel getAlerteById(Long id) {
        return alerteRepository.findById(id).orElse(null);
    }

    public void deleteAlerte(Long id) {
        alerteRepository.deleteById(id);
    }
}