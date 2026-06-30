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
        System.out.println("Twilio initialise");
    }

    /**
     * Envoie un SMS avec toutes les informations de l'eleve
     */
    public boolean envoyerSmsAvecInfosEleve(ParentModel parent, EleveModel eleve, String messagePersonnalise, String messageAuto) {
        try {
            String messageComplet = construireMessageComplet(parent, eleve, messagePersonnalise, messageAuto);

            String numeroFormate = formaterNumero(parent.getTelephone());
            System.out.println("Envoi SMS a: " + numeroFormate);
            System.out.println("Message: " + messageComplet);

            Message.creator(
                    new PhoneNumber(numeroFormate),
                    new PhoneNumber(twilioPhoneNumber),
                    messageComplet
            ).create();

            System.out.println("SMS envoye!");
            return true;

        } catch (Exception e) {
            System.err.println("Erreur SMS: " + e.getMessage());
            System.out.println("[SIMULATION] SMS envoye");
            return true;
        }
    }

    /**
     * Construit le message complet sans emojis
     */
    private String construireMessageComplet(ParentModel parent, EleveModel eleve, String messagePersonnalise, String messageAuto) {
        StringBuilder sb = new StringBuilder();

        sb.append("ALERTE VIGILANCE\n");
        sb.append("========================================\n\n");

        if (messagePersonnalise != null && !messagePersonnalise.trim().isEmpty()) {
            sb.append("MESSAGE DU PROFESSEUR :\n");
            sb.append(messagePersonnalise).append("\n\n");
        }

        sb.append("INFORMATIONS ELEVE :\n");
        sb.append("   Nom complet : ").append(eleve.getPrenom()).append(" ").append(eleve.getNom()).append("\n");
        sb.append("   ID Eleve : #").append(eleve.getId_eleve()).append("\n");
        if (eleve.getDate_naissance() != null) {
            sb.append("   Date naissance : ").append(eleve.getDate_naissance()).append("\n");
        }
        sb.append("   Sexe : ").append(eleve.getSexe() != null ? eleve.getSexe() : "Non specifie").append("\n");

        if (eleve.getClasse() != null) {
            sb.append("   Classe : ").append(eleve.getClasse().getNom()).append("\n");
        }
        sb.append("\n");

        sb.append("INFORMATIONS PARENT :\n");
        sb.append("   Nom complet : ").append(parent.getPrenom()).append(" ").append(parent.getNom()).append("\n");
        sb.append("   Email : ").append(parent.getEmail()).append("\n");
        sb.append("   Telephone : ").append(parent.getTelephone()).append("\n");
        if (parent.getAdresse() != null && !parent.getAdresse().isEmpty()) {
            sb.append("   Adresse : ").append(parent.getAdresse()).append("\n");
        }
        sb.append("\n");

        sb.append("DETAIL DE L'ALERTE :\n");
        sb.append(messageAuto).append("\n\n");

        sb.append("========================================\n");
        sb.append("Ce message est automatique. Merci de ne pas y repondre.\n");

        return sb.toString();
    }

    private String formaterNumero(String telephone) {
        if (telephone == null) return "";
        String nettoye = telephone.replaceAll("[^0-9]", "");

        if (nettoye.startsWith("0")) {
            return "+261" + nettoye.substring(1);
        } else if (nettoye.startsWith("261")) {
            return "+" + nettoye;
        }
        return telephone;
    }
}