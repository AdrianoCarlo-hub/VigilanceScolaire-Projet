/**
 * Gestion de la page Liste des Absences
 */

let availableClasses = [];
let currentClassIndex = 0;
let classDataCache = {};
let allAbsencesFlat = [];
let sortBy = 'date';
let direction = 'DESC';

// Fonction pour afficher les notifications toast
function showToast(message, type) {
    let container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    
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

// Vérifier les messages flash
function checkFlashMessages() {
    const successMsg = document.body.getAttribute('data-success');
    const errorMsg = document.body.getAttribute('data-error');
    
    if (successMsg && successMsg !== '' && successMsg !== 'null') {
        showToast(successMsg, 'success');
        document.body.removeAttribute('data-success');
    }
    if (errorMsg && errorMsg !== '' && errorMsg !== 'null') {
        showToast(errorMsg, 'error');
        document.body.removeAttribute('data-error');
    }
}

/**
 * Charge les classes autorisées et récupère toutes les absences associées en cache.
 */
function loadClassesAndFetchAbsences() {
    fetch(`${contextPath}/absence/api/user-classes`)
        .then(response => response.json())
        .then(classes => {
            availableClasses = classes;
            currentClassIndex = 0;

            if (availableClasses && availableClasses.length > 0) {
                const fetchPromises = availableClasses.map(c =>
                    fetch(`${contextPath}/absence/api/classe/${c.id_classe}`).then(res => res.json())
                );

                Promise.all(fetchPromises)
                    .then(results => {
                        allAbsencesFlat = [];
                        results.forEach((data, index) => {
                            const cl = availableClasses[index];
                            classDataCache[cl.id_classe] = data;
                            if (data.content && Array.isArray(data.content)) {
                                allAbsencesFlat = allAbsencesFlat.concat(data.content);
                            }
                        });
                        fetchAbsencesForCurrentClass();
                    })
                    .catch(err => console.error("Erreur lors du chargement des absences des classes :", err));
            } else {
                const tbody = document.getElementById("absenceTableBody");
                tbody.innerHTML = `<tr><td colspan="8" style="text-align: center; color: var(--text-gray);">Aucune classe assignée.</td></tr>`;
                updatePaginationControls();
            }
        })
        .catch(error => {
            console.error("Erreur lors du chargement des classes :", error);
            showToast("Erreur lors du chargement des classes", "error");
        });
}

/**
 * Affiche les absences de la classe actuellement sélectionnée depuis le cache.
 */
function fetchAbsencesForCurrentClass() {
    if (!availableClasses || availableClasses.length === 0) return;

    const currentClass = availableClasses[currentClassIndex];
    const cachedData = classDataCache[currentClass.id_classe];

    if (cachedData) {
        if (!document.getElementById("globalSearch").value) {
            applySortAndRender(cachedData.content || []);
        }
        updatePaginationDisplay(currentClass.nom, cachedData.content?.length || 0);
        updateStats(cachedData.stats);
        updatePaginationControls();
    }
}

/**
 * Permet de naviguer entre les classes.
 */
function navigateClass(directionNum) {
    const newIndex = currentClassIndex + directionNum;
    if (newIndex >= 0 && newIndex < availableClasses.length) {
        currentClassIndex = newIndex;
        document.getElementById("globalSearch").value = "";
        fetchAbsencesForCurrentClass();
    }
}

/**
 * Filtre le tableau dynamiquement sur TOUTES les absences chargées (Recherche globale).
 */
function filterTable() {
    const query = document.getElementById("globalSearch").value.toLowerCase().trim();

    if (query === "") {
        const currentClass = availableClasses[currentClassIndex];
        const cachedData = classDataCache[currentClass?.id_classe]?.content || [];
        applySortAndRender(cachedData);
        return;
    }

    const globalFiltered = allAbsencesFlat.filter(absence => {
        const eleve = absence.eleve || {};
        const nom = (eleve.nom || '').toLowerCase();
        const prenom = (eleve.prenom || '').toLowerCase();
        const matricule = (eleve.id_eleve || '').toString().toLowerCase();
        const motif = (absence.motif || '').toLowerCase();
        const classeNom = (eleve.classe?.nom || '').toLowerCase();

        return nom.includes(query) ||
               prenom.includes(query) ||
               `${prenom} ${nom}`.includes(query) ||
               `${nom} ${prenom}`.includes(query) ||
               matricule.includes(query) ||
               motif.includes(query) ||
               classeNom.includes(query);
    });

    renderTable(globalFiltered);
}

/**
 * Applique le tri mémorisé et rafraîchit le tableau.
 */
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

/**
 * Extrait la valeur d'un objet selon la colonne ciblée pour le tri.
 */
function getSortValue(item, column) {
    switch (column) {
        case 'eleve':
            return (item.eleve?.nom || '').toLowerCase();
        case 'matricule':
            return item.eleve?.id_eleve || 0;
        case 'classe':
            return (item.eleve?.classe?.nom || '').toLowerCase();
        case 'date':
            return item.date_absence || '';
        case 'motif':
            return (item.motif || '').toLowerCase();
        default:
            return item.id_absence || 0;
    }
}

/**
 * Gère la logique de tri des colonnes lors du clic sur l'en-tête.
 */
function sortColumn(columnName) {
    if (sortBy === columnName) {
        direction = direction === 'ASC' ? 'DESC' : 'ASC';
    } else {
        sortBy = columnName;
        direction = 'ASC';
    }

    document.querySelectorAll('.table-modern th i').forEach(icon => {
        if (icon) icon.className = "fas fa-sort";
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
        const cachedData = classDataCache[currentClass?.id_classe]?.content || [];
        applySortAndRender(cachedData);
    }
}

/**
 * Met à jour le corps du tableau avec les données fournies.
 */
function renderTable(content) {
    const tbody = document.getElementById("absenceTableBody");
    tbody.innerHTML = "";

    if (!content || content.length === 0) {
        tbody.innerHTML = `<tr><td colspan="8" style="text-align: center; color: var(--text-gray);">Aucune absence trouvée.</td></tr>`;
        return;
    }

    content.forEach(absence => {
        const eleve = absence.eleve || {};
        const classe = eleve.classe || {};
        const utilisateur = classe.utilisateur || {};

        const formattedDate = absence.date_absence || 'N/A';
        const eleveClasseNom = classe.nom || eleve.classe?.nom || 'N/A';
        
        // Gestion de la photo
        let photoPath = `${contextPath}/images/default-avatar.png`;
        if (eleve.photo) {
            photoPath = `${contextPath}/uploads/${eleve.photo}`;
        }

        const tr = document.createElement("tr");
        tr.className = "clickable-row";
        tr.onclick = () => openModal(absence.id_absence);

        tr.innerHTML = `
            <td>
                <img src="${photoPath}"
                     class="img-thumbnail-custom"
                     alt="Photo"
                     onerror="this.src='${contextPath}/images/default-avatar.png'">
             </td>
            <td><strong>${eleve.nom || ''}</strong> ${eleve.prenom || ''}</td>
            <td>${eleve.id_eleve || '-'}</td>
            <td>${eleveClasseNom}</td>
            <td>${formattedDate}</td>
            <td>${absence.motif || 'Non spécifié'}</td>
            <td>
                <span class="badge ${absence.justifie ? 'badge-success' : 'badge-danger'}">
                    <i class="fas fa-${absence.justifie ? 'check-circle' : 'exclamation-circle'}"></i>
                    ${absence.justifie ? 'Justifiée' : 'Non justifiée'}
                </span>
             </td>
            <td onclick="event.stopPropagation()">
                <div class="action-buttons">
                    <a href="${contextPath}/absence/edit/${absence.id_absence}" class="edit-link">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                    <a href="${contextPath}/absence/delete/${absence.id_absence}" class="delete-link"
                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette absence ?');">
                        <i class="fas fa-trash-alt"></i> Supprimer
                    </a>
                </div>
             </td>
        `;
        tbody.appendChild(tr);
    });
}

/**
 * Met à jour le nom de la classe et le compteur dans l'affichage du paginateur.
 */
function updatePaginationDisplay(className, count) {
    const pageIndicator = document.getElementById("pageIndicator");
    if (pageIndicator) {
        pageIndicator.innerHTML = `Classe : <strong>${className}</strong>`;
    }
    const countSpan = document.getElementById("classCount");
    if (countSpan) {
        if (count === 1) {
            countSpan.innerText = `(1 absence)`;
        } else {
            countSpan.innerText = `(${count} absences)`;
        }
    }
}

/**
 * Active ou désactive les boutons Précédent et Suivant selon les limites.
 */
function updatePaginationControls() {
    const prevBtn = document.getElementById("prevPageBtn");
    const nextBtn = document.getElementById("nextPageBtn");

    if (prevBtn) {
        prevBtn.disabled = currentClassIndex === 0;
    }
    if (nextBtn) {
        nextBtn.disabled = currentClassIndex >= availableClasses.length - 1 || availableClasses.length === 0;
    }
}

/**
 * Met à jour les cartes statistiques du dashboard.
 */
function updateStats(stats) {
    if (!stats) return;
    
    const total = document.getElementById("statTotal");
    const justifiees = document.getElementById("statJustifiees");
    const nonJustifiees = document.getElementById("statNonJustifiees");
    const aujourdHui = document.getElementById("statAujourdHui");
    const classeMax = document.getElementById("statClasseMax");
    const eleveMax = document.getElementById("statEleveMax");
    
    if (total) total.innerText = stats.total || 0;
    if (justifiees) justifiees.innerText = stats.justifiees || 0;
    if (nonJustifiees) nonJustifiees.innerText = stats.nonJustifiees || 0;
    if (aujourdHui) aujourdHui.innerText = stats.ajourdHui || stats.absentsAujourdHui || 0;
    if (classeMax) classeMax.innerText = stats.classeMax || stats.classePlusTouchee || '-';
    if (eleveMax) eleveMax.innerText = stats.eleveMax || stats.elevePlusAbsent || '-';
}

/**
 * Réinitialise les filtres (recherche).
 */
function resetFilters() {
    document.getElementById("globalSearch").value = "";
    fetchAbsencesForCurrentClass();
    showToast("Filtres réinitialisés", "info");
}

// ==========================================================================
// Gestion de la fenêtre modale (Détails de l'absence)
// ==========================================================================

function openModal(id) {
    fetch(`${contextPath}/absence/api/${id}`)
        .then(response => response.json())
        .then(absence => {
            const eleve = absence.eleve || {};
            const classe = eleve.classe || {};
            
            // Gestion de la photo
            let photoPath = `${contextPath}/images/default-avatar.png`;
            if (eleve.photo) {
                photoPath = `${contextPath}/uploads/${eleve.photo}`;
            }
            
            document.getElementById("modalPhoto").src = photoPath;
            document.getElementById("modalNomComplet").innerText = `${eleve.nom || ''} ${eleve.prenom || ''}`;
            document.getElementById("modalMatricule").innerText = eleve.id_eleve || '-';
            document.getElementById("modalClasse").innerText = classe.nom || eleve.classe?.nom || 'N/A';
            document.getElementById("modalDate").innerText = absence.date_absence || 'N/A';
            document.getElementById("modalMotif").innerText = absence.motif || 'Non spécifié';
            
            const badge = document.getElementById("modalBadge");
            if (absence.justifie) {
                badge.className = "badge badge-success";
                badge.innerHTML = `<i class="fas fa-check-circle"></i> Justifiée`;
            } else {
                badge.className = "badge badge-danger";
                badge.innerHTML = `<i class="fas fa-exclamation-circle"></i> Non justifiée`;
            }
            
            document.getElementById("modalEnseignant").innerText = classe.utilisateur ? 
                (classe.utilisateur.username || classe.utilisateur.prenom + ' ' + classe.utilisateur.nom) : 'Administration';
            document.getElementById("modalDateEnregistrement").innerText = absence.dateEnregistrement || 'Non disponible';
            
            document.getElementById("absenceModal").style.display = "block";
        })
        .catch(error => console.error("Erreur lors du chargement de la modale :", error));
}

function closeModal() {
    document.getElementById("absenceModal").style.display = "none";
}

function notifierParent() {
    showToast("Fonctionnalité d'envoi de notification (Email/SMS) en cours de développement", "info");
}

// Gestion du clic en dehors du modal
window.onclick = function(event) {
    const modal = document.getElementById("absenceModal");
    if (event.target === modal) {
        modal.style.display = "none";
    }
}

// Initialisation au chargement de la page
document.addEventListener("DOMContentLoaded", function() {
    checkFlashMessages();
    loadClassesAndFetchAbsences();
});