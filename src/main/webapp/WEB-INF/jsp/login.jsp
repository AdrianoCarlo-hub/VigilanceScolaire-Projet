<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Vigilance Scolaire</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        <%@ include file="login.css" %>
    </style>
</head>
<body>

<div class="login-container">

    <div class="login-header">
        <div class="logo-icon">
            <i class="fas fa-shield-alt"></i>
        </div>
        <h2>Vigilance Scolaire</h2>
        <p>Système de suivi d'assiduité et de notation</p>
    </div>

    <c:if test="${param.error != null}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> Identifiants invalides ou incorrects.
        </div>
    </c:if>

    <c:if test="${param.logout != null}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> Session clôturée avec succès.
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">

        <div class="form-group">
            <label for="username"><i class="fas fa-user-shield"></i> Nom d'utilisateur</label>
            <input type="text" name="username" id="username" class="form-control" placeholder="Entrez votre identifiant" required autofocus>
        </div>

        <div class="form-group">
            <label for="password"><i class="fas fa-lock"></i> Mot de passe</label>
            <input type="password" name="password" id="password" class="form-control" placeholder="••••••••" required>
        </div>

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <button type="submit" class="btn-login">
            <i class="fas fa-sign-in-alt"></i> Se connecter
        </button>
    </form>
</div>

</body>
</html>