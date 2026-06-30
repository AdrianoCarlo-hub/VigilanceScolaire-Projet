<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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

            <div class="dashboard-header">
                <h2><i class="fas fa-book-open"></i> Carnet de Notes</h2>

                <div class="search-bar">
                    <input type="text" id="searchInput" class="search-input"
                           placeholder="Rechercher élève, classe ou matière..."
                           onkeyup="filterNotes()">
                    <button onclick="clearSearch()" class="btn-clear">
                        <i class="fas fa-times"></i> Effacer
                    </button>
                </div>

                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                    <a href="${pageContext.request.contextPath}/note/add" class="btn-add">
                        <i class="fas fa-plus-circle"></i> Saisir une Note
                    </a>
                </sec:authorize>
            </div>

            <div id="notesContainer">
                <c:if test="${empty notesByClass}">
                    <div class="no-data">
                        <p><i class="fas fa-folder-open" style="font-size: 24px; color: #ffd700; margin-bottom: 10px;"></i><br>
                            Aucune note enregistrée pour votre profil d'enseignement ou d'étude.</p>
                        <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                            <a href="${pageContext.request.contextPath}/note/add" class="btn-add">
                                <i class="fas fa-pencil-alt"></i> Saisir une note maintenant
                            </a>
                        </sec:authorize>
                    </div>
                </c:if>

                <c:forEach var="entry" items="${notesByClass}">
                    <div class="class-section" data-classname="${entry.key}">
                        <div class="class-actions">
                            <h3 class="class-title">
                                <i class="fas fa-school"></i> Classe : ${entry.key}
                                <span class="badge-count" id="count-${fn:replace(entry.key, ' ', '_')}">${fn:length(entry.value)} notes</span>
                            </h3>
                        </div>

                        <table class="table-dark" id="table-${fn:replace(entry.key, ' ', '_')}">
                            <thead>
                            <tr>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 0)"><i class="fas fa-user-graduate"></i> Élève <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 1)"><i class="fas fa-school"></i> Classe <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 2)"><i class="fas fa-bookmark"></i> Matière <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 3)"><i class="fas fa-star"></i> Note <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 4)"><i class="fas fa-balance-scale"></i> Coeff <i class="fas fa-sort"></i></th>
                                <th onclick="sortTable('table-${fn:replace(entry.key, ' ', '_')}', 5)"><i class="fas fa-calendar-alt"></i> Date <i class="fas fa-sort"></i></th>
                                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                    <th><i class="fas fa-tools"></i> Actions</th>
                                </sec:authorize>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="n" items="${entry.value}">
                                <tr data-eleve="${n.eleve.nom} ${n.eleve.prenom}" data-classe="${n.eleve.classe.nom}" data-matiere="${n.matiere}">
                                    <td><strong>${n.eleve.nom.toUpperCase()}</strong> ${n.eleve.prenom}</td>
                                    <td><span class="badge-count" style="background: rgba(255,215,0,0.1); color: #ffd700; padding: 3px 8px; border-radius: 4px; font-size: 12px; border: 1px solid rgba(255,215,0,0.2);">${n.eleve.classe.nom}</span></td>
                                    <td class="product-name">${n.matiere}</td>

                                    <td>
                                        <span class="note-tag
                                            <c:choose>
                                                <c:when test="${n.valeur < 10}">note-faible</c:when>
                                                <c:when test="${n.valeur < 14}">note-moyenne</c:when>
                                                <c:otherwise>note-elevee</c:otherwise>
                                            </c:choose>
                                        ">
                                            ${n.valeur} / 20
                                        </span>
                                    </td>
                                    <td><code>x${n.coefficient}</code></td>
                                    <td>${n.date_note}</td>

                                    <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/note/modifier/${n.id_note}" class="edit-link">
                                                <i class="fas fa-edit"></i> Modifier
                                            </a>
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <a href="${pageContext.request.contextPath}/note/supprimer/${n.id_note}" class="delete-link"
                                                   onclick="return confirm('⚠️ Supprimer définitivement cette note ?')">
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
                    <span id="classCount" style="margin-left: 15px; font-size: 0.95rem; color: #7f8c8d; font-weight: 500;">(0 note)</span>
                </div>
                <button id="nextPageBtn" onclick="navigateClass(1)">Classe Suivante <i class="fas fa-angle-right"></i></button>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/note/list.js"></script>
</body>
</html>