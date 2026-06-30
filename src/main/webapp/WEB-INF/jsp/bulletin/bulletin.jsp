<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="bulletin.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>

    <div class="content">
        <div class="action-bar no-print">
            <button onclick="window.print()" class="btn-print">
                <i class="fas fa-print"></i> Imprimer le bulletin
            </button>
            <a href="${pageContext.request.contextPath}/bulletin/classe/${bulletin.classe.id_classe}?trimestre=${trimestre}" class="btn-back">
                <i class="fas fa-arrow-left"></i> Retour
            </a>
        </div>

        <div class="bulletin-container">
            <div class="bulletin-header">
                <h1><i class="fas fa-graduation-cap"></i> BULLETIN SCOLAIRE</h1>
                <h3>Établissement Scolaire Vigilance</h3>

                <div class="bulletin-metadata">
                    <span><i class="fas fa-calendar-alt"></i> Année: ${bulletin.classe.annee_scolaire}</span>
                    <span><i class="fas fa-clock"></i> <strong>Période:</strong> ${bulletin.periode}</span>
                    <span><i class="fas fa-file-invoice"></i> <strong>Édition:</strong> <fmt:formatDate value="${bulletin.dateEdition}" pattern="dd/MM/yyyy"/></span>
                </div>
            </div>

            <div class="info-eleve">
                <div class="info-group">
                    <strong><i class="fas fa-user-graduate"></i> Élève :</strong> ${bulletin.eleve.nom} ${bulletin.eleve.prenom}
                </div>
                <div class="info-group">
                    <strong><i class="fas fa-school"></i> Classe :</strong> ${bulletin.classe.nom}
                </div>
                <div class="info-group">
                    <strong><i class="fas fa-id-card"></i> ID Élève :</strong> ${bulletin.eleve.id_eleve}
                </div>
                <div class="info-group">
                    <strong><i class="fas fa-user-tie"></i> Prof. Principal :</strong> ${bulletin.nomProfesseurPrincipal}
                </div>
            </div>

            <table class="notes-table">
                <thead>
                <tr>
                    <th><i class="fas fa-book"></i> Matière</th>
                    <th style="text-align: center;"><i class="fas fa-star"></i> Note /20</th>
                    <th style="text-align: center;"><i class="fas fa-balance-scale"></i> Coeff.</th>
                    <th style="text-align: center;"><i class="fas fa-calculator"></i> Total</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="matiere" items="${bulletin.matieres}">
                    <tr>
                        <td><strong>${matiere.matiere}</strong></td>
                        <td style="text-align: center; font-weight: bold;
                        <c:choose>
                        <c:when test="${matiere.note >= 16}">color: #27ae60;</c:when>
                        <c:when test="${matiere.note >= 10}">color: #f39c12;</c:when>
                        <c:otherwise>color: #e74c3c;</c:otherwise>
                        </c:choose>
                                ">${matiere.note}</td>
                        <td style="text-align: center;">${matiere.coefficient}</td>
                        <td style="text-align: center;">${matiere.total}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <div class="summary-grid">
                <div class="moyenne-box">
                    <h2>${bulletin.moyenneGenerale}/20</h2>
                    <p>Moyenne Générale du Trimestre</p>
                </div>

                <div class="rang-box">
                    <span><i class="fas fa-trophy" style="color: #f1c40f;"></i> <strong>RANG DANS LA CLASSE</strong></span>
                    <div class="rang-value">
                        ${bulletin.rang} / ${bulletin.totalEleves}
                        <c:if test="${bulletin.rang == 1}"> 👑</c:if>
                        <c:if test="${bulletin.rang == 2}"> 🥈</c:if>
                        <c:if test="${bulletin.rang == 3}"> 🥉</c:if>
                    </div>
                </div>
            </div>

            <div class="appreciation">
                <strong><i class="fas fa-comment-medical"></i> APPRÉCIATION DU PROFESSEUR PRINCIPAL :</strong>
                <p style="margin-top: 10px; line-height: 1.5; color: #34495e;">${bulletin.appreciation}</p>
            </div>

            <div class="appreciation observation-box">
                <strong><i class="fas fa-pen-fancy"></i> OBSERVATIONS COMPLÉMENTAIRES :</strong>
                <textarea rows="3" placeholder="Saisir des remarques ou décisions du conseil de classe..."></textarea>
            </div>

            <div class="signatures">
                <div class="signature-line">
                    <div class="line"></div>
                    <p>Signature du parent</p>
                </div>
                <div class="signature-line">
                    <div class="line"></div>
                    <p>Signature du professeur</p>
                </div>
                <div class="signature-line">
                    <div class="line"></div>
                    <p>Cachet de l'établissement</p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>