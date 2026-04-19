<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header_form.jsp" />

<style>
    .photo-preview {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #ffd700;
        margin: 10px auto;
        display: block;
        cursor: pointer;
        background: #34495e;
    }

    .photo-upload-area {
        border: 2px dashed #ffd700;
        border-radius: 10px;
        padding: 20px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
    }

    .photo-upload-area:hover {
        background: rgba(255, 215, 0, 0.1);
    }

    .current-photo {
        text-align: center;
        margin-bottom: 20px;
        padding: 15px;
        background: rgba(255,255,255,0.05);
        border-radius: 10px;
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
        background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
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

    .info-text {
        font-size: 12px;
        color: #bdc3c7;
        text-align: center;
        margin-top: 10px;
    }
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/eleve" class="btn-back">← Retour à la liste</a>
    <h2>✏️ Modifier l'Élève</h2>

    <form id="eleveForm" action="${pageContext.request.contextPath}/eleve/save" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id_eleve" value="${eleve.id_eleve}">

        <div class="current-photo">
            <c:choose>
                <c:when test="${not empty eleve.photo}">
                    <img id="currentPhoto" src="${pageContext.request.contextPath}/images/${eleve.photo}?t=${System.currentTimeMillis()}"
                         style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #ffd700;"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-avatar.png'">
                </c:when>
                <c:otherwise>
                    <img id="currentPhoto" src="${pageContext.request.contextPath}/images/default-avatar.png"
                         style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #ffd700;">
                </c:otherwise>
            </c:choose>
            <p style="color: #bdc3c7; margin-top: 10px;">📸 Photo actuelle</p>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Matricule *</label>
                <input type="text" name="matricule" value="${eleve.matricule}" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Sexe *</label>
                <select name="sexe" class="form-control" required>
                    <option value="M" ${eleve.sexe == 'M' ? 'selected' : ''}>👨 Masculin</option>
                    <option value="F" ${eleve.sexe == 'F' ? 'selected' : ''}>👩 Féminin</option>
                </select>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Nom *</label>
                <input type="text" name="nom" value="${eleve.nom}" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Prénom *</label>
                <input type="text" name="prenom" value="${eleve.prenom}" class="form-control" required>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Date de Naissance *</label>
                <input type="date" name="date_naissance" value="${eleve.date_naissance}" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Classe *</label>
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
            <label>Parent / Tuteur *</label>
            <select name="parent.id_parent" class="form-control" required>
                <c:forEach var="p" items="${parents}">
                    <option value="${p.id_parent}" ${p.id_parent == eleve.parent.id_parent ? 'selected' : ''}>
                        ${p.nom} ${p.prenom} (${p.telephone})
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>🖼️ Changer la photo (optionnel)</label>
            <div class="photo-upload-area" onclick="document.getElementById('photoInput').click()">
                <img id="photoPreview" src="${pageContext.request.contextPath}/images/default-avatar.png"
                     class="photo-preview" alt="Nouvelle photo">
                <p style="margin-top: 10px; color: #bdc3c7;">📁 Cliquez pour choisir une nouvelle photo</p>
                <input type="file" id="photoInput" name="file" class="form-control" accept="image/*"
                       style="display: none;" onchange="previewImage(this)">
            </div>
            <p class="info-text">Formats acceptés: JPG, PNG, GIF (max 5MB)</p>
        </div>

        <button type="submit" class="btn-submit">💾 Mettre à jour</button>
    </form>
</div>

<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];

            // Vérifier la taille du fichier (max 5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('❌ La photo est trop volumineuse. Maximum 5MB.');
                input.value = '';
                return;
            }

            // Vérifier le type de fichier
            if (!file.type.match('image.*')) {
                alert('❌ Veuillez sélectionner une image valide (JPG, PNG, GIF)');
                input.value = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('photoPreview');
                preview.src = e.target.result;
                preview.style.border = "3px solid #2ecc71";

                // Afficher un message de succès
                const infoText = document.querySelector('.info-text');
                if (infoText) {
                    infoText.style.color = '#2ecc71';
                    infoText.innerHTML = '✅ Nouvelle photo sélectionnée !';
                    setTimeout(() => {
                        infoText.style.color = '#bdc3c7';
                        infoText.innerHTML = 'Formats acceptés: JPG, PNG, GIF (max 5MB)';
                    }, 3000);
                }
            }
            reader.readAsDataURL(file);
        }
    }

    // Rafraîchir l'image actuelle pour éviter le cache
    document.addEventListener('DOMContentLoaded', function() {
        const currentPhoto = document.getElementById('currentPhoto');
        if (currentPhoto && currentPhoto.src) {
            const src = currentPhoto.src.split('?')[0];
            currentPhoto.src = src + '?t=' + new Date().getTime();
        }
    });
</script>
</body>
</html>