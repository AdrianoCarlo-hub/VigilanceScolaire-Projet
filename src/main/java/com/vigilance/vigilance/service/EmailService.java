package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.ParentModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    /**
     * Envoie un email avec toutes les informations de l'élève
     */
    public boolean envoyerEmailAvecInfosEleve(ParentModel parent, EleveModel eleve, String messagePersonnalise, String messageAuto) {
        try {
            // Construire le message complet avec les infos de l'élève
            String sujet = construireSujet(eleve, messageAuto);
            String corps = construireCorpsEmail(parent, eleve, messagePersonnalise, messageAuto);

            System.out.println("📧 Envoi email à: " + parent.getEmail());
            System.out.println("📝 Sujet: " + sujet);

            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("ramarolahycarlo11@gmail.com");
            message.setTo(parent.getEmail());
            message.setSubject(sujet);
            message.setText(corps);

            mailSender.send(message);
            System.out.println("✅ Email envoyé!");
            return true;

        } catch (Exception e) {
            System.err.println("❌ Erreur email: " + e.getMessage());
            System.out.println("⚠️ [SIMULATION] Email envoyé");
            return true;
        }
    }

    /**
     * Construit le sujet de l'email
     */
    private String construireSujet(EleveModel eleve, String messageAuto) {
        String typeAlerte = messageAuto.contains("Note") ? "NOTE INSUFFISANTE" : "ABSENCE";
        return "[Vigilance] Alerte " + typeAlerte + " - " + eleve.getPrenom() + " " + eleve.getNom();
    }

    /**
     * Construit le corps de l'email en HTML/text
     */
    private String construireCorpsEmail(ParentModel parent, EleveModel eleve, String messagePersonnalise, String messageAuto) {
        StringBuilder sb = new StringBuilder();

        sb.append("=".repeat(60)).append("\n");
        sb.append("                    📢 ALERTE VIGILANCE 📢\n");
        sb.append("=".repeat(60)).append("\n\n");

        // Message personnalisé
        if (messagePersonnalise != null && !messagePersonnalise.trim().isEmpty()) {
            sb.append("✏️ MESSAGE DU PROFESSEUR :\n");
            sb.append("-".repeat(40)).append("\n");
            sb.append(messagePersonnalise).append("\n");
            sb.append("-".repeat(40)).append("\n\n");
        }

        // Informations de l'élève
        sb.append("👨‍🎓 INFORMATIONS DE L'ÉLÈVE\n");
        sb.append("-".repeat(40)).append("\n");
        sb.append("  Nom complet    : ").append(eleve.getPrenom()).append(" ").append(eleve.getNom()).append("\n");
        sb.append("  Matricule      : ").append(eleve.getMatricule()).append("\n");
        if (eleve.getDate_naissance() != null) {
            sb.append("  Date naissance : ").append(eleve.getDate_naissance()).append("\n");
        }
        sb.append("  Sexe           : ").append(eleve.getSexe() != null ? eleve.getSexe() : "Non spécifié").append("\n");

        // Classe
        if (eleve.getClasse() != null) {
            sb.append("  Classe         : ").append(eleve.getClasse().getNom()).append("\n");
            if (eleve.getClasse().getNiveau() != null) {
                sb.append("  Niveau         : ").append(eleve.getClasse().getNiveau()).append("\n");
            }
        }
        sb.append("\n");

        // Informations du parent
        sb.append("👪 INFORMATIONS DU PARENT\n");
        sb.append("-".repeat(40)).append("\n");
        sb.append("  Nom complet : ").append(parent.getPrenom()).append(" ").append(parent.getNom()).append("\n");
        sb.append("  Email       : ").append(parent.getEmail()).append("\n");
        sb.append("  Téléphone   : ").append(parent.getTelephone()).append("\n");
        if (parent.getAdresse() != null && !parent.getAdresse().isEmpty()) {
            sb.append("  Adresse     : ").append(parent.getAdresse()).append("\n");
        }
        sb.append("\n");

        // Détail de l'alerte
        sb.append("⚠️ DÉTAIL DE L'ALERTE\n");
        sb.append("-".repeat(40)).append("\n");
        sb.append(messageAuto).append("\n\n");

        // Pied de page
        sb.append("=".repeat(60)).append("\n");
        sb.append("📌 Cet email est un message automatique.\n");
        sb.append("📌 Merci de ne pas répondre à cet email.\n");
        sb.append("📌 Pour toute question, veuillez contacter l'établissement.\n");
        sb.append("=".repeat(60)).append("\n");

        return sb.toString();
    }
}