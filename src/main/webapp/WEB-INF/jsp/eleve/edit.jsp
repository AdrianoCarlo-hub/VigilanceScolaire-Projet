<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="edit.css" %>
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/eleve" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour à la liste
    </a>
    <h2><i class="fas fa-user-edit"></i> Modifier l'Élève</h2>

    <form id="eleveForm" action="${pageContext.request.contextPath}/eleve/save" method="post" enctype="multipart/form-data">

        <input type="hidden" name="id_eleve" value="${eleve.id_eleve}">

        <div class="current-photo-box">
            <c:choose>
                <c:when test="${not empty eleve.photo}">
                    <img id="currentPhoto" src="${pageContext.request.contextPath}/images/${eleve.photo}"
                         class="current-photo-img"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-avatar.png'">
                </c:when>
                <c:otherwise>
                    <img id="currentPhoto" src="${pageContext.request.contextPath}/images/default-avatar.png" class="current-photo-img">
                </c:otherwise>
            </c:choose>
            <p><i class="fas fa-camera"></i> Photo de profil</p>
        </div>

        <div class="form-row">
            <div class="form-group" style="width: 100%;">
                <label><i class="fas fa-venus-mars"></i> Sexe *</label>
                <select name="sexe" class="form-control" required>
                    <option value="M" ${eleve.sexe == 'M' ? 'selected' : ''}>Masculin</option>
                    <option value="F" ${eleve.sexe == 'F' ? 'selected' : ''}>Féminin</option>
                </select>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label><i class="fas fa-user"></i> Nom *</label>
                <input type="text" name="nom" value="${eleve.nom}" class="form-control" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-user"></i> Prénom *</label>
                <input type="text" name="prenom" value="${eleve.prenom}" class="form-control" required>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label><i class="fas fa-calendar-alt"></i> Date de Naissance *</label>
                <input type="date" name="date_naissance" value="${eleve.date_naissance}" class="form-control" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-graduation-cap"></i> Classe *</label>
                <select name="classe.id_classe" class="form-control" required>
                    <c:forEach var="cl" items="${classes}">
                        <option value="${cl.id_classe}" ${cl.id_classe == eleve.classe.id_classe ? 'selected' : ''}>
                                ${cl.nom} - ${cl.niveau}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-user-friends"></i> Parent / Tuteur *</label>
            <select name="parent.id_parent" class="form-control" required>
                <c:forEach var="p" items="${parents}">
                    <option value="${p.id_parent}" ${p.id_parent == eleve.parent.id_parent ? 'selected' : ''}>
                            ${p.nom.toUpperCase()} ${p.prenom} (${p.telephone})
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label><i class="fas fa-images"></i> Changer la photo (optionnel)</label>
            <div class="photo-upload-area" onclick="document.getElementById('photoInput').click()">
                <p style="margin: 10px 0; color: #bdc3c7; font-size: 14px; font-weight: bold;">
                    <i class="fas fa-cloud-upload-alt"></i> Cliquez ici pour parcourir et sélectionner une image
                </p>
                <input type="file" id="photoInput" name="file" class="form-control" accept="image/*"
                       style="display: none;" onchange="previewImage(this)">
            </div>
            <p class="info-text">Formats acceptés: JPG, PNG, GIF (max 5MB)</p>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-save"></i> Enregistrer les modifications
        </button>
    </form>
</div>

<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];

            if (file.size > 5 * 1024 * 1024) {
                alert('❌ La photo est trop volumineuse. Maximum 5MB.');
                input.value = '';
                return;
            }

            if (!file.type.match('image.*')) {
                alert('❌ Veuillez sélectionner une image valide (JPG, PNG, GIF)');
                input.value = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function(e) {
                const currentPhoto = document.getElementById('currentPhoto');
                currentPhoto.src = e.target.result;
                currentPhoto.style.border = "4px solid #2ecc71";

                const infoText = document.querySelector('.info-text');
                if (infoText) {
                    infoText.style.color = '#2ecc71';
                    infoText.innerHTML = '<i class="fas fa-check-circle"></i> Nouvelle photo chargée et prête à être enregistrée !';
                }
            }
            reader.readAsDataURL(file);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const currentPhoto = document.getElementById('currentPhoto');
        if (currentPhoto && currentPhoto.src && !currentPhoto.src.includes('default-avatar.png')) {
            const src = currentPhoto.src.split('?')[0];
            currentPhoto.src = src + '?t=' + new Date().getTime();
        }
    });
</script>
</body>
</html>