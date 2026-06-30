package com.vigilance.vigilance.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Désactivé temporairement pour tes tests de développement
                .authorizeHttpRequests(auth -> auth
                        // 1. Accès libre et total aux ressources statiques et à la gestion d'erreur globale
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico", "/error").permitAll()

                        // 2. Accès technique obligatoire pour le moteur de rendu JSP
                        .requestMatchers("/WEB-INF/jsp/**").permitAll()

                        // 3. Routes applicatives publiques
                        .requestMatchers("/", "/login", "/register").permitAll()

                        // 4. Accès d'urgence temporaire pour l'initialisation de l'administrateur
                        .requestMatchers("/utilisateur/add", "/utilisateur/save").permitAll()

                        // 5. Protections granulaires par permissions et rôles métiers
                        .requestMatchers("/eleve/api/**").hasAnyRole("ADMIN", "PROFESSEUR", "SURVEILLANT")
                        .requestMatchers("/eleve/**").hasAnyRole("ADMIN", "PROFESSEUR")
                        .requestMatchers("/utilisateur/**").hasRole("ADMIN")
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/professor/**").hasAnyRole("PROFESSEUR", "ADMIN")

                        // 6. Sécurisation obligatoire de tout le reste des modules (dont /dashboard)
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .defaultSuccessUrl("/dashboard", true)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutSuccessUrl("/login?logout")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        // Conservé uniquement pour ton environnement de test local
        return org.springframework.security.crypto.password.NoOpPasswordEncoder.getInstance();
    }
}