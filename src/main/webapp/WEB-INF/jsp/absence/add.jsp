<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header_form.jsp" />

<style>
    .form-container {
        max-width: 800px;
        margin: 0 auto;
        background: #1a252f;
        padding: 20px;
        border-radius: 10px;
    }
    .form-group {
        margin-bottom: 20px;
    }
    label {
        display: block;
        margin-bottom: 8px;
        color: white;
        font-weight: bold;
    }
    .form-control {
        width: 100%;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ddd;
        background: #34495e;
        color: white;
    }
    .form-control:focus {
        outline: none;
        border-color: #ffd700;
    }
    .btn-submit {
        background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        font-size: 16px;
        transition: transform 0.3s;
        width: 100%;
    }
    .btn-submit:hover {
        transform: translateY(-2px);
    }
    .btn-back {
        display: inline-block;
        margin-bottom: 20px;
        color: #ffd700;
        text-decoration: none;
    }
    .btn-back:hover {
        color: #fff;
    }
    h2 {
        color: white;
        margin-bottom: 20px;
    }
    .info-note {
        background: #1a252f;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 20px;
        color: #ffd700;
        font-size: 14px;
        border-left: 3px solid #ffd700;
    }
    select.form-control {
        cursor: pointer;
    }
    option {
        background: #34495e;
        color: white;
    }
    .checkbox-group {
        display: flex;
        align-items: center;
        gap: 10px;
        color: white;
        margin-top: 15px;
    }
    .checkbox-group input {
        width: 18px;
        height: 18px;
        cursor: pointer;
    }
    .checkbox-group label {
        margin-bottom: 0;
        cursor: pointer;
    }
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/absence" class="btn-back">← Retour à la liste</a>
    <h2>📝 Enregistrer une Absence</h2>

    <sec:authorize access="hasRole('PROFESSEUR')">
        <div class="info-note">
            ℹ️ En tant que Professeur, vous ne voyez que vos propres classes.
        </div>
    </sec:authorize>

    <form id="absenceForm" action="${pageContext.request.contextPath}/absence/save" method="post">

        <div class="form-group">
            <label>📚 1. Choisir la classe</label>
            <select id="classeSelect" class="form-control" required>
                <option value="">-- Sélectionner une classe --</option>
                <c:forEach var="cl" items="${classes}">
                    <option value="${cl.id_classe}">${cl.nom} - ${cl.niveau}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>👨‍🎓 2. Choisir l'élève absent</label>
            <select id="eleveSelect" name="eleve.id_eleve" class="form-control" required disabled>
                <option value="">-- Choisissez d'abord une classe --</option>
            </select>
        </div>

        <div class="form-group">
            <label>📅 3. Date de l'absence</label>
            <input type="date" name="date_absence" class="form-control" id="dateAbsence" required>
        </div>

        <div class="form-group">
            <label>📝 4. Motif de l'absence</label>
            <input type="text" name="motif" id="motif" class="form-control" value="Inconnu" placeholder="Ex: Raisons médicales, Rendez-vous...">
        </div>

        <div class="checkbox-group">
            <input type="checkbox" name="justifie" id="justifie" value="true">
            <label for="justifie">✅ L'absence est-elle justifiée ?</label>
        </div>

        <button type="submit" class="btn-submit">✅ Valider l'absence</button>
    </form>
</div>

<script>
    // Date du jour par défaut
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('dateAbsence').value = today;

    const classeSelect = document.getElementById('classeSelect');
    const eleveSelect = document.getElementById('eleveSelect');
    const motifInput = document.getElementById('motif');
    const justifieCheckbox = document.getElementById('justifie');

    // Gestion de la case "justifiée"
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

    // Chargement des élèves quand la classe change
    classeSelect.addEventListener('change', function() {
        const classeId = this.value;

        if (!classeId) {
            eleveSelect.innerHTML = '<option value="">-- Choisissez d\'abord une classe --</option>';
            eleveSelect.disabled = true;
            return;
        }

        eleveSelect.innerHTML = '<option value="">⏳ Chargement des élèves...</option>';
        eleveSelect.disabled = true;

        fetch('${pageContext.request.contextPath}/eleve/byClasse/' + classeId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Erreur HTTP: ' + response.status);
                }
                return response.json();
            })
            .then(eleves => {
                console.log('Élèves reçus:', eleves);

                if (!eleves || eleves.length === 0) {
                    eleveSelect.innerHTML = '<option value="">📭 Aucun élève dans cette classe</option>';
                    eleveSelect.disabled = true;
                    return;
                }

                eleveSelect.innerHTML = '<option value="">-- Sélectionner un élève --</option>';

                for (let i = 0; i < eleves.length; i++) {
                    const eleve = eleves[i];
                    const id = eleve.id_eleve || eleve.id;
                    const matricule = eleve.matricule || '';
                    const nom = eleve.nom || '';
                    const prenom = eleve.prenom || '';

                    const option = document.createElement('option');
                    option.value = id;
                    option.textContent = `${id} - ${matricule} - ${nom} ${prenom}`;
                    eleveSelect.appendChild(option);
                }

                eleveSelect.disabled = false;
            })
            .catch(error => {
                console.error('Erreur:', error);
                eleveSelect.innerHTML = '<option value="">❌ Erreur de chargement</option>';
                eleveSelect.disabled = true;
            });
    });

    // Validation avant soumission
    document.getElementById('absenceForm').addEventListener('submit', function(e) {
        if (!eleveSelect.value) {
            e.preventDefault();
            alert('❌ Veuillez sélectionner un élève avant de valider l\'absence.');
            return false;
        }

        if (!motifInput.value || motifInput.value.trim() === '') {
            motifInput.value = 'Inconnu';
        }

        // Si motif = Inconnu, décocher justifié
        if (motifInput.value.trim() === 'Inconnu') {
            justifieCheckbox.checked = false;
        }

        return true;
    });
</script>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>