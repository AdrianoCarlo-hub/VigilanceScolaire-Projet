<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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

            <div class="table-header">
                <h2><i class="fas fa-users-cog"></i> Utilisateurs Système</h2>
                <a href="${pageContext.request.contextPath}/utilisateur/add" class="btn-add">
                    <i class="fas fa-user-plus"></i> Créer un Utilisateur
                </a>
            </div>

            <c:if test="${empty utilisateurs}">
                <div class="no-data">
                    <p>
                        <i class="fas fa-user-shield" style="font-size: 28px; color: #ffd700; margin-bottom: 12px;"></i><br>
                        Aucun compte utilisateur staff répertorié dans le système.
                    </p>
                </div>
            </c:if>

            <c:if test="${not empty utilisateurs}">
                <table class="table-dark">
                    <thead>
                    <tr>
                        <th><i class="fas fa-hashtag"></i> ID</th>
                        <th><i class="fas fa-user-tag"></i> Nom d'utilisateur</th>
                        <th><i class="fas fa-shield-alt"></i> Rôle</th>
                        <th><i class="fas fa-tools"></i> Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="u" items="${utilisateurs}">
                        <tr>
                            <td class="id-cell">${u.id_utilisateur}</td>
                            <td class="product-name">
                                <i class="far fa-user" style="color: #00d4ff; margin-right: 6px;"></i>
                                <strong>${u.username}</strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role == 'ADMIN'}">
                                            <span class="role-badge badge-admin">
                                                <i class="fas fa-crown"></i> Administrateur
                                            </span>
                                    </c:when>
                                    <c:when test="${u.role == 'PROFESSEUR'}">
                                            <span class="role-badge badge-professeur">
                                                <i class="fas fa-chalkboard-teacher"></i> Professeur
                                            </span>
                                    </c:when>
                                    <c:when test="${u.role == 'SURVEILLANT'}">
                                            <span class="role-badge badge-surveillant">
                                                <i class="fas fa-user-clock"></i> Surveillant
                                            </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="role-badge badge-surveillant">${u.role}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="action-buttons">
                                <a href="${pageContext.request.contextPath}/utilisateur/modifier/${u.id_utilisateur}" class="edit-link">
                                    <i class="fas fa-user-edit"></i> Modifier
                                </a>
                                <a href="${pageContext.request.contextPath}/utilisateur/supprimer/${u.id_utilisateur}" class="delete-link"
                                   onclick="return confirm('⚠️ Êtes-vous sûr de vouloir révoquer et supprimer ce compte staff ? Cette personne perdra ses accès immédiatement.')">
                                    <i class="fas fa-user-minus"></i> Supprimer
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>