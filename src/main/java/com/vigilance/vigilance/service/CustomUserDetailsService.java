package com.vigilance.vigilance.service;

import com.vigilance.vigilance.model.UtilisateurModel;
import com.vigilance.vigilance.repository.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // CORRECTION ICI : On utilise .orElseThrow() pour gérer l'Optional proprement
        UtilisateurModel user = utilisateurRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Utilisateur non trouvé : " + username));

        // Spring Security attend un rôle avec le préfixe "ROLE_" (ex: ROLE_ADMIN)
        // .roles() ajoute automatiquement "ROLE_" devant la chaîne fournie.
        return User.withUsername(user.getUsername())
                .password(user.getPassword())
                .roles(user.getRole())
                .build();
    }
}