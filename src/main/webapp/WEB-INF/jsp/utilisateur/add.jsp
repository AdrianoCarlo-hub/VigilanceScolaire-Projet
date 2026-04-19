<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/utilisateur" class="btn-back">← Retour au staff</a>
    <h2>Créer un Compte Staff</h2>

    <form action="${pageContext.request.contextPath}/utilisateur/save" method="post">
        <div class="form-group">
            <label>Nom d'utilisateur (Username)</label>
            <input type="text" name="username" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Mot de passe</label>
            <input type="password" name="password" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Rôle</label>
            <select name="role" class="form-control">
                <option value="ADMIN">Administrateur</option>
                <option value="SURVEILLANT">Surveillant</option>
                <option value="PROFESSEUR">Professeur</option>
            </select>
        </div>

        <button type="submit" class="btn-submit">Créer le compte</button>
    </form>
</div>

</body>
</html>