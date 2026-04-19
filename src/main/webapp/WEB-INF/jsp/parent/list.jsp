<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <h2 style="color:white">Liste des Parents</h2>
            <a href="${pageContext.request.contextPath}/parent/add" class="btn-add">Ajouter un Parent</a>
            <table class="table-dark">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom & Prénom</th>
                        <th>Téléphone</th>
                        <th>Email</th>
                        <th>Adresse</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${parents}">
                        <tr>
                            <td>${p.id_parent}</td>
                            <td class="product-name">${p.nom} ${p.prenom}</td>
                            <td>${p.telephone}</td>
                            <td>${p.email}</td>
                            <td>${p.adresse}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/parent/modifier/${p.id_parent}" class="edit-link">Modifier</a>
                                <a href="${pageContext.request.contextPath}/parent/supprimer/${p.id_parent}" class="delete-link">Supprimer</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>