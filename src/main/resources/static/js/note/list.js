let currentClassIndex = 0;
let classSections = [];
let sortDirections = {};

document.addEventListener('DOMContentLoaded', function() {
    classSections = Array.from(document.querySelectorAll('.class-section'));
    if (classSections.length > 0) {
        showClass(currentClassIndex);
    } else {
        const paginationBar = document.querySelector('.pagination-bar');
        if (paginationBar) paginationBar.style.display = 'none';
    }
});

function filterNotes() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
    let totalVisible = 0;

    classSections.forEach(section => {
        const rows = section.querySelectorAll('tbody tr');
        let visibleCount = 0;

        rows.forEach(row => {
            const eleve = (row.getAttribute('data-eleve') || '').toLowerCase();
            const classe = (row.getAttribute('data-classe') || '').toLowerCase();
            const matiere = (row.getAttribute('data-matiere') || '').toLowerCase();

            const matches = searchTerm === '' ||
                eleve.includes(searchTerm) ||
                classe.includes(searchTerm) ||
                matiere.includes(searchTerm);

            if (matches) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        const badge = section.querySelector('.badge-count');
        if (badge) {
            badge.textContent = visibleCount + ' notes';
        }

        if (visibleCount === 0) {
            section.style.display = 'none';
        } else {
            section.style.display = '';
            totalVisible += visibleCount;
        }
    });

    const container = document.getElementById('notesContainer');
    let noResultsMsg = document.getElementById('noResultsMsg');

    if (totalVisible === 0 && searchTerm !== '') {
        if (!noResultsMsg) {
            noResultsMsg = document.createElement('div');
            noResultsMsg.id = 'noResultsMsg';
            noResultsMsg.className = 'no-results';
            noResultsMsg.innerHTML = '<i class="fas fa-search-minus"></i> Aucune note ne correspond au critère : "' + searchTerm + '"';
            container.appendChild(noResultsMsg);
        } else {
            noResultsMsg.style.display = 'block';
            noResultsMsg.innerHTML = '<i class="fas fa-search-minus"></i> Aucune note ne correspond au critère : "' + searchTerm + '"';
        }
    } else if (noResultsMsg) {
        noResultsMsg.style.display = 'none';
    }

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
    filterNotes();
}

function showClass(index) {
    classSections.forEach((section, i) => {
        if (i === index) {
            section.style.display = '';
            const className = section.getAttribute('data-classname');
            document.getElementById('pageIndicator').innerText = 'Classe : ' + className;

            const countBadge = section.querySelector('.badge-count');
            const countText = countBadge ? countBadge.innerText : '0 note';
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

function sortTable(tableId, colIndex) {
    const table = document.getElementById(tableId);
    if (!table) return;

    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));

    sortDirections[tableId] = sortDirections[tableId] || {};
    sortDirections[tableId][colIndex] = !sortDirections[tableId][colIndex];
    const asc = sortDirections[tableId][colIndex];

    rows.sort((a, b) => {
        const cellA = a.children[colIndex].innerText.trim().toLowerCase();
        const cellB = b.children[colIndex].innerText.trim().toLowerCase();

        // Si colonne Note (index 3), format "XX / 20"
        if (colIndex === 3) {
            const valA = parseFloat(cellA.split('/')[0]) || 0;
            const valB = parseFloat(cellB.split('/')[0]) || 0;
            return asc ? valA - valB : valB - valA;
        }

        return asc ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
    });

    rows.forEach(row => tbody.appendChild(row));
}