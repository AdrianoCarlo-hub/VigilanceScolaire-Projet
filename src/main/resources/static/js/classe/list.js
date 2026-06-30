/**
 * Gestion de la page Liste des Classes
 */

// Variables globales
let currentSortColumn = null;
let currentSortOrder = 'asc';

/**
 * Affiche un toast (notification)
 */
function showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');
    if (!container) return;
    
    const toast = document.createElement('div');
    toast.className = `toast-notification toast-${type}`;
    
    let icon = '';
    switch(type) {
        case 'success': icon = '<i class="fas fa-check-circle"></i>'; break;
        case 'error': icon = '<i class="fas fa-exclamation-circle"></i>'; break;
        default: icon = '<i class="fas fa-info-circle"></i>';
    }
    
    toast.innerHTML = `${icon} <span>${message}</span>`;
    container.appendChild(toast);
    
    // Disparition après 6 secondes
    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 300);
    }, 6000);
}

/**
 * Vérifie et affiche les messages flash au chargement de la page
 */
function checkFlashMessages() {
    // Récupérer les messages depuis les attributs data
    const successMsg = document.body.getAttribute('data-success');
    const errorMsg = document.body.getAttribute('data-error');

    if (successMsg && successMsg !== '' && successMsg !== 'null') {
        showToast(successMsg, 'success');
        // Nettoyer l'attribut pour ne pas réafficher
        document.body.removeAttribute('data-success');
    }
    if (errorMsg && errorMsg !== '' && errorMsg !== 'null') {
        showToast(errorMsg, 'error');
        document.body.removeAttribute('data-error');
    }
}

/**
 * Trie le tableau par colonne
 */
function sortTable(column) {
    const tbody = document.getElementById('classeTableBody');
    if (!tbody) return;

    const rows = Array.from(tbody.querySelectorAll('tr:not(.no-result-row)'));

    // Inverser l'ordre si même colonne
    if (currentSortColumn === column) {
        currentSortOrder = currentSortOrder === 'asc' ? 'desc' : 'asc';
    } else {
        currentSortColumn = column;
        currentSortOrder = 'asc';
    }

    // Mettre à jour les icônes
    updateSortIcons(column);

    // Trier les lignes
    rows.sort((a, b) => {
        let aVal, bVal;

        switch(column) {
            case 'id':
                aVal = parseInt(a.getAttribute('data-id')) || 0;
                bVal = parseInt(b.getAttribute('data-id')) || 0;
                break;
            case 'nom':
                aVal = (a.getAttribute('data-nom') || '').toLowerCase();
                bVal = (b.getAttribute('data-nom') || '').toLowerCase();
                break;
            case 'niveau':
                aVal = (a.getAttribute('data-niveau') || '').toLowerCase();
                bVal = (b.getAttribute('data-niveau') || '').toLowerCase();
                break;
            case 'annee':
                aVal = (a.getAttribute('data-annee') || '').toLowerCase();
                bVal = (b.getAttribute('data-annee') || '').toLowerCase();
                break;
            default:
                return 0;
        }

        if (aVal < bVal) return currentSortOrder === 'asc' ? -1 : 1;
        if (aVal > bVal) return currentSortOrder === 'asc' ? 1 : -1;
        return 0;
    });

    // Réinsérer les lignes triées
    rows.forEach(row => tbody.appendChild(row));
}

/**
 * Met à jour les icônes de tri
 */
function updateSortIcons(column) {
    const icons = {
        id: document.getElementById('sort-id-icon'),
        nom: document.getElementById('sort-nom-icon'),
        niveau: document.getElementById('sort-niveau-icon'),
        annee: document.getElementById('sort-annee-icon')
    };

    // Réinitialiser toutes les icônes
    Object.values(icons).forEach(icon => {
        if (icon) {
            icon.className = 'fas fa-sort';
        }
    });

    // Mettre à jour l'icône active
    const activeIcon = icons[column];
    if (activeIcon) {
        activeIcon.className = currentSortOrder === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';
    }
}

/**
 * Filtre les classes par recherche
 */
function filterClasses() {
    const searchInput = document.getElementById('searchInput');
    if (!searchInput) return;

    const searchTerm = searchInput.value.toLowerCase();
    const tbody = document.getElementById('classeTableBody');
    if (!tbody) return;

    const rows = Array.from(tbody.querySelectorAll('tr:not(.no-result-row)'));
    let visibleCount = 0;

    rows.forEach(row => {
        const nom = (row.getAttribute('data-nom') || '').toLowerCase();
        const niveau = (row.getAttribute('data-niveau') || '').toLowerCase();
        const annee = (row.getAttribute('data-annee') || '').toLowerCase();
        const prof = (row.getAttribute('data-prof') || '').toLowerCase();

        if (nom.includes(searchTerm) || niveau.includes(searchTerm) ||
            annee.includes(searchTerm) || prof.includes(searchTerm)) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });

    // Gérer l'affichage du message "aucun résultat"
    const noResultRow = tbody.querySelector('.no-result-row');

    if (visibleCount === 0 && rows.length > 0) {
        if (!noResultRow) {
            const tr = document.createElement('tr');
            tr.className = 'no-result-row';
            tr.innerHTML = `
                <td colspan="6" style="text-align: center; padding: 40px;">
                    <i class="fas fa-search fa-3x" style="color: rgba(255,255,255,0.3);"></i>
                    <p style="margin-top: 15px;">Aucune classe ne correspond à votre recherche</p>
                </td>
            `;
            tbody.appendChild(tr);
        }
    } else if (noResultRow) {
        noResultRow.remove();
    }
}

/**
 * Réinitialise les filtres de recherche
 */
function resetFilters() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.value = '';
    }
    filterClasses();
}

/**
 * Initialisation de la page
 */
function init() {
    console.log('Page Liste des Classes initialisée');

    // Vérifier les messages flash
    checkFlashMessages();

    // Vérifier si l'URL contient des paramètres de message (alternative)
    const urlParams = new URLSearchParams(window.location.search);
    const success = urlParams.get('success');
    const error = urlParams.get('error');

    if (success) {
        showToast(decodeURIComponent(success), 'success');
        // Nettoyer l'URL
        window.history.replaceState({}, document.title, window.location.pathname);
    }
    if (error) {
        showToast(decodeURIComponent(error), 'error');
        window.history.replaceState({}, document.title, window.location.pathname);
    }
}

// Exécuter l'initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', init);