<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Initialisation - Vigilance Scolaire</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #1a1a1a; color: white; font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .register-container { background: #2c3e50; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.5); width: 350px; text-align: center; }
        h2 { margin-bottom: 20px; color: #3498db; }
        input, select { width: 100%; padding: 12px; margin: 10px 0; border-radius: 5px; border: none; background: #34495e; color: white; box-sizing: border-box; }
        .btn-submit { width: 100%; padding: 12px; border: none; border-radius: 5px; background: #27ae60; color: white; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-submit:hover { background: #219150; }
        .info-text { font-size: 0.85em; color: #bdc3c7; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Initialisation</h2>
        <p class="info-text">Aucun utilisateur détecté. Créez le premier compte Administrateur pour configurer le système.</p>

        <form action="${pageContext.request.contextPath}/utilisateur/save" method="post">
            <input type="text" name="username" placeholder="Nom d'utilisateur (ex: admin)" required>
            <input type="password" name="password" placeholder="Mot de passe" required>

            <%-- Le rôle est forcé en ADMIN pour le premier utilisateur --%>
            <input type="hidden" name="role" value="ADMIN">

            <button type="submit" class="btn-submit">Créer le compte Admin</button>
        </form>
    </div>
</body>
</html>