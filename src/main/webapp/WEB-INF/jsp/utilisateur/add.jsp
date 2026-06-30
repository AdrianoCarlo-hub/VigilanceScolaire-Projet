<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="add.css" %>
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/utilisateur" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour au staff
    </a>
    <h2><i class="fas fa-user-plus"></i> Créer un Compte Staff</h2>

    <form action="${pageContext.request.contextPath}/utilisateur/save" method="post">

        <div class="form-group">
            <label><i class="fas fa-user-tag"></i> Nom d'utilisateur (Username) *</label>
            <input type="text" name="username" class="form-control" required placeholder="Ex: r.sylvain">
        </div>

        <div class="form-group">
            <label><i class="fas fa-key"></i> Mot de passe *</label>
            <input type="password" name="password" class="form-control" required placeholder="••••••••">
        </div>

        <div class="form-group">
            <label><i class="fas fa-user-shield"></i> Rôle applicatif *</label>
            <select name="role" class="form-control" required>
                <option value="ADMIN">Administrateur</option>
                <option value="SURVEILLANT">Surveillant / Responsable d'Assiduité</option>
                <option value="PROFESSEUR">Professeur / Évaluateur</option>
            </select>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-user-check"></i> Créer le compte
        </button>
    </form>
</div>

</div> </body>
</html>