<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="add.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div class="content">
        <div class="form-container">
            <a href="${pageContext.request.contextPath}/utilisateur" class="btn-back">
                <i class="fas fa-arrow-left"></i> Retour au staff
            </a>
            <h2><i class="fas fa-user-edit"></i> Modifier le Compte Staff</h2>

            <form action="${pageContext.request.contextPath}/utilisateur/update" method="post">
                <input type="hidden" name="id_utilisateur" value="${utilisateur.id_utilisateur}">

                <div class="form-group">
                    <label><i class="fas fa-user-tag"></i> Nom d'utilisateur (Username) *</label>
                    <input type="text" name="username" value="${utilisateur.username}" class="form-control" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-key"></i> Nouveau mot de passe *</label>
                    <input type="password" name="password" value="${utilisateur.password}" class="form-control" required placeholder="••••••••">
                </div>

                <div class="form-group">
                    <label><i class="fas fa-user-shield"></i> Rôle applicatif *</label>
                    <select name="role" class="form-control" required>
                        <option value="ADMIN" <c:if test="${utilisateur.role == 'ADMIN'}">selected</c:if>>Administrateur</option>
                        <option value="SURVEILLANT" <c:if test="${utilisateur.role == 'SURVEILLANT'}">selected</c:if>>Surveillant / Responsable d'Assiduité</option>
                        <option value="PROFESSEUR" <c:if test="${utilisateur.role == 'PROFESSEUR'}">selected</c:if>>Professeur / Évaluateur</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit" style="background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); box-shadow: 0 4px 15px rgba(52, 152, 219, 0.2);">
                    <i class="fas fa-sync-alt"></i> Mettre à jour le compte
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>