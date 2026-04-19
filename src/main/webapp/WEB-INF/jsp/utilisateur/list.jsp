<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <h2 style="color:white">Utilisateurs Système</h2>
            <a href="${pageContext.request.contextPath}/utilisateur/add" class="btn-add">Créer un Utilisateur</a>
            <table class="table-dark">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom d'utilisateur</th>
                        <th>Rôle</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${utilisateurs}">
                        <tr>
                            <td>${u.id_utilisateur}</td>
                            <td class="product-name">${u.username}</td>
                            <td>${u.role}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/utilisateur/modifier/${u.id_utilisateur}" class="edit-link">Modifier</a>
                                <a href="${pageContext.request.contextPath}/utilisateur/supprimer/${u.id_utilisateur}" class="delete-link">Supprimer</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>