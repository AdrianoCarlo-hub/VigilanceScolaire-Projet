<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <h2 style="color:white">Liste des Classes</h2>
            <a href="${pageContext.request.contextPath}/classe/add" class="btn-add">Créer une Classe</a>
            <table class="table-dark">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Niveau</th>
                        <th>Année Scolaire</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${classes}">
                        <tr>
                            <td>${c.id_classe}</td>
                            <td class="product-name">${c.nom}</td>
                            <td>${c.niveau}</td>
                            <td>${c.annee_scolaire}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/classe/modifier/${c.id_classe}" class="edit-link">Modifier</a>
                                <a href="${pageContext.request.contextPath}/classe/supprimer/${c.id_classe}" class="delete-link">Supprimer</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>