<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    <%@ include file="list.css" %>
</style>
<div class="main-layout">
    <div class="sidebar-container">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div class="content">
        <div class="custom-table-container">
            <!-- Header -->
            <div class="table-header-actions">
                <h2><i class="fas fa-chalkboard"></i> Liste des Classes</h2>
                <sec:authorize access="hasRole('ADMIN')">
                    <a href="${contextPath}/classe/add" class="btn-add">
                        <i class="fas fa-plus-circle"></i> Créer une Classe
                    </a>
                </sec:authorize>
            </div>

            <!-- Filtres -->
            <div class="search-filter-bar">
                <div class="search-input-wrapper">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput"
                           placeholder="Rechercher par nom, niveau, année ou professeur..."
                           onkeyup="filterClasses()">
                </div>
                <button class="btn-reset" onclick="resetFilters()">
                    <i class="fas fa-times"></i> Réinitialiser
                </button>
            </div>

            <!-- Tableau -->
            <div class="responsive-table-wrapper">
                <table class="table-dark">
                    <thead>
                        <tr>
                            <th onclick="sortTable('id')">
                                <i class="fas fa-hashtag"></i> ID
                                <i id="sort-id-icon" class="fas fa-sort"></i>
                            </th>
                            <th onclick="sortTable('nom')">
                                <i class="fas fa-chalkboard"></i> Nom
                                <i id="sort-nom-icon" class="fas fa-sort"></i>
                            </th>
                            <th onclick="sortTable('niveau')">
                                <i class="fas fa-layer-group"></i> Niveau
                                <i id="sort-niveau-icon" class="fas fa-sort"></i>
                            </th>
                            <th onclick="sortTable('annee')">
                                <i class="fas fa-calendar-alt"></i> Année Scolaire
                                <i id="sort-annee-icon" class="fas fa-sort"></i>
                            </th>
                            <th>
                                <i class="fas fa-user-tie"></i> Professeur Principal
                            </th>
                            <th>
                                <i class="fas fa-cogs"></i> Actions
                            </th>
                        </tr>
                    </thead>
                    <tbody id="classeTableBody">
                        <c:choose>
                            <c:when test="${not empty classes}">
                                <c:forEach var="classe" items="${classes}">
                                    <tr data-id="${classe.id_classe}"
                                        data-nom="${classe.nom}"
                                        data-niveau="${classe.niveau}"
                                        data-annee="${classe.annee_scolaire}"
                                        data-prof="${classe.utilisateur != null ? classe.utilisateur.username : ''}">
                                        <td>${classe.id_classe}</td>
                                        <td><strong>${classe.nom}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${classe.niveau == 'Terminale'}">🎓 ${classe.niveau}</c:when>
                                                <c:when test="${classe.niveau == 'Première'}">📚 ${classe.niveau}</c:when>
                                                <c:when test="${classe.niveau == 'Seconde'}">📖 ${classe.niveau}</c:when>
                                                <c:otherwise>🏫 ${classe.niveau}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="badge-annee">${classe.annee_scolaire}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty classe.utilisateur}">
                                                    <div class="prof-info">
                                                        <i class="fas fa-user-circle"></i>
                                                        ${classe.utilisateur.username}
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: rgba(255,255,255,0.5);">
                                                        <i class="fas fa-user-times"></i> Non assigné
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${contextPath}/classe/edit/${classe.id_classe}" class="edit-link">
                                                <i class="fas fa-edit"></i> Modifier
                                            </a>
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <a href="${contextPath}/classe/delete/${classe.id_classe}"
                                                   class="delete-link"
                                                   onclick="return confirm('⚠️ Supprimer la classe ${classe.nom} ? Cette action est irréversible.')">
                                                    <i class="fas fa-trash-alt"></i> Supprimer
                                                </a>
                                            </sec:authorize>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 40px;">
                                        <i class="fas fa-folder-open" style="font-size: 48px; color: rgba(255,255,255,0.3);"></i>
                                        <p style="margin-top: 15px;">Aucune classe trouvée</p>
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <a href="${contextPath}/classe/add" class="btn-add" style="margin-top: 15px; display: inline-flex;">
                                                <i class="fas fa-plus-circle"></i> Créer la première classe
                                            </a>
                                        </sec:authorize>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="toastContainer" class="toast-container"></div>
<script>
    // Récupérer les messages flash depuis les attributs de session
    document.addEventListener('DOMContentLoaded', function() {
        <c:if test="${not empty success}">
            showToast('${success}', 'success');
        </c:if>
        <c:if test="${not empty error}">
            showToast('${error}', 'error');
        </c:if>
    });
</script>
<script src="${pageContext.request.contextPath}/js/classe/list.js"></script>

<jsp:include page="../includes/footer.jsp" />