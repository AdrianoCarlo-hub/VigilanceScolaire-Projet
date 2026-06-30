let availableClasses = [];
let currentClassIndex = 0;
let alertDataCache = {};
let allAlertsFlat = [];
let sortBy = 'date';
let direction = 'DESC';
let selectedAlertId = null;

document.addEventListener("DOMContentLoaded", function () {
    loadClassesAndFetchAlerts();
});

function loadClassesAndFetchAlerts() {
    fetch(`${contextPath}/alerte/api/user-classes`)
        .then(response => response.json())
        .then(classes => {
            availableClasses = classes || [];
            currentClassIndex = 0;

            if (availableClasses.length > 0) {
                const fetchPromises = availableClasses.map(c =>
                    fetch(`${contextPath}/alerte/api/classe/${c.id_classe}`).then(res => res.json())
                );

                Promise.all(fetchPromises)
                    .then(results => {
                        allAlertsFlat = [];
                        results.forEach((data, index) => {
                            const cl = availableClasses[index];
                            alertDataCache[cl.id_classe] = data;
                            if (data.content && Array.isArray(data.content)) {
                                allAlertsFlat = allAlertsFlat.concat(data.content);
                            }
                        });
                        fetchAlertsForCurrentClass();
                        updateStatsDashboard();
                    })
                    .catch(err => console.error("Erreur chargement alertes:", err));
            } else {
                document.getElementById("alertTableBody").innerHTML =
                    `<tr><td colspan="9" style="text-align: center; color: #94A3B8;">Aucune classe assignee ou alerte trouvee.</td></tr>`;
                updatePaginationControls();
            }
        })
        .catch(error => {
            console.error("Erreur chargement classes:", error);
            showToast("Erreur lors du chargement des classes", "error");
        });
}

function fetchAlertsForCurrentClass() {
    if (!availableClasses || availableClasses.length === 0) return;

    const currentClass = availableClasses[currentClassIndex];
    const cachedData = alertDataCache[currentClass.id_classe];

    if (cachedData) {
        if (!document.getElementById("globalSearch").value) {
            applySortAndRender(cachedData.content || []);
        }
        updatePaginationDisplay(currentClass.nom, cachedData.content?.length || 0);
        updatePaginationControls();
    }
}

function navigateClass(directionNum) {
    const newIndex = currentClassIndex + directionNum;
    if (newIndex >= 0 && newIndex < availableClasses.length) {
        currentClassIndex = newIndex;
        document.getElementById("globalSearch").value = "";
        fetchAlertsForCurrentClass();
    }
}

function filterTable() {
    const query = document.getElementById("globalSearch").value.toLowerCase().trim();

    if (query === "") {
        const currentClass = availableClasses[currentClassIndex];
        const cachedData = alertDataCache[currentClass?.id_classe]?.content || [];
        applySortAndRender(cachedData);
        return;
    }

    const globalFiltered = allAlertsFlat.filter(alert => {
        const eleve = alert.eleve || {};
        const nom = (eleve.nom || '').toLowerCase();
        const prenom = (eleve.prenom || '').toLowerCase();
        const matricule = (eleve.id_eleve || '').toString().toLowerCase();
        const typeAlerte = (alert.type || '').toLowerCase();
        const canal = (alert.canal || '').toLowerCase();
        const statut = (alert.statut || '').toLowerCase();
        const classeNom = (eleve.classe?.nom || '').toLowerCase();

        return nom.includes(query) ||
               prenom.includes(query) ||
               `${prenom} ${nom}`.includes(query) ||
               matricule.includes(query) ||
               typeAlerte.includes(query) ||
               canal.includes(query) ||
               statut.includes(query) ||
               classeNom.includes(query);
    });

    renderTable(globalFiltered);
}

function applySortAndRender(dataList) {
    const sortedData = [...dataList].sort((a, b) => {
        let valA = getSortValue(a, sortBy);
        let valB = getSortValue(b, sortBy);

        if (valA < valB) return direction === 'ASC' ? -1 : 1;
        if (valA > valB) return direction === 'ASC' ? 1 : -1;
        return 0;
    });

    renderTable(sortedData);
}

function getSortValue(item, column) {
    switch (column) {
        case 'id': return item.id_alerte || 0;
        case 'eleve': return (item.eleve?.nom || '').toLowerCase();
        case 'matricule': return item.eleve?.id_eleve || 0;
        case 'classe': return (item.eleve?.classe?.nom || '').toLowerCase();
        case 'date': return item.date_alerte || '';
        case 'type': return (item.type || '').toLowerCase();
        case 'canal': return (item.canal || '').toLowerCase();
        case 'statut': return (item.statut || '').toLowerCase();
        default: return item.id_alerte || 0;
    }
}

function sortColumn(columnName) {
    if (sortBy === columnName) {
        direction = direction === 'ASC' ? 'DESC' : 'ASC';
    } else {
        sortBy = columnName;
        direction = 'ASC';
    }

    document.querySelectorAll('.table-dark th i').forEach(icon => {
        icon.className = "fas fa-sort";
    });

    const activeIcon = document.getElementById(`sort-${columnName}`);
    if (activeIcon) {
        activeIcon.className = direction === 'ASC' ? "fas fa-sort-up" : "fas fa-sort-down";
    }

    const query = document.getElementById("globalSearch").value.toLowerCase().trim();
    if (query !== "") {
        filterTable();
    } else {
        const currentClass = availableClasses[currentClassIndex];
        const cachedData = alertDataCache[currentClass?.id_classe]?.content || [];
        applySortAndRender(cachedData);
    }
}

function renderTable(content) {
    const tbody = document.getElementById("alertTableBody");
    tbody.innerHTML = "";

    if (!content || content.length === 0) {
        tbody.innerHTML = `<tr><td colspan="9" style="text-align: center; color: #94A3B8;">Aucune alerte trouvee.</td></tr>`;
        return;
    }

    content.forEach(alert => {
        const eleve = alert.eleve || {};
        const classe = alert.eleve?.classe || {};

        const tr = document.createElement("tr");
        tr.className = "clickable-row";
        tr.onclick = () => openModal(alert.id_alerte);

        const isSuccess = alert.statut === 'ENVOYE' || alert.statut === 'ENVOYE';

        tr.innerHTML = `
            <td>${alert.id_alerte || ''}</td>
            <td><strong>${eleve.nom ? eleve.nom.toUpperCase() : ''}</strong> ${eleve.prenom || ''}</td>
            <td>${eleve.id_eleve || ''}</td>
            <td>${classe.nom || 'N/A'}</td>
            <td>${alert.date_alerte || 'N/A'}</td>
            <td><span class="badge badge-warning">${alert.type || 'Inconnu'}</span></td>
            <td><i class="fas fa-${alert.canal === 'SMS' ? 'comment-alt' : 'envelope'}"></i> ${alert.canal || ''}</td>
            <td>
                <span class="badge ${isSuccess ? 'badge-success' : 'badge-danger'}">
                    <i class="fas fa-${isSuccess ? 'check' : 'times'}-circle"></i> ${alert.statut || ''}
                </span>
            </td>
            <td onclick="event.stopPropagation()">
                <div class="action-buttons">
                    <a href="${contextPath}/alerte/modifier/${alert.id_alerte}" class="edit-link">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                    <a href="${contextPath}/alerte/supprimer/${alert.id_alerte}" class="delete-link"
                       onclick="return confirm('⚠️ Voulez-vous supprimer definitivement cette trace d\\'alerte ?');">
                        <i class="fas fa-trash-alt"></i> Supprimer
                    </a>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function updatePaginationDisplay(className, count) {
    document.getElementById("pageIndicator").innerText = `Classe : ${className || '--'}`;
    document.getElementById("classCount").innerText = count === 1 ? `(1 alerte)` : `(${count} alertes)`;
}

function updatePaginationControls() {
    const prevBtn = document.getElementById("prevPageBtn");
    const nextBtn = document.getElementById("nextPageBtn");

    if (prevBtn) prevBtn.disabled = currentClassIndex === 0;
    if (nextBtn) nextBtn.disabled = currentClassIndex >= availableClasses.length - 1 || availableClasses.length === 0;
}

function updateStatsDashboard() {
    const total = allAlertsFlat.length;
    const envoyees = allAlertsFlat.filter(a => a.statut === 'ENVOYE' || a.statut === 'ENVOYE').length;
    const echouees = total - envoyees;
    const sms = allAlertsFlat.filter(a => a.canal === 'SMS').length;
    const email = allAlertsFlat.filter(a => a.canal === 'EMAIL' || a.canal === 'Email').length;

    const todayStr = new Date().toISOString().split('T')[0];
    const duJour = allAlertsFlat.filter(a => a.date_alerte && a.date_alerte.startsWith(todayStr)).length;

    document.getElementById("statTotal").innerText = total;
    document.getElementById("statEnvoyees").innerText = envoyees;
    document.getElementById("statEchouees").innerText = echouees;
    document.getElementById("statSms").innerText = sms;
    document.getElementById("statEmail").innerText = email;
    document.getElementById("statAujourdHui").innerText = duJour;
}

function resetFilters() {
    document.getElementById("globalSearch").value = "";
    fetchAlertsForCurrentClass();
}

// ========== MODAL ==========

function openModal(id) {
    selectedAlertId = id;
    fetch(`${contextPath}/alerte/api/${id}`)
        .then(response => response.json())
        .then(alert => {
            const eleve = alert.eleve || {};
            const classe = eleve.classe || {};

            document.getElementById("modalId").innerText = alert.id_alerte || '';
            document.getElementById("modalNomComplet").innerText = `${eleve.prenom || ''} ${eleve.nom ? eleve.nom.toUpperCase() : ''}`;
            document.getElementById("modalMatricule").innerText = eleve.id_eleve || '';
            document.getElementById("modalClasse").innerText = classe.nom || 'N/A';
            document.getElementById("modalDate").innerText = alert.date_alerte || 'N/A';
            document.getElementById("modalType").innerText = alert.type || 'Inconnu';
            document.getElementById("modalCanal").innerText = alert.canal || 'Inconnu';

            const badge = document.getElementById("modalBadge");
            const isSuccess = alert.statut === 'ENVOYE' || alert.statut === 'ENVOYE';
            badge.className = `badge ${isSuccess ? 'badge-success' : 'badge-danger'}`;
            badge.innerHTML = `<i class="fas fa-${isSuccess ? 'check' : 'times'}-circle"></i> ${alert.statut || ''}`;

            document.getElementById("modalMessage").innerText = alert.message || 'Aucun message';
            document.getElementById("modalCreateur").innerText = alert.utilisateur ? (alert.utilisateur.prenom + ' ' + alert.utilisateur.nom) : 'Systeme automatique';
            document.getElementById("modalDateCreation").innerText = alert.dateCreation || 'N/A';
            document.getElementById("modalDateModification").innerText = alert.dateModification || 'N/A';

            document.getElementById("alertModal").style.display = "block";
        })
        .catch(error => {
            console.error("Erreur chargement modal:", error);
            showToast("Erreur lors du chargement des details", "error");
        });
}

function closeModal() {
    document.getElementById("alertModal").style.display = "none";
}

window.onclick = function(event) {
    const modal = document.getElementById("alertModal");
    if (event.target === modal) {
        modal.style.display = "none";
    }
}

// ========== ACTIONS ==========

function reenvoyerAlerte() {
    if (!selectedAlertId) return;
    fetch(`${contextPath}/alerte/api/resend/${selectedAlertId}`, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            showToast("Alerte reenvoyee avec succes !", "success");
            closeModal();
            loadClassesAndFetchAlerts();
        })
        .catch(err => {
            console.error(err);
            showToast("Erreur lors du renvoi de l'alerte.", "error");
        });
}

function dupliquerAlerte() {
    if (!selectedAlertId) return;
    fetch(`${contextPath}/alerte/api/duplicate/${selectedAlertId}`, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            showToast("Alerte dupliquee avec succes !", "success");
            closeModal();
            loadClassesAndFetchAlerts();
        })
        .catch(err => {
            console.error(err);
            showToast("Erreur lors de la duplication de l'alerte.", "error");
        });
}

// ========== EXPORTS ==========

function getActivelyFilteredData() {
    const query = document.getElementById("globalSearch").value.toLowerCase().trim();
    if (query === "") {
        const currentClass = availableClasses[currentClassIndex];
        return alertDataCache[currentClass?.id_classe]?.content || [];
    }
    return allAlertsFlat.filter(alert => {
        const eleve = alert.eleve || {};
        const nom = (eleve.nom || '').toLowerCase();
        const prenom = (eleve.prenom || '').toLowerCase();
        const matricule = (eleve.id_eleve || '').toString().toLowerCase();
        const typeAlerte = (alert.type || '').toLowerCase();
        const canal = (alert.canal || '').toLowerCase();
        const statut = (alert.statut || '').toLowerCase();
        const classeNom = (eleve.classe?.nom || '').toLowerCase();

        return nom.includes(query) ||
               prenom.includes(query) ||
               `${prenom} ${nom}`.includes(query) ||
               matricule.includes(query) ||
               typeAlerte.includes(query) ||
               canal.includes(query) ||
               statut.includes(query) ||
               classeNom.includes(query);
    });
}

function exportPdf() {
    const data = getActivelyFilteredData();
    if (!data.length) return showToast("Aucune donnee a exporter.", "info");
    alert("Exportation PDF des donnees filtrees (Simulation) !");
}

function exportExcel() {
    const data = getActivelyFilteredData();
    if (!data.length) return showToast("Aucune donnee a exporter.", "info");
    alert("Exportation Excel des donnees filtrees (Simulation) !");
}

function printTable() {
    const data = getActivelyFilteredData();
    if (!data.length) return showToast("Aucune donnee a imprimer.", "info");
    window.print();
}

// ========== TOASTS ==========

function showToast(message, type = "info") {
    const container = document.getElementById("toastContainer");
    const toast = document.createElement("div");
    toast.className = `toast-notification toast-${type}`;

    let icon = "info-circle";
    if (type === "success") icon = "check-circle";
    if (type === "error") icon = "exclamation-circle";

    toast.innerHTML = `<i class="fas fa-${icon}"></i> <span>${message}</span>`;
    container.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'slideInRight 0.3s ease-in-out reverse forwards';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}