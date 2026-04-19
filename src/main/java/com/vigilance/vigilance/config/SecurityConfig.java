package com.vigilance.vigilance.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // NOUVEAU : Cette méthode dit à Spring Security d'ignorer complètement ces dossiers.
    // C'est radical pour stopper les boucles de redirection sur les images/css.
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico");
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        // 1. Accès technique JSP et Error
                        .requestMatchers("/WEB-INF/jsp/**", "/error").permitAll()

                        // 2. Routes publiques
                        .requestMatchers("/", "/login", "/register").permitAll()

                        // 3. Accès temporaire pour création Admin
                        .requestMatchers("/utilisateur/add", "/utilisateur/save").permitAll()

                        // 4. Protections par Rôles
                        .requestMatchers("/eleve/**").hasAnyRole("ADMIN", "PROFESSEUR")
                        .requestMatchers("/utilisateur/**").hasRole("ADMIN")
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/professor/**").hasAnyRole("PROFESSEUR", "ADMIN")

                        // 5. Tout le reste (dont /dashboard) nécessite d'être logué
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
        // Note : NoOpPasswordEncoder est déprécié mais conservé selon ta demande
        // pour tes tests en local.
        return org.springframework.security.crypto.password.NoOpPasswordEncoder.getInstance();
    }
}