<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <h2 style="color:white">Gestion des Événements</h2>
            <a href="${pageContext.request.contextPath}/evenement/add" class="btn-add">Ajouter Événement</a>
            <table class="table-dark">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Type</th>
                        <th>Date</th>
                        <th>Gravité</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ev" items="${evenements}">
                        <tr>
                            <td>${ev.id_evenement}</td>
                            <td class="product-name">${ev.type}</td>
                            <td>${ev.date_evenement}</td>
                            <td>${ev.gravite}</td>
                            <td>${ev.description}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/evenement/modifier/${ev.id_evenement}" class="edit-link">Modifier</a>
                                <a href="${pageContext.request.contextPath}/evenement/supprimer/${ev.id_evenement}" class="delete-link">Supprimer</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>