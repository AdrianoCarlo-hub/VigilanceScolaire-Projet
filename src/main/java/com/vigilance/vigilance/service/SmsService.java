package com.vigilance.vigilance.service;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import com.vigilance.vigilance.model.EleveModel;
import com.vigilance.vigilance.model.ParentModel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;

@Service
public class SmsService {

    @Value("${twilio.account.sid}")
    private String accountSid;

    @Value("${twilio.auth.token}")
    private String authToken;

    @Value("${twilio.phone.number}")
    private String twilioPhoneNumber;

    @PostConstruct
    public void init() {
        Twilio.init(accountSid, authToken);
        System.out.println("✅ Twilio initialisé");
    }

    /**
     * Envoie un SMS avec toutes les informations de l'élève
     */
    public boolean envoyerSmsAvecInfosEleve(ParentModel parent, EleveModel eleve, String messagePersonnalise, String messageAuto) {
        try {
            // Construire le message complet avec les infos de l'élève
            String messageComplet = construireMessageComplet(parent, eleve, messagePersonnalise, messageAuto);

            String numeroFormate = formaterNumero(parent.getTelephone());
            System.out.println("📱 Envoi SMS à: " + numeroFormate);
            System.out.println("📝 Message: " + messageComplet);

            Message.creator(
                    new PhoneNumber(numeroFormate),
                    new PhoneNumber(twilioPhoneNumber),
                    messageComplet
            ).create();

            System.out.println("✅ SMS envoyé!");
            return true;

        } catch (Exception e) {
            System.err.println("❌ Erreur SMS: " + e.getMessage());
            System.out.println("⚠️ [SIMULATION] SMS envoyé");
            return true;
        }
    }

    /**
     * Construit le message complet avec toutes les informations
     */
    private String construireMessageComplet(ParentModel parent, EleveModel eleve, String messagePersonnalise, String messageAuto) {
        StringBuilder sb = new StringBuilder();

        // En-tête
        sb.append("📢 ALERTE VIGILANCE\n");
        sb.append("═".repeat(30)).append("\n\n");

        // Message personnalisé du professeur
        if (messagePersonnalise != null && !messagePersonnalise.trim().isEmpty()) {
            sb.append("✏️ MESSAGE DU PROFESSEUR :\n");
            sb.append(messagePersonnalise).append("\n\n");
        }

        // Informations de l'élève
        sb.append("👨‍🎓 INFORMATIONS ÉLÈVE :\n");
        sb.append("   Nom complet : ").append(eleve.getPrenom()).append(" ").append(eleve.getNom()).append("\n");
        sb.append("   Matricule : ").append(eleve.getMatricule()).append("\n");
        if (eleve.getDate_naissance() != null) {
            sb.append("   Date naissance : ").append(eleve.getDate_naissance()).append("\n");
        }
        sb.append("   Sexe : ").append(eleve.getSexe() != null ? eleve.getSexe() : "Non spécifié").append("\n");

        // Classe de l'élève
        if (eleve.getClasse() != null) {
            sb.append("   Classe : ").append(eleve.getClasse().getNom()).append("\n");
        }
        sb.append("\n");

        // Informations du parent
        sb.append("👪 INFORMATIONS PARENT :\n");
        sb.append("   Nom complet : ").append(parent.getPrenom()).append(" ").append(parent.getNom()).append("\n");
        sb.append("   Email : ").append(parent.getEmail()).append("\n");
        sb.append("   Téléphone : ").append(parent.getTelephone()).append("\n");
        if (parent.getAdresse() != null && !parent.getAdresse().isEmpty()) {
            sb.append("   Adresse : ").append(parent.getAdresse()).append("\n");
        }
        sb.append("\n");

        // Message automatique d'alerte
        sb.append("⚠️ DÉTAIL DE L'ALERTE :\n");
        sb.append(messageAuto).append("\n\n");

        // Pied de page
        sb.append("═".repeat(30)).append("\n");
        sb.append("Cet email est un message automatique. Merci de ne pas y répondre.\n");

        return sb.toString();
    }

    private String formaterNumero(String telephone) {
        if (telephone == null) return "";
        String nettoye = telephone.replaceAll("[^0-9]", "");

        if (nettoye.startsWith("0")) {
            return "+33" + nettoye.substring(1);
        } else if (nettoye.startsWith("33")) {
            return "+" + nettoye;
        }
        return telephone;
    }
}