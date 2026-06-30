<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<style>
    <%@ include file="add.css" %>
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/classe" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour aux classes
    </a>
    <h2><i class="fas fa-plus-circle"></i> Ajouter une Classe</h2>

    <form id="classeForm" action="${pageContext.request.contextPath}/classe/save" method="post">

        <div class="form-group">
            <label><i class="fas fa-graduation-cap"></i> Nom de la classe</label>
            <input type="text" name="nom" id="nom" class="form-control" required
                   placeholder="Ex: 6ème A, CM2, Terminale A..."
                   title="Lettres, chiffres, espaces, tiret et apostrophe uniquement">
            <div class="error-message" id="nomError">
                <i class="fas fa-exclamation-circle"></i> Caractères non autorisés. Utilisez : lettres, chiffres, espaces, tiret (-) et apostrophe (')
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-layer-group"></i> Niveau</label>
            <select name="niveau" id="niveau" class="form-control" required>
                <option value="">-- Sélectionner un niveau --</option>
            </select>
        </div>

        <div class="form-group">
            <label><i class="fas fa-calendar-alt"></i> Année Scolaire</label>
            <input type="text" name="annee_scolaire" id="annee_scolaire" class="form-control" required
                   placeholder="Ex: 2024-2025"
                   maxlength="9"
                   title="Format: 2024-2025 (4 chiffres - 4 chiffres)">
            <div class="error-message" id="anneeError">
                <i class="fas fa-exclamation-circle"></i> Format invalide. Utilisez le format: 2024-2025 (ex: 2024-2025)
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-user-tie"></i> Professeur Principal</label>
            <select name="utilisateur.id_utilisateur" id="professeur" class="form-control">
                <option value="">-- Aucun professeur assigné --</option>
                <c:forEach var="prof" items="${professeurs}">
                    <option value="${prof.id_utilisateur}">
                        [${prof.id_utilisateur}] - ${prof.username} (${prof.role})
                    </option>
                </c:forEach>
            </select>
            <small style="color: #7f8c8d;">Vous pouvez rechercher par ID ou nom d'utilisateur</small>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-save"></i> Créer la classe
        </button>
    </form>
</div>

<script src="${pageContext.request.contextPath}/js/classe/add.js"></script>

<jsp:include page="../includes/footer.jsp" />