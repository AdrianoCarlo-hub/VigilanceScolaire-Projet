package com.vigilance.vigilance.dto;

import java.time.LocalDateTime;

public class AlerteHistoriqueDTO {
    private Long idAlerte;
    private String nomEleve;
    private String prenomEleve;
    private String matricule;
    private String sexeEleve;
    private String nomParent;
    private String prenomParent;
    private String emailParent;
    private String telephoneParent;
    private String typeAlerte;
    private String messageAuto;
    private String messageEnvoye;
    private String statut;
    private LocalDateTime dateAlerte;
    private LocalDateTime dateEnvoi;

    // Constructeurs
    public AlerteHistoriqueDTO() {}

    // Getters et Setters
    public Long getIdAlerte() { return idAlerte; }
    public void setIdAlerte(Long idAlerte) { this.idAlerte = idAlerte; }

    public String getNomEleve() { return nomEleve; }
    public void setNomEleve(String nomEleve) { this.nomEleve = nomEleve; }

    public String getPrenomEleve() { return prenomEleve; }
    public void setPrenomEleve(String prenomEleve) { this.prenomEleve = prenomEleve; }

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public String getSexeEleve() { return sexeEleve; }
    public void setSexeEleve(String sexeEleve) { this.sexeEleve = sexeEleve; }

    public String getNomParent() { return nomParent; }
    public void setNomParent(String nomParent) { this.nomParent = nomParent; }

    public String getPrenomParent() { return prenomParent; }
    public void setPrenomParent(String prenomParent) { this.prenomParent = prenomParent; }

    public String getEmailParent() { return emailParent; }
    public void setEmailParent(String emailParent) { this.emailParent = emailParent; }

    public String getTelephoneParent() { return telephoneParent; }
    public void setTelephoneParent(String telephoneParent) { this.telephoneParent = telephoneParent; }

    public String getTypeAlerte() { return typeAlerte; }
    public void setTypeAlerte(String typeAlerte) { this.typeAlerte = typeAlerte; }

    public String getMessageAuto() { return messageAuto; }
    public void setMessageAuto(String messageAuto) { this.messageAuto = messageAuto; }

    public String getMessageEnvoye() { return messageEnvoye; }
    public void setMessageEnvoye(String messageEnvoye) { this.messageEnvoye = messageEnvoye; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public LocalDateTime getDateAlerte() { return dateAlerte; }
    public void setDateAlerte(LocalDateTime dateAlerte) { this.dateAlerte = dateAlerte; }

    public LocalDateTime getDateEnvoi() { return dateEnvoi; }
    public void setDateEnvoi(LocalDateTime dateEnvoi) { this.dateEnvoi = dateEnvoi; }
}