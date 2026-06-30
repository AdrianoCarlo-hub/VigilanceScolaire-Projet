/**
 * Gestion du formulaire d'ajout de classe
 */

// Variables globales
const nomInput = document.getElementById('nom');
const niveauSelect = document.getElementById('niveau');
const anneeInput = document.getElementById('annee_scolaire');
const professeurSelect = document.getElementById('professeur');
const formulaire = document.getElementById('classeForm');

// Éléments pour les messages d'erreur
const nomError = document.getElementById('nomError');
const anneeError = document.getElementById('anneeError');

/**
 * Vérifie si une chaîne contient des caractères spéciaux
 */
function hasSpecialCharacters(str) {
    if (!str) return false;
    const regex = /^[a-zA-ZÀ-ÿ0-9\s\-']+$/;
    return !regex.test(str);
}

/**
 * Nettoie le nom de la classe
 */
function sanitizeClassName(str) {
    if (!str) return '';
    return str.replace(/[^a-zA-ZÀ-ÿ0-9\s\-']/g, ' ');
}

/**
 * Valide le format de l'année scolaire
 */
function validateAnneeScolaire(annee) {
    if (!annee) return false;

    const regex = /^\d{4}-\d{4}$/;
    if (!regex.test(annee)) {
        return false;
    }

    const [debut, fin] = annee.split('-');
    const debutInt = parseInt(debut, 10);
    const finInt = parseInt(fin, 10);

    if (finInt !== debutInt + 1) {
        return false;
    }

    const anneeActuelle = new Date().getFullYear();
    if (debutInt < 2000 || debutInt > anneeActuelle + 5) {
        return false;
    }

    return true;
}

function validateNom() {
    let value = nomInput.value.trim();

    if (value === '') {
        nomError.classList.remove('show');
        nomInput.classList.remove('error');
        return true;
    }

    if (hasSpecialCharacters(value)) {
        nomError.classList.add('show');
        nomInput.classList.add('error');
        return false;
    } else {
        nomError.classList.remove('show');
        nomInput.classList.remove('error');
        return true;
    }
}

function cleanNom() {
    let value = nomInput.value;
    if (hasSpecialCharacters(value)) {
        const cleaned = sanitizeClassName(value);
        nomInput.value = cleaned;
    }
    validateNom();
}

function validateAnnee() {
    let value = anneeInput.value.trim();

    if (value === '') {
        anneeError.classList.remove('show');
        anneeInput.classList.remove('error');
        return false;
    }

    if (!validateAnneeScolaire(value)) {
        anneeError.classList.add('show');
        anneeInput.classList.add('error');
        return false;
    } else {
        anneeError.classList.remove('show');
        anneeInput.classList.remove('error');
        return true;
    }
}

function formatAnneeScolaire() {
    let value = anneeInput.value.replace(/[^0-9-]/g, '');

    const parts = value.split('-');
    if (parts.length > 2) {
        value = parts[0] + '-' + parts[1];
    }

    if (value.length > 9) {
        value = value.substring(0, 9);
    }

    anneeInput.value = value;
    validateAnnee();
}

function initNiveauSelect() {
    const niveaux = [
        { value: "", text: "-- Sélectionner un niveau --" },
        { value: "Primaire", text: "🏫 Primaire" },
        { value: "Collège", text: "📚 Collège" },
        { value: "Lycée", text: "🎓 Lycée" }
    ];

    niveauSelect.innerHTML = '';
    niveaux.forEach(niveau => {
        const option = document.createElement('option');
        option.value = niveau.value;
        option.textContent = niveau.text;
        niveauSelect.appendChild(option);
    });
}

/**
 * Initialise Select2 pour la recherche de professeur
 */
function initSelect2Professeur() {
    if (typeof $ !== 'undefined' && professeurSelect) {
        $(professeurSelect).select2({
            placeholder: "-- Sélectionner un professeur principal --",
            allowClear: true,
            width: '100%',
            language: {
                noResults: function() {
                    return "Aucun professeur trouvé";
                },
                searching: function() {
                    return "Recherche...";
                }
            }
        });
    }
}

/**
 * Validation globale du formulaire
 */
function validateForm() {
    const nom = nomInput.value.trim();
    const niveau = niveauSelect.value;
    const annee = anneeInput.value.trim();

    if (nom === '') {
        alert('⚠️ Veuillez saisir un nom de classe.');
        nomInput.focus();
        return false;
    }

    if (hasSpecialCharacters(nom)) {
        alert('⚠️ Le nom de la classe contient des caractères non autorisés.');
        nomInput.focus();
        return false;
    }

    if (niveau === '') {
        alert('⚠️ Veuillez sélectionner un niveau.');
        niveauSelect.focus();
        return false;
    }

    if (annee === '') {
        alert('⚠️ Veuillez saisir une année scolaire.');
        anneeInput.focus();
        return false;
    }

    if (!validateAnneeScolaire(annee)) {
        alert('⚠️ Format d\'année scolaire invalide. Utilisez le format: 2024-2025');
        anneeInput.focus();
        return false;
    }

    return true;
}

// Événements
document.addEventListener('DOMContentLoaded', function() {
    // Initialiser le select des niveaux
    initNiveauSelect();

    // Initialiser Select2 pour le professeur
    initSelect2Professeur();

    if (nomInput) {
        nomInput.addEventListener('input', cleanNom);
        nomInput.addEventListener('blur', validateNom);
        validateNom();
    }

    if (anneeInput) {
        anneeInput.addEventListener('input', formatAnneeScolaire);
        anneeInput.addEventListener('blur', validateAnnee);
        validateAnnee();
    }

    if (formulaire) {
        formulaire.addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
            }
        });
    }

    console.log('Formulaire d\'ajout de classe initialisé');
});