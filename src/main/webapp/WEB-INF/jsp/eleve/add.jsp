<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header_form.jsp" />

<style>
    .photo-preview {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #3498db;
        margin: 10px auto;
        display: block;
        cursor: pointer;
    }

    .photo-upload-area {
        border: 2px dashed #3498db;
        border-radius: 10px;
        padding: 20px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
    }

    .photo-upload-area:hover {
        background: rgba(52, 152, 219, 0.1);
        border-color: #ffd700;
    }

    .form-row {
        display: flex;
        gap: 20px;
        margin-bottom: 20px;
    }

    .form-group {
        flex: 1;
        margin-bottom: 20px;
    }

    label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #ecf0f1;
    }

    .form-control {
        width: 100%;
        padding: 10px;
        border: 1px solid #34495e;
        border-radius: 5px;
        background: #34495e;
        color: white;
    }

    .form-control:focus {
        outline: none;
        border-color: #ffd700;
    }

    .btn-submit {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        font-size: 16px;
        transition: transform 0.3s;
    }

    .btn-submit:hover {
        transform: translateY(-2px);
    }

    .btn-back {
        display: inline-block;
        margin-bottom: 20px;
        color: #ffd700;
        text-decoration: none;
    }

    .info-note {
        background: #1a252f;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 20px;
        color: #ffd700;
        font-size: 14px;
    }
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/eleve" class="btn-back">← Retour au répertoire</a>
    <h2>➕ Inscrire un nouvel Élève</h2>

    <sec:authorize access="hasRole('PROFESSEUR')">
        <div class="info-note">
            ℹ️ En tant que Professeur, vous ne pouvez inscrire des élèves que dans vos propres classes.
        </div>
    </sec:authorize>

    <form id="eleveForm" action="${pageContext.request.contextPath}/eleve/save" method="post" enctype="multipart/form-data">
        <div class="form-row">
            <div class="form-group">
                <label>Matricule *</label>
                <input type="text" name="matricule" class="form-control" required placeholder="Ex: 2024001">
            </div>
            <div class="form-group">
                <label>Sexe *</label>
                <select name="sexe" class="form-control" required>
                    <option value="">Sélectionner</option>
                    <option value="M">👨 Masculin</option>
                    <option value="F">👩 Féminin</option>
                </select>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Nom *</label>
                <input type="text" name="nom" class="form-control" required placeholder="Nom de l'élève">
            </div>
            <div class="form-group">
                <label>Prénom *</label>
                <input type="text" name="prenom" class="form-control" required placeholder="Prénom de l'élève">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Date de Naissance *</label>
                <input type="date" name="date_naissance" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Classe *</label>
                <select name="classe.id_classe" class="form-control" required>
                    <option value="">Sélectionner une classe</option>
                    <c:forEach var="cl" items="${classes}">
                        <option value="${cl.id_classe}">${cl.nom} - ${cl.niveau}</option>
                    </c:forEach>
                </select>
                <sec:authorize access="hasRole('PROFESSEUR')">
                    <small style="color: #aaa;">⚠️ Vous ne voyez que vos propres classes</small>
                </sec:authorize>
            </div>
        </div>

        <div class="form-group">
            <label>Parent / Tuteur *</label>
            <select name="parent.id_parent" class="form-control" required>
                <option value="">Sélectionner un parent</option>
                <c:forEach var="p" items="${parents}">
                    <option value="${p.id_parent}">${p.nom} ${p.prenom} (${p.telephone})</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>📷 Photo de l'élève</label>
            <div class="photo-upload-area" onclick="document.getElementById('photoInput').click()">
                <img id="photoPreview" src="${pageContext.request.contextPath}/images/default-avatar.png"
                     class="photo-preview" alt="Aperçu photo">
                <p style="margin-top: 10px; color: #bdc3c7;">Cliquez pour choisir une photo</p>
                <input type="file" id="photoInput" name="file" class="form-control" accept="image/*"
                       style="display: none;" onchange="previewImage(this)">
            </div>
        </div>

        <button type="submit" class="btn-submit">✅ Inscrire l'élève</button>
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