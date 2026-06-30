<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="sidebar.css" %>
</style>

<div class="sidebar">
    <h3><i class="fas fa-shield-alt"></i> Vigilance</h3>

    <div class="user-profile">
        <div class="username">
            <sec:authentication property="principal.username" />
        </div>
        <div class="role-tag">
            <i class="fas fa-user-shield"></i>
            <sec:authorize access="hasRole('ADMIN')">Administrateur</sec:authorize>
            <sec:authorize access="hasRole('SURVEILLANT') and not hasRole('ADMIN')">Surveillant</sec:authorize>
            <sec:authorize access="hasRole('PROFESSEUR') and not hasRole('ADMIN') and not hasRole('SURVEILLANT')">Professeur</sec:authorize>
        </div>
    </div>

    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-chart-pie"></i> Dashboard
            </a>
        </li>

        <li class="separator"></li>

        <li>
            <a href="${pageContext.request.contextPath}/eleve">
                <i class="fas fa-graduation-cap"></i> Élèves
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/classe">
                <i class="fas fa-school"></i> Classes
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/parent">
                <i class="fas fa-user-friends"></i> Parents
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/absence">
                <i class="fas fa-user-clock"></i> Absences
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/communication">
                <i class="fas fa-paper-plane"></i> Alertes SMS
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/note">
                <i class="fas fa-pen-alt"></i> Notes & Évals
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/historique/alertes">
                <i class="fas fa-history"></i> Historique Alertes
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/bulletin">
                <i class="fas fa-file-invoice"></i> Bulletins
            </a>
        </li>

        <sec:authorize access="hasRole('ADMIN')">
            <li class="separator"></li>
            <li>
                <a href="${pageContext.request.contextPath}/utilisateur">
                    <i class="fas fa-users-cog"></i> Utilisateurs
                </a>
            </li>
        </sec:authorize>

        <li class="logout-section">
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn-logout">
                    <i class="fas fa-power-off"></i> Déconnexion
                </button>
            </form>
        </li>
    </ul>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const links = document.querySelectorAll('.sidebar-menu li a');

        links.forEach(link => {
            const href = link.getAttribute('href');
            // Gestion du marquage d'activation précis ou par correspondance de sous-routage
            if (href && (currentPath === href || (href !== '${pageContext.request.contextPath}/' && currentPath.startsWith(href)))) {
                link.classList.add('active');
            }
        });
    });
</script>