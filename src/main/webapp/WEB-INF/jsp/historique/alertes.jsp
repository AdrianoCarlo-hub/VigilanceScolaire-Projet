<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="historique_alertes.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div class="content">
        <div class="container">

            <div class="history-header">
                <h1><i class="fas fa-history"></i> Historique des alertes envoyées</h1>
                <c:if test="${not empty historique}">
                    <span class="total-count">
                        <i class="fas fa-calculator"></i> Total : ${historique.size()} alerte(s)
                    </span>
                </c:if>
            </div>

            <c:if test="${not empty erreur}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> Erreur: ${erreur}
                </div>
            </c:if>

            <c:if test="${empty historique}">
                <div class="no-data">
                    <i class="fas fa-inbox"></i>
                    <span>Aucune alerte envoyée pour le moment dans l'historique de vigilance.</span>
                </div>
            </c:if>

            <c:if test="${not empty historique}">
                <div class="responsive-table-wrapper">
                    <table class="table-dark">
                        <thead>
                        <tr>
                            <th><i class="fas fa-clock"></i> Date envoi</th>
                            <th><i class="fas fa-user-graduate"></i> Élève</th>
                            <th><i class="fas fa-id-card"></i> Matricule</th>
                            <th><i class="fas fa-user-friends"></i> Parent</th>
                            <th><i class="fas fa-exclamation-circle"></i> Type</th>
                            <th><i class="fas fa-comment-alt"></i> Message alerte</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${historique}" var="h">
                            <tr>
                                <td style="white-space: nowrap; font-weight: bold; color: #00d4ff;">
                                    <c:choose>
                                        <c:when test="${h.dateEnvoi['class'].simpleName == 'Date' || h.dateEnvoi['class'].simpleName == 'Timestamp'}">
                                            <fmt:formatDate value="${h.dateEnvoi}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>
                                            ${h.dateEnvoi}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <strong>${h.nomEleve.toUpperCase()}</strong> ${h.prenomEleve}
                                </td>
                                <td><code>${h.matricule}</code></td>
                                <td class="parent-details">
                                    <strong>${h.nomParent.toUpperCase()}</strong> ${h.prenomParent}
                                    <small>
                                        <i class="fas fa-envelope"></i> ${h.emailParent}<br>
                                        <i class="fas fa-mobile-alt"></i> ${h.telephoneParent}
                                    </small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${h.typeAlerte == 'NOTE_INSUFFISANTE'}">
                                                <span class="badge badge-note">
                                                    <i class="fas fa-chart-line"></i> Note insuffisante
                                                </span>
                                        </c:when>
                                        <c:when test="${h.typeAlerte == 'ABSENCE_NON_JUSTIFIEE'}">
                                                <span class="badge badge-absence">
                                                    <i class="fas fa-user-times"></i> Absence
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-note">${h.typeAlerte}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="message-preview">${h.messageAuto}</div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <div style="margin-top: 25px;">
                <a href="/communication/alertes" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Retour aux alertes en attente
                </a>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>