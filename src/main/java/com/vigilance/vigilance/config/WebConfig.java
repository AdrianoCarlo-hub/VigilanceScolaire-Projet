package com.vigilance.vigilance.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Redirige les requêtes /images/** vers src/main/resources/static/images/
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");

        // Faites de même pour le CSS et le JS si ce n'est pas déjà fait
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/images/");
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");
    }
}