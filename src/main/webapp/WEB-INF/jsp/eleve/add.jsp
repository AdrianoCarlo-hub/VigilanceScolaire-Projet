<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="add.css" %>
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/eleve" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour au répertoire
    </a>
    <h2><i class="fas fa-user-plus"></i> Inscrire un nouvel Élève</h2>

    <sec:authorize access="hasRole('PROFESSEUR')">
        <div class="info-note">
            <i class="fas fa-info-circle"></i> En tant que Professeur, vous ne pouvez inscrire des élèves que dans vos propres classes.
        </div>
    </sec:authorize>

    <form id="eleveForm" action="${pageContext.request.contextPath}/eleve/save" method="post" enctype="multipart/form-data">

        <div class="form-row">
            <div class="form-group" style="width: 100%;">
                <label><i class="fas fa-venus-mars"></i> Sexe *</label>
                <select name="sexe" class="form-control" required>
                    <option value="">Sélectionner</option>
                    <option value="M">Masculin</option>
                    <option value="F">Féminin</option>
                </select>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label><i class="fas fa-user"></i> Nom *</label>
                <input type="text" name="nom" class="form-control" required placeholder="Nom de l'élève">
            </div>
            <div class="form-group">
                <label><i class="fas fa-user"></i> Prénom *</label>
                <input type="text" name="prenom" class="form-control" required placeholder="Prénom de l'élève">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label><i class="fas fa-calendar-alt"></i> Date de Naissance *</label>
                <input type="date" name="date_naissance" class="form-control" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-graduation-cap"></i> Classe *</label>
                <select name="classe.id_classe" class="form-control" required>
                    <option value="">Sélectionner une classe</option>
                    <c:forEach var="cl" items="${classes}">
                        <option value="${cl.id_classe}">${cl.nom} - ${cl.niveau}</option>
                    </c:forEach>
                </select>
                <sec:authorize access="hasRole('PROFESSEUR')">
                    <small style="color: #bdc3c7; display: block; margin-top: 5px;">
                        <i class="fas fa-exclamation-triangle" style="color: #f1c40f;"></i> Vous ne voyez que vos propres classes
                    </small>
                </sec:authorize>
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-user-friends"></i> Parent / Tuteur *</label>
            <select name="parent.id_parent" class="form-control" required>
                <option value="">Sélectionner un parent</option>
                <c:forEach var="p" items="${parents}">
                    <option value="${p.id_parent}">${p.nom.toUpperCase()} ${p.prenom} (${p.telephone})</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label><i class="fas fa-camera"></i> Photo de l'élève</label>
            <div class="photo-upload-area" onclick="document.getElementById('photoInput').click()">
                <img id="photoPreview" src="${pageContext.request.contextPath}/images/default-avatar.png"
                     class="photo-preview" alt="Aperçu photo">
                <p style="margin: 10px 0 0 0; color: #bdc3c7; font-size: 14px; font-weight: bold;">
                    <i class="fas fa-cloud-upload-alt"></i> Cliquez pour choisir ou changer la photo
                </p>
                <input type="file" id="photoInput" name="file" class="form-control" accept="image/*"
                       style="display: none;" onchange="previewImage(this)">
            </div>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-check-circle"></i> Confirmer l'inscription
        </button>
    </form>
</div>

<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('photoPreview').src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html>