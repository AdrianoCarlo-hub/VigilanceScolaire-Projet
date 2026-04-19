package com.vigilance.vigilance.dto;

public class CommunicationDTO {
    private Long idAlerte;
    private Long idEleve;
    private String nomEleve;
    private String prenomEleve;
    private String telephoneParent;
    private String emailParent;
    private String typeAlerte;
    private String messageAuto;
    private String messagePersonnalise;
    private Object details;

    public CommunicationDTO() {}

    // Getters et Setters
    public Long getIdAlerte() { return idAlerte; }
    public void setIdAlerte(Long idAlerte) { this.idAlerte = idAlerte; }

    public Long getIdEleve() { return idEleve; }
    public void setIdEleve(Long idEleve) { this.idEleve = idEleve; }

    public String getNomEleve() { return nomEleve; }
    public void setNomEleve(String nomEleve) { this.nomEleve = nomEleve; }

    public String getPrenomEleve() { return prenomEleve; }
    public void setPrenomEleve(String prenomEleve) { this.prenomEleve = prenomEleve; }

    public String getTelephoneParent() { return telephoneParent; }
    public void setTelephoneParent(String telephoneParent) { this.telephoneParent = telephoneParent; }

    public String getEmailParent() { return emailParent; }
    public void setEmailParent(String emailParent) { this.emailParent = emailParent; }

    public String getTypeAlerte() { return typeAlerte; }
    public void setTypeAlerte(String typeAlerte) { this.typeAlerte = typeAlerte; }

    public String getMessageAuto() { return messageAuto; }
    public void setMessageAuto(String messageAuto) { this.messageAuto = messageAuto; }

    public String getMessagePersonnalise() { return messagePersonnalise; }
    public void setMessagePersonnalise(String messagePersonnalise) { this.messagePersonnalise = messagePersonnalise; }

    public Object getDetails() { return details; }
    public void setDetails(Object details) { this.details = details; }

    public String getMessageComplet() {
        return messagePersonnalise + "\n\n--- MESSAGE AUTOMATIQUE ---\n" + messageAuto;
    }
}