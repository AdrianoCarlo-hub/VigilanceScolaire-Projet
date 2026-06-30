<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/journal_alertes.css">

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">

        <div id="toastContainer" class="toast-container"></div>

        <div class="stats-cards">
            <div class="card-stat">
                <h3>Total Alertes</h3>
                <p id="statTotal">0</p>
            </div>
            <div class="card-stat">
                <h3>Alertes Envoyees</h3>
                <p id="statEnvoyees">0</p>
            </div>
            <div class="card-stat">
                <h3>Alertes Echouees</h3>
                <p id="statEchouees">0</p>
            </div>
            <div class="card-stat">
                <h3>Alertes SMS</h3>
                <p id="statSms">0</p>
            </div>
            <div class="card-stat">
                <h3>Alertes Email</h3>
                <p id="statEmail">0</p>
            </div>
            <div class="card-stat">
                <h3>Alertes du Jour</h3>
                <p id="statAujourdHui">0</p>
            </div>
        </div>

        <div class="custom-table-container">
            <div class="table-header-actions">
                <h2><i class="fas fa-history"></i> Journal des Alertes (Vigilance)</h2>
                <div class="header-actions">
                    <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                        <a href="${pageContext.request.contextPath}/alerte/add" class="btn-add">
                            <i class="fas fa-plus-circle"></i> Nouvelle Alerte
                        </a>
                    </sec:authorize>
                    <button onclick="exportPdf()" class="btn-export btn-pdf"><i class="fas fa-file-pdf"></i> PDF</button>
                    <button onclick="exportExcel()" class="btn-export btn-excel"><i class="fas fa-file-excel"></i> Excel</button>
                    <button onclick="printTable()" class="btn-export btn-print"><i class="fas fa-print"></i> Imprimer</button>
                </div>
            </div>

            <div class="search-filter-bar">
                <input type="text" id="globalSearch" placeholder="Rechercher eleve, matricule, type, canal..." onkeyup="filterTable()">
                <button onclick="resetFilters()" class="btn-reset"><i class="fas fa-times"></i> Vider</button>
                <button onclick="loadClassesAndFetchAlerts()" class="btn-reload"><i class="fas fa-sync-alt"></i> Recharger</button>
            </div>

            <div class="responsive-table-wrapper">
                <table class="table-dark">
                    <thead>
                        <tr>
                            <th onclick="sortColumn('id')">ID <i class="fas fa-sort" id="sort-id"></i></th>
                            <th onclick="sortColumn('eleve')">Eleve <i class="fas fa-sort" id="sort-eleve"></i></th>
                            <th onclick="sortColumn('matricule')">Matricule <i class="fas fa-sort" id="sort-matricule"></i></th>
                            <th onclick="sortColumn('classe')">Classe <i class="fas fa-sort" id="sort-classe"></i></th>
                            <th onclick="sortColumn('date')">Date <i class="fas fa-sort" id="sort-date"></i></th>
                            <th onclick="sortColumn('type')">Type <i class="fas fa-sort" id="sort-type"></i></th>
                            <th onclick="sortColumn('canal')">Canal <i class="fas fa-sort" id="sort-canal"></i></th>
                            <th onclick="sortColumn('statut')">Statut <i class="fas fa-sort" id="sort-statut"></i></th>
                            <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                <th>Actions</th>
                            </sec:authorize>
                        </tr>
                    </thead>
                    <tbody id="alertTableBody">
                    </tbody>
                </table>
            </div>

            <div class="pagination-bar">
                <button id="prevPageBtn" onclick="navigateClass(-1)"><i class="fas fa-angle-left"></i> Classe Precedente</button>
                <div>
                    <span id="pageIndicator" style="font-weight: bold; color: #ffd700;">Classe : --</span>
                    <span id="classCount" style="margin-left: 15px; font-size: 0.95rem; color: #7f8c8d; font-weight: 500;">(0 alerte)</span>
                </div>
                <button id="nextPageBtn" onclick="navigateClass(1)">Classe Suivante <i class="fas fa-angle-right"></i></button>
            </div>
        </div>

    </div>
</div>

<div id="alertModal" class="modal">
    <div class="modal-content animate-top">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2><i class="fas fa-info-circle"></i> Fiche de details - Alerte</h2>
        <hr>
        <div class="modal-body-grid">
            <div class="modal-infos">
                <p><strong>ID Alerte :</strong> <span id="modalId"></span></p>
                <p><strong>Nom complet :</strong> <span id="modalNomComplet"></span></p>
                <p><strong>Matricule :</strong> <span id="modalMatricule"></span></p>
                <p><strong>Classe :</strong> <span id="modalClasse"></span></p>
                <p><strong>Date :</strong> <span id="modalDate"></span></p>
                <p><strong>Type d'alerte :</strong> <span id="modalType"></span></p>
                <p><strong>Canal :</strong> <span id="modalCanal"></span></p>
                <p><strong>Statut :</strong> <span id="modalBadge"></span></p>
                <p><strong>Message envoye :</strong> <span id="modalMessage"></span></p>
                <p><strong>Cree par :</strong> <span id="modalCreateur"></span></p>
                <p><strong>Date de creation :</strong> <span id="modalDateCreation"></span></p>
                <p><strong>Date de modification :</strong> <span id="modalDateModification"></span></p>
            </div>
        </div>
        <div class="modal-actions-footer">
            <button class="btn-action btn-resend" onclick="reenvoyerAlerte()"><i class="fas fa-paper-plane"></i> Reenvoyer</button>
            <button class="btn-action btn-duplicate" onclick="dupliquerAlerte()"><i class="fas fa-copy"></i> Dupliquer</button>
        </div>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/alerte/list.js"></script>

<jsp:include page="../includes/footer.jsp" />