<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="add.css" %>

    .student-list {
        max-height: 400px;
        overflow-y: auto;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        background: #22313f;
        margin-top: 10px;
    }

    .student-item {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        border-bottom: 1px solid var(--border-color);
        cursor: pointer;
        transition: background 0.2s;
    }

    .student-item:hover {
        background: rgba(0, 212, 255, 0.1);
    }

    .student-item input[type="checkbox"] {
        width: 20px;
        height: 20px;
        margin-right: 15px;
        cursor: pointer;
        accent-color: var(--accent-cyan);
    }

    .student-info {
        flex: 1;
    }

    .student-name {
        font-weight: bold;
        color: white;
    }

    .student-id {
        font-size: 12px;
        color: var(--text-muted);
        margin-left: 10px;
    }

    .select-all {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        background: #2c3e50;
        border-radius: 8px;
        margin-bottom: 10px;
    }

    .select-all input {
        width: 20px;
        height: 20px;
        margin-right: 15px;
        cursor: pointer;
    }

    .select-all label {
        margin: 0;
        cursor: pointer;
        font-weight: bold;
        color: var(--accent-gold);
    }

    .selected-count {
        margin-left: auto;
        font-size: 12px;
        color: var(--accent-cyan);
    }

    .btn-submit {
        background: linear-gradient(135deg, var(--success-color), #27ae60);
    }

    /* Styles pour les notifications toast */
    .toast-container {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .toast-notification {
        min-width: 300px;
        padding: 15px 20px;
        border-radius: 8px;
        color: white;
        display: flex;
        align-items: center;
        gap: 12px;
        animation: slideInRight 0.3s ease;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        font-weight: 500;
    }

    .toast-success {
        background: linear-gradient(135deg, #27ae60, #2ecc71);
        border-left: 4px solid #fff;
    }

    .toast-error {
        background: linear-gradient(135deg, #c0392b, #e74c3c);
        border-left: 4px solid #fff;
    }

    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/absence" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour à la liste
    </a>
    <h2><i class="fas fa-calendar-minus"></i> Enregistrer des Absences</h2>

    <sec:authorize access="hasRole('PROFESSEUR')">
        <div class="info-note">
            <i class="fas fa-info-circle"></i> En tant que Professeur, vous ne voyez que vos propres classes.
        </div>
    </sec:authorize>

    <form id="absenceForm" action="${pageContext.request.contextPath}/absence/save-multiple" method="post">

        <div class="form-group">
            <label><i class="fas fa-book"></i> 1. Choisir la classe</label>
            <select id="classeSelect" class="form-control" required>
                <option value="">-- Sélectionner une classe --</option>
                <c:forEach var="cl" items="${classes}">
                    <option value="${cl.id_classe}">${cl.nom} - ${cl.niveau}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label><i class="fas fa-user-graduate"></i> 2. Sélectionner les élèves absents</label>
            <div id="studentListContainer" class="student-list">
                <div style="padding: 20px; text-align: center; color: var(--text-muted);">
                    <i class="fas fa-info-circle"></i> Veuillez d'abord sélectionner une classe
                </div>
            </div>
            <div id="selectedCount" class="selected-count" style="margin-top: 10px; text-align: right;"></div>
        </div>

        <div class="form-group">
            <label><i class="fas fa-calendar-alt"></i> 3. Date de l'absence</label>
            <input type="date" name="date_absence" id="dateAbsence" class="form-control" required>
        </div>

        <div class="form-group">
            <label><i class="fas fa-comment-alt"></i> 4. Motif de l'absence (optionnel)</label>
            <input type="text" name="motif" id="motif" class="form-control" placeholder="Ex: Raisons médicales, Rendez-vous...">
        </div>

        <div class="checkbox-group">
            <input type="checkbox" name="justifie" id="justifie" value="true">
            <label for="justifie"><i class="fas fa-check-circle"></i> Absences justifiées</label>
        </div>

        <!-- Champ caché pour les IDs des élèves -->
        <input type="hidden" id="elevesIds" name="elevesIds">

        <button type="submit" class="btn-submit"><i class="fas fa-save"></i> Enregistrer les absences</button>
    </form>
</div>

<!-- Conteneur pour les notifications toast -->
<div id="toastContainer" class="toast-container"></div>

<script>
    // ========== FONCTIONS DE NOTIFICATION TOAST ==========

    function showToast(message, type) {
        const container = document.getElementById('toastContainer');
        if (!container) return;

        const toast = document.createElement('div');
        toast.className = `toast-notification toast-${type}`;

        let icon = '';
        if (type === 'success') icon = '<i class="fas fa-check-circle fa-lg"></i>';
        else if (type === 'error') icon = '<i class="fas fa-exclamation-circle fa-lg"></i>';
        else icon = '<i class="fas fa-info-circle fa-lg"></i>';

        toast.innerHTML = `${icon} <span>${message}</span>`;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(100%)';
            setTimeout(() => toast.remove(), 300);
        }, 5000);
    }

    // ========== LOGIQUE PRINCIPALE ==========

    // Date du jour par défaut
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('dateAbsence').value = today;

    const classeSelect = document.getElementById('classeSelect');
    const studentContainer = document.getElementById('studentListContainer');
    const elevesIdsInput = document.getElementById('elevesIds');
    const selectedCountDiv = document.getElementById('selectedCount');
    const motifInput = document.getElementById('motif');
    const justifieCheckbox = document.getElementById('justifie');

    let currentEleves = [];

    function updateJustifieState() {
        const motif = motifInput.value.trim();
        if (motif !== '' && motif !== 'Inconnu') {
            justifieCheckbox.disabled = false;
        } else {
            justifieCheckbox.disabled = true;
            justifieCheckbox.checked = false;
        }
    }

    motifInput.addEventListener('input', updateJustifieState);
    updateJustifieState();

    function updateSelectedCount() {
        const checkboxes = document.querySelectorAll('.student-checkbox:checked');
        const count = checkboxes.length;
        selectedCountDiv.innerHTML = count > 0 ? count + ' élève(s) sélectionné(s)' : '';

        // Construction de la chaîne d'IDs pour le champ caché
        const selectedIds = Array.from(checkboxes).map(cb => cb.value);
        elevesIdsInput.value = selectedIds.join(',');
        console.log('IDs sélectionnés (champ caché):', elevesIdsInput.value);
    }

    function renderStudentList(eleves) {
        currentEleves = eleves;

        if (!eleves || eleves.length === 0) {
            studentContainer.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--text-muted);">' +
                '<i class="fas fa-folder-open"></i> Aucun élève dans cette classe</div>';
            return;
        }

        let html = '';

        // Ligne "Tout sélectionner"
        html += '<div class="select-all">';
        html += '<input type="checkbox" id="selectAllCheckbox">';
        html += '<label for="selectAllCheckbox"><i class="fas fa-check-double"></i> Tout sélectionner</label>';
        html += '<span class="selected-count" id="selectAllCount">0 élève(s)</span>';
        html += '</div>';

        // Liste des élèves
        for (let i = 0; i < eleves.length; i++) {
            const eleve = eleves[i];
            const eleveId = eleve.id_eleve;
            const nom = eleve.nom || '';
            const prenom = eleve.prenom || '';

            html += '<div class="student-item" data-id="' + eleveId + '">';
            html += '<input type="checkbox" class="student-checkbox" value="' + eleveId + '" id="student_' + eleveId + '">';
            html += '<div class="student-info">';
            html += '<div class="student-name">' + nom + ' ' + prenom + '<span class="student-id">(#' + eleveId + ')</span></div>';
            html += '</div>';
            html += '</div>';
        }

        studentContainer.innerHTML = html;

        // Événement "Tout sélectionner"
        const selectAllCheckbox = document.getElementById('selectAllCheckbox');
        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', function(e) {
                const isChecked = e.target.checked;
                document.querySelectorAll('.student-checkbox').forEach(cb => {
                    cb.checked = isChecked;
                });
                updateSelectedCount();
                const countSpan = document.getElementById('selectAllCount');
                if (countSpan) {
                    countSpan.innerText = isChecked ? currentEleves.length + ' élève(s)' : '0 élève(s)';
                }
            });
        }

        // Événements pour chaque checkbox
        document.querySelectorAll('.student-checkbox').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                updateSelectedCount();

                const allCheckboxes = document.querySelectorAll('.student-checkbox');
                const allChecked = Array.from(allCheckboxes).every(cb => cb.checked);
                const selectAll = document.getElementById('selectAllCheckbox');
                if (selectAll) {
                    selectAll.checked = allChecked;
                    const countSpan = document.getElementById('selectAllCount');
                    if (countSpan) {
                        countSpan.innerText = allChecked ? currentEleves.length + ' élève(s)' : '0 élève(s)';
                    }
                }
            });
        });

        // Clic sur la ligne
        document.querySelectorAll('.student-item').forEach(item => {
            item.addEventListener('click', function(e) {
                if (e.target.type !== 'checkbox') {
                    const checkbox = this.querySelector('.student-checkbox');
                    if (checkbox) {
                        checkbox.checked = !checkbox.checked;
                        checkbox.dispatchEvent(new Event('change'));
                    }
                }
            });
        });

        updateSelectedCount();
    }

    // Chargement des élèves
    classeSelect.addEventListener('change', function() {
        const classeId = this.value;

        if (!classeId) {
            studentContainer.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--text-muted);">' +
                '<i class="fas fa-info-circle"></i> Veuillez d\'abord sélectionner une classe</div>';
            return;
        }

        studentContainer.innerHTML = '<div style="padding: 20px; text-align: center; color: var(--text-muted);">' +
            '<i class="fas fa-spinner fa-spin"></i> Chargement des élèves...</div>';

        fetch('${pageContext.request.contextPath}/eleve/byClasse/simple/' + classeId)
            .then(response => response.json())
            .then(eleves => {
                renderStudentList(eleves);
            })
            .catch(error => {
                console.error('Erreur:', error);
                studentContainer.innerHTML = '<div style="padding: 20px; text-align: center; color: #e74c3c;">' +
                    '<i class="fas fa-exclamation-circle"></i> Erreur lors du chargement</div>';
            });
    });

    // Soumission du formulaire
    document.getElementById('absenceForm').addEventListener('submit', function(e) {
        const selectedIds = Array.from(document.querySelectorAll('.student-checkbox:checked')).map(cb => cb.value);

        if (selectedIds.length === 0) {
            e.preventDefault();
            showToast('Veuillez sélectionner au moins un élève absent.', 'error');
            return false;
        }

        // Mettre à jour le champ caché avec les IDs
        elevesIdsInput.value = selectedIds.join(',');
        console.log('SOUMISSION - IDs envoyés:', elevesIdsInput.value);

        return true;
    });
</script>

<jsp:include page="../includes/footer.jsp" />