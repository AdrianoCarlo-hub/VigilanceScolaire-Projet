package com.vigilance.vigilance.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "alerte")
public class AlerteModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idAlerte;

    private String canal;

    @Column(name = "date_alerte")
    private LocalDateTime dateAlerte;

    @Column(columnDefinition = "TEXT")
    private String message;

    private String statut;

    private String type;

    @ManyToOne
    @JoinColumn(name = "id_eleve")
    private EleveModel eleve;

    @Column(name = "id_reference")
    private Long idReference;

    @Column(name = "type_reference")
    private String typeReference;

    // ========== NOUVEAUX CHAMPS POUR L'HISTORIQUE ==========

    @Column(name = "date_envoi")
    private LocalDateTime dateEnvoi;

    @Column(name = "contenu_email", columnDefinition = "TEXT")
    private String contenuEmail;

    @Column(name = "contenu_sms", columnDefinition = "TEXT")
    private String contenuSms;

    // ========== CONSTRUCTEURS ==========

    public AlerteModel() {}

    public AlerteModel(String message, String type, EleveModel eleve) {
        this.message = message;
        this.type = type;
        this.eleve = eleve;
        this.dateAlerte = LocalDateTime.now();
        this.statut = "EN_ATTENTE";
        this.canal = "EN_ATTENTE";
    }

    // ========== GETTERS ET SETTERS ==========

    public Long getIdAlerte() {
        return idAlerte;
    }

    public void setIdAlerte(Long idAlerte) {
        this.idAlerte = idAlerte;
    }

    public String getCanal() {
        return canal;
    }

    public void setCanal(String canal) {
        this.canal = canal;
    }

    public LocalDateTime getDateAlerte() {
        return dateAlerte;
    }

    public void setDateAlerte(LocalDateTime dateAlerte) {
        this.dateAlerte = dateAlerte;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public EleveModel getEleve() {
        return eleve;
    }

    public void setEleve(EleveModel eleve) {
        this.eleve = eleve;
    }

    public Long getIdReference() {
        return idReference;
    }

    public void setIdReference(Long idReference) {
        this.idReference = idReference;
    }

    public String getTypeReference() {
        return typeReference;
    }

    public void setTypeReference(String typeReference) {
        this.typeReference = typeReference;
    }

    // ========== GETTERS ET SETTERS POUR LES NOUVEAUX CHAMPS ==========

    public LocalDateTime getDateEnvoi() {
        return dateEnvoi;
    }

    public void setDateEnvoi(LocalDateTime dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }

    public String getContenuEmail() {
        return contenuEmail;
    }

    public void setContenuEmail(String contenuEmail) {
        this.contenuEmail = contenuEmail;
    }

    public String getContenuSms() {
        return contenuSms;
    }

    public void setContenuSms(String contenuSms) {
        this.contenuSms = contenuSms;
    }
}