/**
 * Gestion du formulaire de modification de parent
 */

// Attendre que le DOM soit complètement chargé
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM chargé - Initialisation des validations');

    // Fonctions de validation
    function validateLetters(str) {
        const regex = /^[a-zA-ZÀ-ÿ\s\-']+$/;
        return regex.test(str);
    }

    function validatePhone(str) {
        const regex = /^[0-9+]+$/;
        return regex.test(str);
    }

    function validateEmail(str) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(str);
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

    // Validation du nom
    if (nomInput) {
        nomInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value === '') {
                nomError.classList.add('show');
                this.classList.add('error');
            } else if (!validateLetters(value)) {
                nomError.classList.add('show');
                this.classList.add('error');
            } else {
                nomError.classList.remove('show');
                this.classList.remove('error');
            }
        });
        nomInput.dispatchEvent(new Event('input'));
    }

    // Validation du prenom
    if (prenomInput) {
        prenomInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value === '') {
                prenomError.classList.add('show');
                this.classList.add('error');
            } else if (!validateLetters(value)) {
                prenomError.classList.add('show');
                this.classList.add('error');
            } else {
                prenomError.classList.remove('show');
                this.classList.remove('error');
            }
        });
        prenomInput.dispatchEvent(new Event('input'));
    }

    // Validation du telephone
    if (telephoneInput) {
        telephoneInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value === '') {
                telephoneError.classList.add('show');
                this.classList.add('error');
            } else if (!validatePhone(value)) {
                telephoneError.classList.add('show');
                this.classList.add('error');
            } else {
                telephoneError.classList.remove('show');
                this.classList.remove('error');
            }
        });
        telephoneInput.dispatchEvent(new Event('input'));
    }

    // Validation de l'email
    if (emailInput) {
        emailInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value === '') {
                emailError.classList.add('show');
                this.classList.add('error');
            } else if (!validateEmail(value)) {
                emailError.classList.add('show');
                this.classList.add('error');
            } else {
                emailError.classList.remove('show');
                this.classList.remove('error');
            }
        });
        emailInput.dispatchEvent(new Event('input'));
    }

    // Validation de l'adresse
    if (adresseInput) {
        adresseInput.addEventListener('input', function() {
            const value = this.value.trim();
            if (value === '') {
                adresseError.classList.add('show');
                this.classList.add('error');
            } else {
                adresseError.classList.remove('show');
                this.classList.remove('error');
            }
        });
        adresseInput.dispatchEvent(new Event('input'));
    }

    // Validation avant soumission
    if (parentForm) {
        parentForm.addEventListener('submit', function(e) {
            let isValid = true;

            if (!nomInput.value.trim() || !validateLetters(nomInput.value)) isValid = false;
            if (!prenomInput.value.trim() || !validateLetters(prenomInput.value)) isValid = false;
            if (!telephoneInput.value.trim() || !validatePhone(telephoneInput.value)) isValid = false;
            if (!emailInput.value.trim() || !validateEmail(emailInput.value)) isValid = false;
            if (!adresseInput.value.trim()) isValid = false;

            if (!isValid) {
                e.preventDefault();
                alert('Veuillez corriger les erreurs dans le formulaire');
            }
        });
    }

    console.log('Validations initialisees');
});