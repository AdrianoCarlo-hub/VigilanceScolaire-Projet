<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<jsp:include page="../includes/header.jsp" />

<style>
    .btn-print { background: #27ae60; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; display: inline-block; }
    .btn-back { background: #666; }
    .rang-1 { background-color: rgba(255, 215, 0, 0.3); font-weight: bold; }
    .rang-2 { background-color: rgba(192, 192, 192, 0.3); }
    .rang-3 { background-color: rgba(205, 127, 50, 0.3); }
    .periode-badge { background: #00d4ff; color: #1a252f; padding: 5px 15px; border-radius: 20px; display: inline-block; }
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
        <div class="custom-table-container">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
                <div>
                    <h2 style="color:white">📚 ${classe.nom}</h2>
                    <p class="periode-badge">📅 ${periodeLibelle}</p>
                </div>
                <a href="/bulletin" class="btn-back btn-print" style="background:#666;">← Retour aux classes</a>
            </div>

            <table class="table-dark" style="margin-top: 20px;">
                <thead>
                    <tr>
                        <th>N°</th><th>Matricule</th><th>Nom & Prénom</th>
                        <th>Moyenne</th><th>Rang</th><th>Action</th>
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
                            <td><strong>${c.nom}</strong> ${c.prenom}</td>
                            <td style="font-weight: bold; color: #ffd700;">${c.moyenneGenerale}/20</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.rang == 1}">🥇 ${c.rang}</c:when>
                                    <c:when test="${c.rang == 2}">🥈 ${c.rang}</c:when>
                                    <c:when test="${c.rang == 3}">🥉 ${c.rang}</c:when>
                                    <c:otherwise>${c.rang}</c:otherwise>
                                </c:choose>
                                / ${classement.size()}
                            </td>
                            <td><a href="/bulletin/eleve/${c.idEleve}?trimestre=${trimestre}" class="btn-print">📄 Bulletin</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />