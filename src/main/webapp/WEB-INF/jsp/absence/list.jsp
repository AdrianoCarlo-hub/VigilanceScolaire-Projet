<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="list.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">

        <div id="alertPanel" class="alert-panel" style="display:none;">
            <i class="fas fa-bell fa-shake"></i> Vous avez <span id="alertCount">0</span> alerte(s) non lue(s).
            <div id="alertListContainer"></div>
        </div>

        <div class="stats-cards">
            <div class="card-stat">
                <h3>Total Absences</h3>
                <p id="statTotal">0</p>
            </div>
            <div class="card-stat">
                <h3>Absences Justifiées</h3>
                <p id="statJustifiees">0</p>
            </div>
            <div class="card-stat">
                <h3>Absences Non Justifiées</h3>
                <p id="statNonJustifiees">0</p>
            </div>
            <div class="card-stat">
                <h3>Absents Aujourd'hui</h3>
                <p id="statAujourdHui">0</p>
            </div>
            <div class="card-stat">
                <h3>Classe la plus touchée</h3>
                <p id="statClasseMax" style="font-size: 1.2rem;">-</p>
            </div>
            <div class="card-stat">
                <h3>Élève le plus absent</h3>
                <p id="statEleveMax" style="font-size: 1.2rem;">-</p>
            </div>
        </div>

        <div class="custom-table-container">
            <div class="table-header-flex">
                <h2><i class="fas fa-list-alt"></i> Gestion des Absences</h2>
                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                    <a href="${pageContext.request.contextPath}/absence/add" class="btn-add">
                        <i class="fas fa-plus-circle"></i> Enregistrer une absence
                    </a>
                </sec:authorize>
            </div>

            <div class="search-filter-bar">
                <input type="text" id="globalSearch" placeholder="Rechercher élève, matricule, motif..." onkeyup="filterTable()">
                <button onclick="resetFilters()" class="btn-reset" style="background-color: #e74a3b;"><i class="fas fa-times"></i> Vider</button>
                <button onclick="loadClassesAndFetchAbsences()" class="btn-reset" style="background-color: #3498db; margin-left: 5px;"><i class="fas fa-sync-alt"></i> Recharger</button>
            </div>

            <div class="table-responsive">
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th onclick="sortColumn('photo')">Photo</th>
                            <th onclick="sortColumn('eleve')">Élève <i class="fas fa-sort" id="sort-eleve"></i></th>
                            <th onclick="sortColumn('matricule')">ID Élève <i class="fas fa-sort" id="sort-matricule"></i></th>
                            <th onclick="sortColumn('classe')">Classe <i class="fas fa-sort" id="sort-classe"></i></th>
                            <th onclick="sortColumn('date')">Date <i class="fas fa-sort" id="sort-date"></i></th>
                            <th onclick="sortColumn('motif')">Motif <i class="fas fa-sort" id="sort-motif"></i></th>
                            <th>Statut Justification</th>
                            <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                <th>Actions</th>
                            </sec:authorize>
                        </tr>
                    </thead>
                    <tbody id="absenceTableBody">
                        </tbody>
                </table>
            </div>

            <div class="pagination-bar">
                <button id="prevPageBtn" onclick="navigateClass(-1)"><i class="fas fa-angle-left"></i> Classe Précédente</button>
                <div>
                    <span id="pageIndicator" style="font-weight: bold; color: var(--accent-gold);">Classe : --</span>
                    <span id="classCount" style="margin-left: 15px; font-size: 0.95rem; color: var(--text-gray); font-weight: 500;">(0 absent)</span>
                </div>
                <button id="nextPageBtn" onclick="navigateClass(1)">Classe Suivante <i class="fas fa-angle-right"></i></button>
            </div>
        </div>

    </div>
</div>

<div id="absenceModal" class="modal">
    <div class="modal-content animate-top">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2><i class="fas fa-user-graduate"></i> Fiche de détails - Absence</h2>
        <hr>
        <div class="modal-body-grid">
            <div class="modal-img-wrapper">
                <img id="modalPhoto" src="" class="img-modal" onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.png'">
            </div>
            <div class="modal-infos">
                <p><strong>Nom complet :</strong> <span id="modalNomComplet"></span></p>
                <p><strong>ID Élève :</strong> <span id="modalMatricule"></span></p>
                <p><strong>Classe :</strong> <span id="modalClasse"></span></p>
                <p><strong>Date :</strong> <span id="modalDate"></span></p>
                <p><strong>Motif :</strong> <span id="modalMotif"></span></p>
                <p><strong>Statut :</strong> <span id="modalBadge"></span></p>
                <p><strong>Enregistré par :</strong> <span id="modalEnseignant"></span></p>
                <p><strong>Date d'enregistrement :</strong> <span id="modalDateEnregistrement"></span></p>
            </div>
        </div>
        <div style="text-align: right; margin-top: 15px;">
            <button class="btn-action" onclick="notifierParent()"><i class="fas fa-envelope"></i> Notifier les parents (Email/SMS)</button>
        </div>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/absence/list.js"></script>

<jsp:include page="../includes/footer.jsp" />