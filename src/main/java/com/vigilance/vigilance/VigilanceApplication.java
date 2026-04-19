package com.vigilance.vigilance;

import com.twilio.Twilio;
import jakarta.annotation.PostConstruct;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class VigilanceApplication {

    public static void main(String[] args) {
        SpringApplication.run(VigilanceApplication.class, args);
    }

    // Cette méthode s'exécute automatiquement après le démarrage de Spring
    @PostConstruct
    public void initTwilio() {
        // Initialisation avec tes identifiants Twilio
        Twilio.init("ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "5edab10e4feeaf5a2ae8bd915a014761");
        System.out.println("Sms Service (Twilio) initialisé avec succès.");
    }
}
