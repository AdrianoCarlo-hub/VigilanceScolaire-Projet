<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        <%@ include file="add.css" %>
    </style>
<div class="form-container">
    <a href="${pageContext.request.contextPath}/parent" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour aux parents
    </a>
    <h2><i class="fas fa-user-plus"></i> Ajouter un Parent</h2>

    <form id="parentForm" action="${pageContext.request.contextPath}/parent/save" method="post">

        <div class="form-group">
            <label><i class="fas fa-user"></i> Nom *</label>
            <input type="text" name="nom" id="nom" class="form-control" required
                   placeholder="Ex: RAKOTO">
            <div class="error-message" id="nomError">
                <i class="fas fa-exclamation-circle"></i> Le nom ne doit contenir que des lettres
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-user"></i> Prenom *</label>
            <input type="text" name="prenom" id="prenom" class="form-control" required
                   placeholder="Ex: Sylvain">
            <div class="error-message" id="prenomError">
                <i class="fas fa-exclamation-circle"></i> Le prenom ne doit contenir que des lettres
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-phone-alt"></i> Telephone *</label>
            <input type="tel" name="telephone" id="telephone" class="form-control" required
                   placeholder="Ex: +261340000000 ou 0340000000">
            <div class="error-message" id="telephoneError">
                <i class="fas fa-exclamation-circle"></i> Le telephone doit contenir uniquement des chiffres et le signe +
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-envelope"></i> Email *</label>
            <input type="email" name="email" id="email" class="form-control" required
                   placeholder="parent@example.com">
            <div class="error-message" id="emailError">
                <i class="fas fa-exclamation-circle"></i> Veuillez entrer un email valide
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-map-marker-alt"></i> Adresse *</label>
            <input type="text" name="adresse" id="adresse" class="form-control" required
                   placeholder="Ex: Lot IVG 25 Antananarivo">
            <div class="error-message" id="adresseError">
                <i class="fas fa-exclamation-circle"></i> L'adresse est obligatoire
            </div>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-save"></i> Ajouter le parent
        </button>
    </form>
</div>
<script>
    const contextPath = "${contextPath}";
</script>
<script src="${contextPath}/js/parent/add.js"></script>

<jsp:include page="../includes/footer.jsp" />