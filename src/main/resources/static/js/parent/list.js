let allParents = [];
let filteredParents = [];
let currentSort = { column: 'id', direction: 'ASC' };

document.addEventListener("DOMContentLoaded", function () {
    loadParentsData();
});

function loadParentsData() {
    fetch(`${contextPath}/parent/api/parents`)
        .then(response => {
            if (!response.ok) throw new Error("Erreur réseau");
            return response.json();
        })
        .then(data => {
            allParents = data;
            filteredParents = [...allParents];
            renderTable();
        })
        .catch(error => {
            console.error("Erreur de chargement des parents :", error);
            const tbody = document.getElementById("parentTableBody");
            if (tbody) {
                tbody.innerHTML = `<tr><td colspan="6" style="text-align: center; color: #ff4d4d;">Impossible de charger les données.</td></tr>`;
            }
        });
}

function renderTable() {
    applySort();

    const tbody = document.getElementById("parentTableBody");
    if (!tbody) return;
    tbody.innerHTML = "";

    if (filteredParents.length === 0) {
        tbody.innerHTML = `<tr><td colspan="6" style="text-align: center; color: #888;">Aucun responsable légal enregistré.</td></tr>`;
        return;
    }

    filteredParents.forEach(p => {
        const nomUpper = p.nom ? p.nom.toUpperCase() : "";
        const prenom = p.prenom || "";
        const emailContent = p.email
            ? `<i class="fas fa-envelope-open"></i> ${p.email}`
            : `<span style="color: #7f8c8d; font-style: italic;">Non renseigné</span>`;
        const adresse = p.adresse || "-";

        const tr = document.createElement("tr");

        tr.innerHTML = `
            <td class="id-cell">${p.id_parent || ''}</td>
            <td><strong>${nomUpper}</strong> ${prenom}</td>
            <td class="contact-cell"><i class="fas fa-mobile-alt"></i> ${p.telephone || ''}</td>
            <td class="contact-cell">${emailContent}</td>
            <td>${adresse}</td>
            <td class="action-buttons">
                <a href="${contextPath}/parent/modifier/${p.id_parent}" class="edit-link">
                    <i class="fas fa-edit"></i> Modifier
                </a>
                <a href="${contextPath}/parent/supprimer/${p.id_parent}" class="delete-link"
                   onclick="return confirm('⚠️ Êtes-vous sûr de vouloir retirer ce parent ? Cette action peut impacter l\'envoi des alertes.')">
                    <i class="fas fa-trash-alt"></i> Supprimer
                </a>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function instantSearch() {
    const query = document.getElementById("searchGlobal").value.toLowerCase();

    filteredParents = allParents.filter(p => {
        return (p.nom || '').toLowerCase().includes(query) ||
               (p.prenom || '').toLowerCase().includes(query) ||
               (p.telephone || '').toLowerCase().includes(query) ||
               (p.email || '').toLowerCase().includes(query) ||
               (p.adresse || '').toLowerCase().includes(query);
    });

    renderTable();
}

function resetFilters() {
    document.getElementById("searchGlobal").value = "";
    filteredParents = [...allParents];
    renderTable();
}

function sortColumn(column) {
    if (currentSort.column === column) {
        currentSort.direction = currentSort.direction === 'ASC' ? 'DESC' : 'ASC';
    } else {
        currentSort.column = column;
        currentSort.direction = 'ASC';
    }

    document.querySelectorAll('th i[id^="sort-"]').forEach(icon => {
        icon.className = "fas fa-sort";
    });
    const activeIcon = document.getElementById(`sort-${column}`);
    if (activeIcon) {
        activeIcon.className = currentSort.direction === 'ASC' ? "fas fa-sort-up" : "fas fa-sort-down";
    }

    renderTable();
}

function applySort() {
    filteredParents.sort((a, b) => {
        let valA = getSortValue(a, currentSort.column);
        let valB = getSortValue(b, currentSort.column);

        if (typeof valA === 'string') valA = valA.toLowerCase();
        if (typeof valB === 'string') valB = valB.toLowerCase();

        if (valA < valB) return currentSort.direction === 'ASC' ? -1 : 1;
        if (valA > valB) return currentSort.direction === 'ASC' ? 1 : -1;
        return 0;
    });
}

function getSortValue(item, col) {
    switch (col) {
        case 'id': return item.id_parent || 0;
        case 'nom': return item.nom || '';
        case 'telephone': return item.telephone || '';
        case 'email': return item.email || '';
        case 'adresse': return item.adresse || '';
        default: return 0;
    }
}