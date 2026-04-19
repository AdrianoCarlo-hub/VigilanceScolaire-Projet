<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<style>
    .badge-moyenne { background: #ffd700; color: #333; padding: 2px 8px; border-radius: 12px; font-size: 11px; }
    .note-faible { color: #e74c3c; font-weight: bold; }
    .note-moyenne { color: #f39c12; }
    .note-elevee { color: #2ecc71; }
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h2 style="color:white">📝 Carnet de Notes</h2>
                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                    <a href="${pageContext.request.contextPath}/note/add" class="btn-add">➕ Saisir une Note</a>
                </sec:authorize>
            </div>

            <c:if test="${empty notes}">
                <div style="text-align: center; padding: 50px; color: white;">
                    <p>📭 Aucune note trouvée pour votre profil</p>
                    <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                        <a href="${pageContext.request.contextPath}/note/add" class="btn-add">Saisir une note</a>
                    </sec:authorize>
                </div>
            </c:if>

            <c:if test="${not empty notes}">
                <table class="table-dark">
                    <thead>
                        <tr>
                            <th>Élève</th>
                            <th>Classe</th>
                            <th>Matière</th>
                            <th>Note</th>
                            <th>Coeff</th>
                            <th>Date</th>
                            <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                <th>Actions</th>
                            </sec:authorize>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="n" items="${notes}">
                            <tr>
                                <td><strong>${n.eleve.nom}</strong> ${n.eleve.prenom}</td>
                                <td>${n.eleve.classe.nom}</td>
                                <td class="product-name">${n.matiere}</td>
                                <td class="
                                    <c:choose>
                                        <c:when test="${n.valeur < 10}">note-faible</c:when>
                                        <c:when test="${n.valeur < 14}">note-moyenne</c:when>
                                        <c:otherwise>note-elevee</c:otherwise>
                                    </c:choose>
                                ">${n.valeur}/20</td>
                                <td>${n.coefficient}</td>
                                <td>${n.date_note}</td>
                                <sec:authorize access="hasAnyRole('ADMIN', 'PROFESSEUR')">
                                    <td>
                                        <a href="${pageContext.request.contextPath}/note/modifier/${n.id_note}" class="edit-link">✏️ Modifier</a>
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <a href="${pageContext.request.contextPath}/note/supprimer/${n.id_note}" class="delete-link"
                                               onclick="return confirm('Supprimer cette note ?')">🗑️ Supprimer</a>
                                        </sec:authorize>
                                    </td>
                                </sec:authorize>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
</div>