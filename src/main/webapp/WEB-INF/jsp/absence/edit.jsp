<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<style>
    .info-card {
        background: rgba(255,255,255,0.1);
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 25px;
    }

    .info-card h3 {
        color: #ffd700;
        margin-bottom: 15px;
    }

    .info-row {
        display: flex;
        margin-bottom: 10px;
        padding: 8px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
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
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #ffd700;
    }
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/absence" class="btn-back">← Retour à la liste</a>
    <h2>✏️ Modifier l'Absence</h2>

    <form action="${pageContext.request.contextPath}/absence/save" method="post">
        <input type="hidden" name="id_absence" value="${absence.id_absence}">
        <input type="hidden" name="eleve.id_eleve" value="${absence.eleve.id_eleve}">
        <input type="hidden" name="date_absence" value="${absence.date_absence}">

        <!-- Informations non modifiables (affichage) -->
        <div class="info-card">
            <h3>📋 Informations de l'absence</h3>
            <div class="info-row">
                <div class="info-label">👨‍🎓 Élève :</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty absence.eleve.photo}">
                            <img src="${pageContext.request.contextPath}/images/${absence.eleve.photo}"
                                 class="photo-preview"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'"
                                 style="vertical-align: middle; margin-right: 10px;">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/default-avatar.png"
                                 class="photo-preview"
                                 style="vertical-align: middle; margin-right: 10px;">
                        </c:otherwise>
                    </c:choose>
                    <strong>${absence.eleve.nom}</strong> ${absence.eleve.prenom}
                    <span style="color: #aaa;">(${absence.eleve.matricule})</span>
                </div>
            </div>
            <div class="info-row">
                <div class="info-label">🏫 Classe :</div>
                <div class="info-value">${absence.eleve.classe.nom} - ${absence.eleve.classe.niveau}</div>
            </div>
            <div class="info-row">
                <div class="info-label">📅 Date :</div>
                <div class="info-value">${absence.date_absence}</div>
            </div>
        </div>

        <!-- Champs modifiables -->
        <div class="form-group">
            <label>📝 Motif de l'absence</label>
            <input type="text" name="motif" value="${absence.motif}" class="form-control"
                   placeholder="Ex: Raisons médicales, Rendez-vous...">
            <small style="color: #aaa;">Laissez vide si non spécifié</small>
        </div>

        <div class="form-group" style="display: flex; align-items: center; gap: 10px; color: white; margin-top: 15px;">
            <input type="checkbox" name="justifie" id="justifie" value="true" ${absence.justifie ? 'checked' : ''}
                   style="width: 18px; height: 18px;">
            <label for="justifie" style="margin-bottom: 0; cursor: pointer;">
                ✅ Cette absence est-elle justifiée ?
            </label>
        </div>

        <div id="warningMessage" class="alert alert-warning" style="display: none; margin-top: 15px; padding: 10px; background: rgba(243, 156, 18, 0.2); border-left: 4px solid #f39c12; color: #f39c12;">
            ⚠️ Attention : Pour qu'une absence soit justifiée, un motif doit être renseigné.
        </div>

        <button type="submit" class="btn-submit" style="margin-top: 20px;">💾 Mettre à jour</button>
    </form>
</div>

<script>
    const motifInput = document.querySelector('input[name="motif"]');
    const justifieCheckbox = document.getElementById('justifie');
    const warningMessage = document.getElementById('warningMessage');

    function validateJustification() {
        if (justifieCheckbox.checked && (!motifInput.value || motifInput.value.trim() === '')) {
            warningMessage.style.display = 'block';
            justifieCheckbox.checked = false;
            return false;
        } else {
            warningMessage.style.display = 'none';
            return true;
        }
    }

    motifInput.addEventListener('input', function() {
        if (this.value.trim() !== '' && justifieCheckbox.checked) {
            // C'est OK
            warningMessage.style.display = 'none';
        } else if (justifieCheckbox.checked && this.value.trim() === '') {
            warningMessage.style.display = 'block';
            justifieCheckbox.checked = false;
        }
    });

    justifieCheckbox.addEventListener('change', function() {
        if (this.checked && (!motifInput.value || motifInput.value.trim() === '')) {
            warningMessage.style.display = 'block';
            this.checked = false;
        } else {
            warningMessage.style.display = 'none';
        }
    });

    // Vérification au soumission
    document.querySelector('form').addEventListener('submit', function(e) {
        if (!validateJustification()) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>