<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent/edit.css">

<div class="form-container">
    <a href="${pageContext.request.contextPath}/parent" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour a la liste
    </a>
    <h2><i class="fas fa-user-edit"></i> Modifier le Parent</h2>

    <form id="parentForm" action="${pageContext.request.contextPath}/parent/save" method="post">
        <input type="hidden" name="id_parent" value="${parent.id_parent}">

        <div class="form-group">
            <label><i class="fas fa-user"></i> Nom *</label>
            <input type="text" name="nom" id="nom" class="form-control" required
                   value="${parent.nom}">
            <div class="error-message" id="nomError">
                <i class="fas fa-exclamation-circle"></i> Le nom ne doit contenir que des lettres
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-user"></i> Prenom *</label>
            <input type="text" name="prenom" id="prenom" class="form-control" required
                   value="${parent.prenom}">
            <div class="error-message" id="prenomError">
                <i class="fas fa-exclamation-circle"></i> Le prenom ne doit contenir que des lettres
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-phone-alt"></i> Telephone *</label>
            <input type="tel" name="telephone" id="telephone" class="form-control" required
                   value="${parent.telephone}">
            <div class="error-message" id="telephoneError">
                <i class="fas fa-exclamation-circle"></i> Le telephone doit contenir uniquement des chiffres et le signe +
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-envelope"></i> Email *</label>
            <input type="email" name="email" id="email" class="form-control" required
                   value="${parent.email}">
            <div class="error-message" id="emailError">
                <i class="fas fa-exclamation-circle"></i> Veuillez entrer un email valide
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-map-marker-alt"></i> Adresse *</label>
            <input type="text" name="adresse" id="adresse" class="form-control" required
                   value="${parent.adresse}">
            <div class="error-message" id="adresseError">
                <i class="fas fa-exclamation-circle"></i> L'adresse est obligatoire
            </div>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-sync-alt"></i> Mettre a jour
        </button>
    </form>
</div>

<script src="${pageContext.request.contextPath}/js/parent/edit.js"></script>

<jsp:include page="../includes/footer.jsp" />