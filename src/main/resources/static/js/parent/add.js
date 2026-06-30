/**
 * Gestion du formulaire d'ajout de parent
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM charge - Initialisation des validations');

    // Fonctions de validation - retourne true si le champ est valide OU vide
    function validateLetters(str) {
        if (!str || str.trim() === '') return true; // Champ vide = pas d'erreur
        const regex = /^[a-zA-ZÀ-ÿ\s\-']+$/;
        return regex.test(str);
    }

    function validatePhone(str) {
        if (!str || str.trim() === '') return true; // Champ vide = pas d'erreur
        const regex = /^[0-9+]+$/;
        return regex.test(str);
    }

    function validateEmail(str) {
        if (!str || str.trim() === '') return true; // Champ vide = pas d'erreur
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(str);
    }

    function validateNotEmpty(str) {
        if (!str || str.trim() === '') return false; // Vide = erreur (obligatoire)
        return true;
    }

    // Récupération des éléments
    const nomInput = document.getElementById('nom');
    const nomError = document.getElementById('nomError');
    const prenomInput = document.getElementById('prenom');
    const prenomError = document.getElementById('prenomError');
    const telephoneInput = document.getElementById('telephone');
    const telephoneError = document.getElementById('telephoneError');
    const emailInput = document.getElementById('email');
    const emailError = document.getElementById('emailError');
    const adresseInput = document.getElementById('adresse');
    const adresseError = document.getElementById('adresseError');
    const parentForm = document.getElementById('parentForm');

    // Validation du nom (lettres uniquement) - n'affiche pas d'erreur si vide
    if (nomInput) {
        nomInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value !== '' && !validateLetters(value)) {
                nomError.classList.add('show');
                this.classList.add('error');
            } else {
                nomError.classList.remove('show');
                this.classList.remove('error');
            }
        });
    }

    // Validation du prenom (lettres uniquement) - n'affiche pas d'erreur si vide
    if (prenomInput) {
        prenomInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value !== '' && !validateLetters(value)) {
                prenomError.classList.add('show');
                this.classList.add('error');
            } else {
                prenomError.classList.remove('show');
                this.classList.remove('error');
            }
        });
    }

    // Validation du telephone (chiffres et +) - n'affiche pas d'erreur si vide
    if (telephoneInput) {
        telephoneInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value !== '' && !validatePhone(value)) {
                telephoneError.classList.add('show');
                this.classList.add('error');
            } else {
                telephoneError.classList.remove('show');
                this.classList.remove('error');
            }
        });
    }

    // Validation de l'email - n'affiche pas d'erreur si vide
    if (emailInput) {
        emailInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value !== '' && !validateEmail(value)) {
                emailError.classList.add('show');
                this.classList.add('error');
            } else {
                emailError.classList.remove('show');
                this.classList.remove('error');
            }
        });
    }

    // Validation de l'adresse (non vide) - AFFICHE L'ERREUR SI VIDE
    if (adresseInput) {
        adresseInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (!validateNotEmpty(value)) {
                adresseError.classList.add('show');
                this.classList.add('error');
            } else {
                adresseError.classList.remove('show');
                this.classList.remove('error');
            }
        });
    }

    // Validation avant soumission
    if (parentForm) {
        parentForm.addEventListener('submit', function(e) {
            let isValid = true;
            let errorMessage = '';

            // Vérifier le nom (obligatoire et lettres)
            if (!nomInput.value.trim()) {
                isValid = false;
                errorMessage += '- Nom : obligatoire\n';
                nomError.classList.add('show');
                nomInput.classList.add('error');
            } else if (!validateLetters(nomInput.value)) {
                isValid = false;
                errorMessage += '- Nom : lettres uniquement (pas de caracteres speciaux)\n';
                nomError.classList.add('show');
                nomInput.classList.add('error');
            }

            // Vérifier le prenom (obligatoire et lettres)
            if (!prenomInput.value.trim()) {
                isValid = false;
                errorMessage += '- Prenom : obligatoire\n';
                prenomError.classList.add('show');
                prenomInput.classList.add('error');
            } else if (!validateLetters(prenomInput.value)) {
                isValid = false;
                errorMessage += '- Prenom : lettres uniquement\n';
                prenomError.classList.add('show');
                prenomInput.classList.add('error');
            }

            // Vérifier le telephone (obligatoire)
            if (!telephoneInput.value.trim()) {
                isValid = false;
                errorMessage += '- Telephone : obligatoire\n';
                telephoneError.classList.add('show');
                telephoneInput.classList.add('error');
            } else if (!validatePhone(telephoneInput.value)) {
                isValid = false;
                errorMessage += '- Telephone : chiffres et + uniquement\n';
                telephoneError.classList.add('show');
                telephoneInput.classList.add('error');
            }

            // Vérifier l'email (obligatoire)
            if (!emailInput.value.trim()) {
                isValid = false;
                errorMessage += '- Email : obligatoire\n';
                emailError.classList.add('show');
                emailInput.classList.add('error');
            } else if (!validateEmail(emailInput.value)) {
                isValid = false;
                errorMessage += '- Email : format invalide (exemple: nom@domaine.com)\n';
                emailError.classList.add('show');
                emailInput.classList.add('error');
            }

            // Vérifier l'adresse (obligatoire)
            if (!validateNotEmpty(adresseInput.value)) {
                isValid = false;
                errorMessage += '- Adresse : obligatoire\n';
                adresseError.classList.add('show');
                adresseInput.classList.add('error');
            }

            if (!isValid) {
                e.preventDefault();
                alert('Veuillez corriger les erreurs suivantes :\n\n' + errorMessage);
            }
        });
    }

    console.log('Validations initialisees');
});