<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="list.css" %>

    /* Style pour les boutons de tri et pagination ajoutés */
    .table-dark th {
        cursor: pointer;
        user-select: none;
    }
    .table-dark th:hover {
        background: #34495e;
    }
    .pagination-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #22313f;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        margin-top: 25px;
    }
    .pagination-bar button {
        padding: 10px 20px;
        background-color: #2c3e50;
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 25px;
        cursor: pointer;
        font-weight: bold;
        transition: all 0.2s;
    }
    .pagination-bar button:hover:not(:disabled) {
        background-color: #00d4ff;
        color: #1a252f;
        border-color: #00d4ff;
    }
    .pagination-bar button:disabled {
        opacity: 0.4;
        cursor: not-allowed;
    }

    /* Animation de disparition du toast */
    .alert {
        transition: opacity 0.5s ease;
    }
</style>

<div class="main-layout">
    <div class="sidebar-container">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div class="content">
        <div class="custom-table-container">

            <div class="dashboard-header">
                <h2><i class="fas fa-graduation-cap"></i> Répertoire des Élèves</h2>

                <div class="search-bar">
                    <input type="text" id="searchInput" class="search-input"
                           placeholder="Rechercher par nom, prénom ou ID..."
                           onkeyup="filterEleves()">
                    <button onclick="clearSearch()" class="btn-clear">
                        <i class="fas fa-times"></i> Effacer
                    </button>
                </div>

                <sec:authorize access="hasRole('ADMIN')">
                    <a href="${pageContext.request.contextPath}/eleve/add" class="btn-add">
                        <i class="fas fa-user-plus"></i> Ajouter un Élève
                    </a>
                </sec:authorize>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <div id="elevesContainer">
                <c:if test="${empty elevesByClass}">
                    <div class="no-data">
                        <p><i class="fas fa-folder-open"></i> Aucun élève trouvé pour votre profil enseignant ou administratif</p>
                        <sec:authorize access="hasRole('ADMIN')">
                            <a href="${pageContext.request.contextPath}/eleve/add" class="btn-add">
                                <i class="fas fa-user-plus"></i> Inscrire un premier élève
                            </a>
                        </sec:authorize>
                    </div>
                </c:if>

                <c:forEach var="entry" items="${elevesByClass}">
                    <div class="class-section" data-classname="${entry.key}">
                        <div class="class-actions">
                            <h3 class="class-title">
                                <i class="fas fa-book"></i> Classe : ${entry.key}
                                <span class="badge-count" id="count-${fn:replace(entry.key, ' ', '_')}">${fn:length(entry.value)} élèves</span>
                            </h3>

                            <div>
                                <c:if test="${not empty entry.value}">
                                    <c:set var="firstEleve" value="${entry.value[0]}"/>
                                    <c:if test="${not empty firstEleve.classe.id_classe}">
                                        <a href="${pageContext.request.contextPath}/eleve/export/excel/${firstEleve.classe.id_classe}" class="btn-export btn-export-excel">
                                            <i class="fas fa-file-excel"></i> Export Excel
                                        </a>
                                        <a href="${pageContext.request.contextPath}/eleve/export/pdf/${firstEleve.classe.id_classe}" class="btn-export btn-export-pdf">
                                            <i class="fas fa-file-pdf"></i> Export PDF
                                        </a>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>

                        <table class="table-dark" id="table-${fn:replace(entry.key, ' ', '_')}">
                            <thead>
                            <tr>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 0)">PHOTO <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 1)">ID <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 2)">NOM & PRÉNOM <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 3)">SEXE <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 4)">DATE NAISSANCE <i class="fas fa-sort"></i></th>
                                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                    <th>ACTIONS</th>
                                </sec:authorize>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="e" items="${entry.value}">
                                <tr class="clickable-row" onclick="showDetails(${e.id_eleve})"
                                    data-nom="${e.nom}" data-prenom="${e.prenom}" data-id="${e.id_eleve}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty e.photo}">
                                                <img src="${pageContext.request.contextPath}/uploads/${e.photo}"
                                                     class="img-thumbnail-custom"
                                                     alt="Photo"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-avatar.png';">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/default-avatar.png" class="img-thumbnail-custom" alt="Avatar">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>#${e.id_eleve}</strong></td>
                                    <td class="product-name"><strong>${e.nom.toUpperCase()}</strong> ${e.prenom}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${e.sexe == 'M'}">Masculin</c:when>
                                            <c:otherwise>Féminin</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${e.date_naissance}</td>

                                    <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                        <td onclick="event.stopPropagation();" class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/eleve/edit/${e.id_eleve}" class="edit-link">
                                                <i class="fas fa-sync"></i> Modifier
                                            </a>
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <a href="${pageContext.request.contextPath}/eleve/delete/${e.id_eleve}"
                                                   class="delete-link"
                                                   onclick="return confirm('⚠️ Supprimer définitivement l\'élève ${e.nom} ${e.prenom} ?')">
                                                    <i class="fas fa-trash-alt"></i> Supprimer
                                                </a>
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

            <div class="pagination-bar">
                <button id="prevPageBtn" onclick="navigateClass(-1)"><i class="fas fa-angle-left"></i> Classe Précédente</button>
                <div>
                    <span id="pageIndicator" style="font-weight: bold; color: #ffd700;">Classe : --</span>
                    <span id="classCount" style="margin-left: 15px; font-size: 0.95rem; color: #7f8c8d; font-weight: 500;">(0 élève)</span>
                </div>
                <button id="nextPageBtn" onclick="navigateClass(1)">Classe Suivante <i class="fas fa-angle-right"></i></button>
            </div>

        </div>
    </div>
</div>

<div id="eleveModal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2><i class="fas fa-user-shield"></i> Fiche Profil Élève</h2>
        <div class="modal-body">
            <img id="m-photo" class="modal-img" src="${pageContext.request.contextPath}/images/default-avatar.png" alt="Photo Profil" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default-avatar.png';">
            <div class="modal-info">
                <p><strong>Nom complet :</strong> <span id="m-full-name"></span></p>
                <p><strong>ID Élève :</strong> <span id="m-id"></span></p>
                <p><strong>Sexe :</strong> <span id="m-sexe"></span></p>
                <p><strong>Date naissance :</strong> <span id="m-date"></span></p>
                <p><strong>Classe :</strong> <span id="m-classe"></span></p>
                <p><strong>Parent / Tuteur :</strong> <span id="m-parent"></span></p>
                <p><strong>Email tuteur :</strong> <span id="m-parent-email"></span></p>
                <p><strong>Téléphone tuteur :</strong> <span id="m-parent-phone"></span></p>
            </div>
        </div>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    // Disparition du toast/alerte après 6 secondes
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.opacity = 0;
                setTimeout(function() {
                    alert.remove();
                }, 500); // Supprime du DOM après l'animation de fondu
            });
        }, 6000); // 6000 ms = 6 secondes
    });
</script>
<script src="${pageContext.request.contextPath}/js/eleve/list.js"></script>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>