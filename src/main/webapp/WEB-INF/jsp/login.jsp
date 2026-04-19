<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - Vigilance Scolaire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; display: flex; align-items: center; height: 100vh; }
        .login-form { width: 100%; max-width: 400px; margin: auto; padding: 15px; background: white; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<div class="login-form">
    <h2 class="text-center mb-4">Vigilance Scolaire</h2>

    <c:if test="${param.error != null}">
        <div class="alert alert-danger">Nom d'utilisateur ou mot de passe incorrect.</div>
    </c:if>

    <c:if test="${param.logout != null}">
        <div class="alert alert-success">Vous avez été déconnecté.</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="mb-3">
            <label for="username" class="form-label">Nom d'utilisateur</label>
            <input type="text" name="username" id="username" class="form-control" required autofocus>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
            <input type="password" name="password" id="password" class="form-control" required>
        </div>

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <button type="submit" class="btn btn-primary w-100">Se connecter</button>
    </form>
</div>

</body>
</html>