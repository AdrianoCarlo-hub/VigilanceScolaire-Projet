<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<style>
    .img-thumbnail-custom {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #ddd;
        background: #34495e;
    }

    .clickable-row {
        cursor: pointer;
        transition: background 0.3s;
    }

    .clickable-row:hover {
        background-color: rgba(52, 152, 219, 0.1) !important;
    }

    /* Alert styles */
    .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 5px;
        animation: slideIn 0.5s;
    }

    @keyframes slideIn {
        from {
            transform: translateY(-20px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }

    .alert-success {
        background-color: #27ae60;
        color: white;
        border-left: 5px solid #2ecc71;
    }

    .alert-danger {
        background-color: #e74c3c;
        color: white;
        border-left: 5px solid #c0392b;
    }

    /* Modal amélioré */
    #eleveModal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.8);
        animation: fadeIn 0.3s;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    .modal-content {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        margin: 5% auto;
        padding: 30px;
        width: 60%;
        max-width: 700px;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        animation: slideDown 0.3s;
    }

    @keyframes slideDown {
        from {
            transform: translateY(-50px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }

    .close-btn {
        float: right;
        font-size: 32px;
        cursor: pointer;
        transition: transform 0.3s;
    }

    .close-btn:hover {
        transform: scale(1.1);
    }

    .modal-body {
        display: flex;
        gap: 30px;
        align-items: flex-start;
        margin-top: 20px;
    }

    .modal-img {
        width: 180px;
        height: 180px;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid white;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        background: #34495e;
    }

    .modal-info {
        flex: 1;
    }

    .modal-info p {
        margin: 12px 0;
        font-size: 16px;
        border-bottom: 1px solid rgba(255,255,255,0.2);
        padding-bottom: 8px;
    }

    .modal-info strong {
        display: inline-block;
        width: 140px;
        color: #ffd700;
    }

    .class-section {
        margin-bottom: 40px;
        background: rgba(255,255,255,0.05);
        border-radius: 15px;
        padding: 20px;
    }

    .class-title {
        color: #ffd700;
        font-size: 24px;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 3px solid #ffd700;
        display: inline-block;
    }

    .badge-count {
        background: #ffd700;
        color: #333;
        padding: 5px 12px;
        border-radius: 20px;
        margin-left: 15px;
        font-size: 14px;
    }

    .action-buttons {
        display: flex;
        gap: 10px;
    }

    .edit-link, .delete-link {
        padding: 5px 12px;
        border-radius: 5px;
        text-decoration: none;
        font-size: 12px;
        transition: all 0.3s;
        display: inline-block;
    }

    .edit-link {
        background: #3498db;
        color: white;
    }

    .edit-link:hover {
        background: #2980b9;
        color: white;
        transform: scale(1.05);
    }

    .delete-link {
        background: #e74c3c;
        color: white;
    }

    .delete-link:hover {
        background: #c0392b;
        color: white;
        transform: scale(1.05);
    }

    .no-data {
        text-align: center;
        padding: 50px;
        color: white;
    }

    .btn-add {
        background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
        color: white;
        padding: 10px 20px;
        border-radius: 25px;
        text-decoration: none;
        transition: transform 0.3s;
        display: inline-block;
    }

    .btn-add:hover {
        transform: translateY(-2px);
        color: white;
    }

    /* ========== NOUVEAUX STYLES POUR RECHERCHE ET EXPORTS ========== */
    .search-bar {
        margin-bottom: 20px;
        display: flex;
        gap: 15px;
        align-items: center;
        flex-wrap: wrap;
    }

    .search-input {
        flex: 1;
        padding: 10px 15px;
        border-radius: 25px;
        border: none;
        background: #34495e;
        color: white;
        font-size: 14px;
        min-width: 250px;
    }

    .search-input::placeholder {
        color: #aaa;
    }

    .search-input:focus {
        outline: none;
        border: 2px solid #ffd700;
    }

    .btn-clear {
        background: #666;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        transition: all 0.3s;
    }

    .btn-clear:hover {
        background: #888;
    }

    .btn-export {
        padding: 8px 15px;
        border-radius: 5px;
        text-decoration: none;
        display: inline-block;
        margin-left: 10px;
        font-size: 13px;
        transition: all 0.3s;
    }

    .btn-export-excel {
        background: #1e8449;
        color: white;
    }

    .btn-export-excel:hover {
        background: #27ae60;
        color: white;
    }

    .btn-export-pdf {
        background: #c0392b;
        color: white;
    }

    .btn-export-pdf:hover {
        background: #e74c3c;
        color: white;
    }

    .class-actions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        flex-wrap: wrap;
        gap: 10px;
    }

    .no-results {
        text-align: center;
        padding: 40px;
        color: white;
        background: rgba(255,255,255,0.1);
        border-radius: 15px;
        margin: 20px 0;
    }
</style>

<div class="main-layout">
    <div class="sidebar-container">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>
    <div class="content">
        <div class="custom-table-container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; flex-wrap: wrap; gap: 15px;">
                <h2 style="color:white; margin:0;">📚 Répertoire des Élèves</h2>

                <!-- Barre de recherche -->
                <div class="search-bar">
                    <input type="text" id="searchInput" class="search-input"
                           placeholder="🔍 Rechercher par nom, prénom ou matricule..."
                           onkeyup="filterEleves()">
                    <button onclick="clearSearch()" class="btn-clear">✖ Effacer</button>
                </div>

                <%-- SEUL L'ADMIN PEUT AJOUTER UN ÉLÈVE --%>
                <sec:authorize access="hasRole('ADMIN')">
                    <a href="${pageContext.request.contextPath}/eleve/add" class="btn-add">➕ Ajouter un Élève</a>
                </sec:authorize>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success">✅ ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">❌ ${error}</div>
            </c:if>

            <div id="elevesContainer">
                <c:if test="${empty elevesByClass}">
                    <div class="no-data">
                        <p>📭 Aucun élève trouvé pour votre profil</p>
                        <sec:authorize access="hasRole('ADMIN')">
                            <a href="${pageContext.request.contextPath}/eleve/add" class="btn-add">➕ Inscrire un élève</a>
                        </sec:authorize>
                    </div>
                </c:if>

                <c:forEach var="entry" items="${elevesByClass}">
                    <div class="class-section" data-classname="${entry.key}">
                        <div class="class-actions">
                            <h3 class="class-title">
                                📖 ${entry.key}
                                <span class="badge-count" id="count-${fn:replace(entry.key, ' ', '_')}">${fn:length(entry.value)} élèves</span>
                            </h3>
                            <div>
                                <c:if test="${not empty entry.value}">
                                    <c:set var="firstEleve" value="${entry.value[0]}"/>
                                    <c:if test="${not empty firstEleve.classe.id_classe}">
                                        <a href="/eleve/export/excel/${firstEleve.classe.id_classe}" class="btn-export btn-export-excel">📊 Export Excel</a>
                                        <a href="/eleve/export/pdf/${firstEleve.classe.id_classe}" class="btn-export btn-export-pdf">📄 Export PDF</a>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>

                        <table class="table-dark" id="table-${fn:replace(entry.key, ' ', '_')}">
                            <thead>
                                <tr>
                                    <th>PHOTO</th>
                                    <th>MATRICULE</th>
                                    <th>NOM & PRÉNOM</th>
                                    <th>SEXE</th>
                                    <th>DATE NAISSANCE</th>
                                    <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                        <th>ACTIONS</th>
                                    </sec:authorize>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="e" items="${entry.value}">
                                    <tr class="clickable-row" onclick="showDetails(${e.id_eleve})"
                                        data-nom="${e.nom}" data-prenom="${e.prenom}" data-matricule="${e.matricule}">
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${not empty e.photo}">
                                                    <img src="${pageContext.request.contextPath}/images/${e.photo}?t=${System.currentTimeMillis()}"
                                                         class="img-thumbnail-custom"
                                                         alt="Photo de ${e.nom}"
                                                         onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/images/default-avatar.png"
                                                         class="img-thumbnail-custom"
                                                         alt="Photo par défaut">
                                                </c:otherwise>
                                            </c:choose>
                                          </td>
                                          <td><strong>${e.matricule}</strong></td>
                                        <td class="product-name"><strong>${e.nom}</strong> ${e.prenom}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${e.sexe == 'M'}">👨 Masculin</c:when>
                                                <c:otherwise>👩 Féminin</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${e.date_naissance}</td>

                                        <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                            <td onclick="event.stopPropagation();" class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/eleve/edit/${e.id_eleve}" class="edit-link">🔄 Modifier</a>
                                                <sec:authorize access="hasRole('ADMIN')">
                                                    <a href="${pageContext.request.contextPath}/eleve/delete/${e.id_eleve}"
                                                       class="delete-link"
                                                       onclick="return confirm('⚠️ Supprimer définitivement ${e.nom} ${e.prenom} ?')">🗑️ Supprimer</a>
                                                </sec:authorize>
                                            </td>
                                        </sec:authorize>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- Modal Détails Élève -->
<div id="eleveModal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2 style="margin-top: 0;">👨‍🎓 Détails de l'élève</h2>
        <div class="modal-body">
            <img id="m-photo" class="modal-img" src="${pageContext.request.contextPath}/images/default-avatar.png" alt="Photo">
            <div class="modal-info">
                <p><strong>Nom complet :</strong> <span id="m-full-name"></span></p>
                <p><strong>Matricule :</strong> <span id="m-matricule"></span></p>
                <p><strong>Sexe :</strong> <span id="m-sexe"></span></p>
                <p><strong>Date naissance :</strong> <span id="m-date"></span></p>
                <p><strong>Classe :</strong> <span id="m-classe"></span></p>
                <p><strong>Parent :</strong> <span id="m-parent"></span></p>
                <p><strong>Email parent :</strong> <span id="m-parent-email"></span></p>
                <p><strong>Téléphone parent :</strong> <span id="m-parent-phone"></span></p>
            </div>
        </div>
    </div>
</div>

<script>
    function showDetails(eleveId) {
        fetch('${pageContext.request.contextPath}/eleve/api/' + eleveId)
            .then(response => response.json())
            .then(eleve => {
                document.getElementById('m-full-name').innerHTML = eleve.nom + " " + eleve.prenom;
                document.getElementById('m-matricule').innerText = eleve.matricule;
                document.getElementById('m-sexe').innerText = eleve.sexe === 'M' ? 'Masculin' : 'Féminin';
                document.getElementById('m-date').innerText = eleve.date_naissance;
                document.getElementById('m-classe').innerText = eleve.classe ? eleve.classe.nom : 'Non assigné';
                document.getElementById('m-parent').innerText = eleve.parent ? eleve.parent.nom + " " + eleve.parent.prenom : 'Non assigné';
                document.getElementById('m-parent-email').innerText = eleve.parent && eleve.parent.email ? eleve.parent.email : 'Non renseigné';
                document.getElementById('m-parent-phone').innerText = eleve.parent && eleve.parent.telephone ? eleve.parent.telephone : 'Non renseigné';

                let photoPath = '${pageContext.request.contextPath}/images/default-avatar.png';
                if (eleve.photo && eleve.photo.trim() !== '') {
                    photoPath = '${pageContext.request.contextPath}/images/' + eleve.photo + '?t=' + new Date().getTime();
                }
                document.getElementById('m-photo').src = photoPath;

                document.getElementById('eleveModal').style.display = "block";
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Erreur lors du chargement des détails');
            });
    }

    function closeModal() {
        document.getElementById('eleveModal').style.display = "none";
    }

    window.onclick = function(event) {
        let modal = document.getElementById('eleveModal');
        if (event.target == modal) closeModal();
    }

    // Rafraîchir les images après chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        const images = document.querySelectorAll('.img-thumbnail-custom');
        images.forEach(img => {
            const originalSrc = img.src.split('?')[0];
            img.src = originalSrc + '?t=' + new Date().getTime();
        });
    });

    // ========== FONCTIONS DE RECHERCHE ==========

    function filterEleves() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
        const classSections = document.querySelectorAll('.class-section');
        let totalVisible = 0;

        classSections.forEach(section => {
            const rows = section.querySelectorAll('tbody tr');
            let visibleCount = 0;

            rows.forEach(row => {
                const nom = (row.getAttribute('data-nom') || '').toLowerCase();
                const prenom = (row.getAttribute('data-prenom') || '').toLowerCase();
                const matricule = (row.getAttribute('data-matricule') || '').toLowerCase();
                const fullName = nom + ' ' + prenom;

                const matches = searchTerm === '' ||
                    nom.includes(searchTerm) ||
                    prenom.includes(searchTerm) ||
                    fullName.includes(searchTerm) ||
                    matricule.includes(searchTerm);

                if (matches) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            // Mettre à jour le compteur
            const badge = section.querySelector('.badge-count');
            if (badge) {
                badge.textContent = visibleCount + ' élèves';
            }

            // Afficher/masquer la section si aucun élève visible
            if (visibleCount === 0) {
                section.style.display = 'none';
            } else {
                section.style.display = '';
                totalVisible += visibleCount;
            }
        });

        // Afficher message si aucun résultat
        const container = document.getElementById('elevesContainer');
        let noResultsMsg = document.getElementById('noResultsMsg');

        if (totalVisible === 0 && searchTerm !== '') {
            if (!noResultsMsg) {
                noResultsMsg = document.createElement('div');
                noResultsMsg.id = 'noResultsMsg';
                noResultsMsg.className = 'no-results';
                noResultsMsg.innerHTML = '🔍 Aucun élève ne correspond à votre recherche : "' + searchTerm + '"';
                container.appendChild(noResultsMsg);
            } else {
                noResultsMsg.style.display = 'block';
                noResultsMsg.innerHTML = '🔍 Aucun élève ne correspond à votre recherche : "' + searchTerm + '"';
            }
        } else if (noResultsMsg) {
            noResultsMsg.style.display = 'none';
        }
    }

    function clearSearch() {
        document.getElementById('searchInput').value = '';
        filterEleves();
    }
</script>

<jsp:include page="../includes/footer.jsp" />