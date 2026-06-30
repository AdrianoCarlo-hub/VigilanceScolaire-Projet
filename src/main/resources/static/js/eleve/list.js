let currentClassIndex = 0;
let classSections = [];
let sortDirections = {};

document.addEventListener('DOMContentLoaded', function() {
    // Initialisation des images par défaut
    const images = document.querySelectorAll('.img-thumbnail-custom');
    images.forEach(img => {
        const currentSrc = img.src;
        if (!currentSrc.includes('default-avatar.png') && !currentSrc.includes('?t=')) {
            img.src = currentSrc + '?t=' + new Date().getTime();
        }
    });

    // Pagination par classe
    classSections = Array.from(document.querySelectorAll('.class-section'));
    if (classSections.length > 0) {
        showClass(currentClassIndex);
    } else {
        document.querySelector('.pagination-bar').style.display = 'none';
    }
});

function showDetails(eleveId) {
    fetch(contextPath + '/eleve/api/' + eleveId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Erreur HTTP réseau : statut ' + response.status);
            }
            return response.json();
        })
        .then(eleve => {
            document.getElementById('m-full-name').innerHTML = "<strong>" + eleve.nom.toUpperCase() + "</strong> " + eleve.prenom;
            document.getElementById('m-id').innerText = eleve.id_eleve;
            document.getElementById('m-sexe').innerText = eleve.sexe === 'M' ? 'Masculin' : 'Féminin';
            document.getElementById('m-date').innerText = eleve.date_naissance;
            document.getElementById('m-classe').innerText = eleve.classe ? eleve.classe.nom : 'Non assigné';
            document.getElementById('m-parent').innerText = eleve.parent ? eleve.parent.nom.toUpperCase() + " " + eleve.parent.prenom : 'Non assigné';
            document.getElementById('m-parent-email').innerText = eleve.parent && eleve.parent.email ? eleve.parent.email : 'Non renseigné';
            document.getElementById('m-parent-phone').innerText = eleve.parent && eleve.parent.telephone ? eleve.parent.telephone : 'Non renseigné';

            let photoPath = contextPath + '/images/default-avatar.png';
            if (eleve.photo && eleve.photo.trim() !== '') {
                photoPath = contextPath + '/images/' + eleve.photo;
            }

            const modalPhoto = document.getElementById('m-photo');
            modalPhoto.src = photoPath + '?t=' + new Date().getTime();
            document.getElementById('eleveModal').style.display = "block";
        })
        .catch(error => {
            console.error('Erreur lors du traitement API:', error);
            alert('Impossible de charger les spécifications de cet élève. Vérifiez vos droits d\'accès.');
        });
}

function closeModal() {
    document.getElementById('eleveModal').style.display = "none";
}

window.onclick = function(event) {
    let modal = document.getElementById('eleveModal');
    if (event.target == modal) closeModal();
}

// Recherche instantanée / Filtrage
function filterEleves() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
    let totalVisible = 0;

    classSections.forEach(section => {
        const rows = section.querySelectorAll('tbody tr');
        let visibleCount = 0;

        rows.forEach(row => {
            const nom = (row.getAttribute('data-nom') || '').toLowerCase();
            const prenom = (row.getAttribute('data-prenom') || '').toLowerCase();
            const idEleve = (row.getAttribute('data-id') || '').toLowerCase();
            const fullName = nom + ' ' + prenom;

            const matches = searchTerm === '' ||
                nom.includes(searchTerm) ||
                prenom.includes(searchTerm) ||
                fullName.includes(searchTerm) ||
                idEleve.includes(searchTerm);

            if (matches) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        const badge = section.querySelector('.badge-count');
        if (badge) {
            badge.textContent = visibleCount + ' élèves';
        }

        if (visibleCount === 0) {
            section.style.display = 'none';
        } else {
            section.style.display = '';
            totalVisible += visibleCount;
        }
    });

    const container = document.getElementById('elevesContainer');
    let noResultsMsg = document.getElementById('noResultsMsg');

    if (totalVisible === 0 && searchTerm !== '') {
        if (!noResultsMsg) {
            noResultsMsg = document.createElement('div');
            noResultsMsg.id = 'noResultsMsg';
            noResultsMsg.className = 'no-results';
            noResultsMsg.style.padding = '20px';
            noResultsMsg.style.textAlign = 'center';
            noResultsMsg.style.color = '#e74c3c';
            noResultsMsg.innerHTML = '<i class="fas fa-search-minus"></i> Aucun élève ne correspond au critère : "' + searchTerm + '"';
            container.appendChild(noResultsMsg);
        } else {
            noResultsMsg.style.display = 'block';
            noResultsMsg.innerHTML = '<i class="fas fa-search-minus"></i> Aucun élève ne correspond au critère : "' + searchTerm + '"';
        }
    } else if (noResultsMsg) {
        noResultsMsg.style.display = 'none';
    }

    // Réajuste la visibilité de la pagination si recherche active, ou réaffiche la classe courante
    if (searchTerm !== '') {
        classSections.forEach(sec => sec.style.display = '');
        document.querySelector('.pagination-bar').style.display = 'none';
    } else {
        document.querySelector('.pagination-bar').style.display = 'flex';
        showClass(currentClassIndex);
    }
}

function clearSearch() {
    document.getElementById('searchInput').value = '';
    filterEleves();
}

// Pagination des blocs de classes
function showClass(index) {
    classSections.forEach((section, i) => {
        if (i === index) {
            section.style.display = '';
            const className = section.getAttribute('data-classname');
            document.getElementById('pageIndicator').innerText = 'Classe : ' + className;

            const countBadge = section.querySelector('.badge-count');
            const countText = countBadge ? countBadge.innerText : '0 élève';
            document.getElementById('classCount').innerText = '(' + countText + ')';
        } else {
            section.style.display = 'none';
        }
    });

    document.getElementById('prevPageBtn').disabled = (index === 0);
    document.getElementById('nextPageBtn').disabled = (index === classSections.length - 1);
}

function navigateClass(direction) {
    let newIndex = currentClassIndex + direction;
    if (newIndex >= 0 && newIndex < classSections.length) {
        currentClassIndex = newIndex;
        showClass(currentClassIndex);
    }
}

// Tri des colonnes du tableau
function sortTable(tableId, colIndex) {
    const table = document.getElementById(tableId);
    if (!table) return;

    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));

    // Alterne la direction du tri
    sortDirections[tableId] = sortDirections[tableId] || {};
    sortDirections[tableId][colIndex] = !sortDirections[tableId][colIndex];
    const asc = sortDirections[tableId][colIndex];

    rows.sort((a, b) => {
        const cellA = a.children[colIndex].innerText.trim().toLowerCase();
        const cellB = b.children[colIndex].innerText.trim().toLowerCase();

        // Si c'est l'ID (colonne 1), tri numérique
        if (colIndex === 1) {
            return asc ? parseInt(cellA.replace('#', '')) - parseInt(cellB.replace('#', '')) : parseInt(cellB.replace('#', '')) - parseInt(cellA.replace('#', ''));
        }

        return asc ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
    });

    // Réinsère les lignes triées
    rows.forEach(row => tbody.appendChild(row));
}