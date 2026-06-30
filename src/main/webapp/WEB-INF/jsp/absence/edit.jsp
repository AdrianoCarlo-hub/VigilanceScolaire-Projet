<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="edit.css" %>

    /* Styles supplémentaires pour la sécurité */
    .info-card {
        background: rgba(255,255,255,0.05);
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 25px;
        border: 1px solid rgba(255,255,255,0.1);
    }

    .info-card h3 {
        color: #ffd700;
        margin-bottom: 15px;
        font-size: 18px;
    }

    .info-row {
        display: flex;
        margin-bottom: 12px;
        padding: 8px 0;
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }

    .info-label {
        width: 120px;
        font-weight: bold;
        color: #00d4ff;
    }

    .info-value {
        flex: 1;
        color: white;
    }

    .photo-preview {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #ffd700;
    }

    .alert-warning {
        background: rgba(243, 156, 18, 0.2);
        border-left: 4px solid #f39c12;
        padding: 12px 15px;
        border-radius: 8px;
        margin: 15px 0;
        color: #f39c12;
        font-size: 13px;
        display: none;
    }

    .checkbox-group-container {
        display: flex;
        align-items: center;
        gap: 12px;
        margin: 20px 0;
        padding: 10px 0;
    }

    .checkbox-group-container input {
        width: 18px;
        height: 18px;
        cursor: pointer;
        accent-color: #00d4ff;
    }

    .checkbox-group-container label {
        margin: 0;
        cursor: pointer;
        color: white;
    }

    .checkbox-group-container label i {
        color: #ffd700;
        margin-right: 8px;
    }

    .btn-submit {
        background: linear-gradient(135deg, #3498db, #2980b9);
        color: white;
        padding: 14px 30px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        transition: transform 0.2s;
    }

    .btn-submit:hover {
        transform: translateY(-2px);
    }

    .btn-back {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 20px;
        color: #ffd700;
        text-decoration: none;
    }

    .form-container {
        max-width: 700px;
        margin: 30px auto;
        background: #1a252f;
        border-radius: 16px;
        padding: 30px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.3);
    }

    h2 {
        color: white;
        margin-bottom: 25px;
        font-size: 24px;
        border-bottom: 2px solid rgba(255,255,255,0.1);
        padding-bottom: 15px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #00d4ff;
        font-weight: bold;
    }

    .form-control {
        width: 100%;
        padding: 12px 15px;
        border-radius: 8px;
        border: 1px solid #34495e;
        background: #2c3e50;
        color: white;
        font-size: 14px;
    }

    .form-control:focus {
        outline: none;
        border-color: #ffd700;
    }
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/absence" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour à la liste
    </a>
    <h2><i class="fas fa-edit"></i> Modifier l'Absence</h2>

    <form action="${pageContext.request.contextPath}/absence/save" method="post">
        <input type="hidden" name="id_absence" value="${absence.id_absence}">
        <input type="hidden" name="eleve.id_eleve" value="${absence.eleve.id_eleve}">
        <input type="hidden" name="date_absence" value="${absence.date_absence}">

        <div class="info-card">
            <h3><i class="fas fa-id-card"></i> Fiche descriptive de l'absence</h3>

            <div class="info-row">
                <div class="info-label"><i class="fas fa-user-graduate"></i> Élève :</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty absence.eleve.photo}">
                            <img src="${pageContext.request.contextPath}/uploads/${absence.eleve.photo}"
                                 class="photo-preview"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'"
                                 style="vertical-align: middle; margin-right: 15px;">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/default-avatar.png"
                                 class="photo-preview"
                                 style="vertical-align: middle; margin-right: 15px;">
                        </c:otherwise>
                    </c:choose>
                    <strong>${absence.eleve.nom}</strong> ${absence.eleve.prenom}
                    <span style="color: #bbb; margin-left: 5px;">(ID: ${absence.eleve.id_eleve})</span>
                </div>
            </div>

            <div class="info-row">
                <div class="info-label"><i class="fas fa-school"></i> Classe :</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty absence.eleve.classe}">
                            ${absence.eleve.classe.nom} - ${absence.eleve.classe.niveau}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #aaa;">Non assignée</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-row">
                <div class="info-label"><i class="fas fa-calendar-alt"></i> Date :</div>
                <div class="info-value">${absence.date_absence}</div>
            </div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-comment-dots"></i> Motif de l'absence</label>
            <input type="text" name="motif" value="${absence.motif}" class="form-control"
                   placeholder="Ex: Raisons médicales, Rendez-vous...">
            <small style="color: #aaa; display: block; margin-top: 4px;">Laissez vide ou modifiez si non spécifié</small>
        </div>

        <div class="checkbox-group-container">
            <input type="checkbox" name="justifie" id="justifie" value="true" ${absence.justifie ? 'checked' : ''}>
            <label for="justifie">
                <i class="fas fa-check-circle"></i> Cette absence est-elle justifiée ?
            </label>
        </div>

        <div id="warningMessage" class="alert-warning">
            <i class="fas fa-exclamation-triangle"></i> Attention : Pour qu'une absence soit officiellement validée comme justifiée, un motif explicite doit être renseigné.
        </div>

        <button type="submit" class="btn-submit"><i class="fas fa-save"></i> Mettre à jour</button>
    </form>
</div>

<script>
    // Vérifier que les éléments existent avant d'ajouter les écouteurs
    const motifInput = document.querySelector('input[name="motif"]');
    const justifieCheckbox = document.getElementById('justifie');
    const warningMessage = document.getElementById('warningMessage');

    function validateJustification() {
        if (warningMessage) {
            if (justifieCheckbox && justifieCheckbox.checked && (!motifInput.value || motifInput.value.trim() === '')) {
                warningMessage.style.display = 'block';
                justifieCheckbox.checked = false;
                return false;
            } else if (warningMessage) {
                warningMessage.style.display = 'none';
            }
        }
        return true;
    }

    if (motifInput && justifieCheckbox) {
        motifInput.addEventListener('input', function() {
            if (this.value.trim() !== '' && justifieCheckbox.checked && warningMessage) {
                warningMessage.style.display = 'none';
            } else if (justifieCheckbox.checked && this.value.trim() === '' && warningMessage) {
                warningMessage.style.display = 'block';
                justifieCheckbox.checked = false;
            }
        });

        justifieCheckbox.addEventListener('change', function() {
            if (this.checked && (!motifInput.value || motifInput.value.trim() === '')) {
                if (warningMessage) warningMessage.style.display = 'block';
                this.checked = false;
            } else {
                if (warningMessage) warningMessage.style.display = 'none';
            }
        });
    }

    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', function(e) {
            if (!validateJustification()) {
                e.preventDefault();
            }
        });
    }
</script>

<jsp:include page="../includes/footer.jsp" />