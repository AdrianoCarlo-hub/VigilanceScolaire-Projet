<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />

<div class="main-layout">
    <div class="sidebar-container">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div class="content">
        <div class="custom-table-container">
            <h2 style="color:white">Journal des Alertes (Vigilance)</h2>

            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/alerte/add" class="btn-add">
                    <i class="fas fa-plus"></i> Nouvelle Alerte Manuelle
                </a>
            </div>

            <table class="table-dark">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Élève</th> <th>Date</th>
                        <th>Type</th>
                        <th>Canal</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="al" items="${alertes}">
                        <tr>
                            <td>${al.id_alerte}</td>
                            <td>${al.eleve.nom} ${al.eleve.prenom}</td>
                            <td class="product-name">${al.date_alerte}</td>
                            <td>
                                <span class="badge">${al.type}</span>
                            </td>
                            <td>${al.canal}</td>
                            <td>
                                <%-- Coloration dynamique du statut --%>
                                <c:choose>
                                    <c:when test="${al.statut == 'ENVOYÉ'}">
                                        <span style="color: #2ecc71; font-weight: bold;">✔ ${al.statut}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #e74c3c; font-weight: bold;">✘ ${al.statut}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <%-- Correction des variables : on utilise 'al' et non 'a' --%>
                                <a href="${pageContext.request.contextPath}/alerte/modifier/${al.id_alerte}" class="edit-link">Modifier</a>
                                <a href="${pageContext.request.contextPath}/alerte/supprimer/${al.id_alerte}"
                                   class="delete-link"
                                   onclick="return confirm('Voulez-vous supprimer cette trace d\'alerte ?');">Supprimer</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>