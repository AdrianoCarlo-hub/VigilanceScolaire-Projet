<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="classement.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">

            <div class="page-header">
                <div class="page-title-group">
                    <h2><i class="fas fa-users-class"></i> Classe : ${classe.nom}</h2>
                    <p class="periode-badge"><i class="fas fa-calendar-alt"></i> Période : ${periodeLibelle}</p>
                </div>
                <div class="btn-action-group">
                    <a href="${pageContext.request.contextPath}/bulletin" class="btn-print btn-back-custom">
                        <i class="fas fa-arrow-left"></i> Retour aux classes
                    </a>
                </div>
            </div>

            <div class="responsive-table-wrapper">
                <table class="table-dark">
                    <thead>
                    <tr>
                        <th><i class="fas fa-list-ol"></i> N°</th>
                        <th><i class="fas fa-id-card"></i> Matricule</th>
                        <th><i class="fas fa-user"></i> Nom & Prénom</th>
                        <th><i class="fas fa-star"></i> Moyenne</th>
                        <th><i class="fas fa-trophy"></i> Rang</th>
                        <th><i class="fas fa-cogs"></i> Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="c" items="${classement}" varStatus="status">
                        <tr class="
                                <c:if test="${c.rang == 1}">rang-1</c:if>
                                <c:if test="${c.rang == 2}">rang-2</c:if>
                                <c:if test="${c.rang == 3}">rang-3</c:if>
                            ">
                            <td>${status.index + 1}</td>
                            <td>${c.matricule}</td>
                            <td><strong>${c.nom.toUpperCase()}</strong> ${c.prenom}</td>
                            <td style="font-weight: bold; color: #ffd700;">${c.moyenneGenerale}/20</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.rang == 1}">
                                        <span class="medal-icon">🥇</span> <strong>${c.rang}</strong>
                                    </c:when>
                                    <c:when test="${c.rang == 2}">
                                        <span class="medal-icon">🥈</span> <strong>${c.rang}</strong>
                                    </c:when>
                                    <c:when test="${c.rang == 3}">
                                        <span class="medal-icon">🥉</span> <strong>${c.rang}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        ${c.rang}
                                    </c:otherwise>
                                </c:choose>
                                <span style="color: #888; font-size: 13px;">/ ${classement.size()}</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/bulletin/eleve/${c.idEleve}?trimestre=${trimestre}" class="btn-print">
                                    <i class="fas fa-file-alt"></i> Bulletin
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>