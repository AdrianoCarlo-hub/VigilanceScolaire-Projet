<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="alerte.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>

    <div class="content">
        <div class="custom-table-container">
            <h1><i class="fas fa-bell"></i> Alertes en attente d'envoi</h1>

            <c:if test="${empty alertes}">
                <div class="empty-state">
                    <i class="fas fa-check-circle"></i>
                    <span>Toutes les alertes ont été traitées. Aucune notification en attente.</span>
                </div>
            </c:if>

            <c:if test="${not empty alertes}">
                <div class="responsive-table-wrapper">
                    <table class="table-dark">
                        <thead>
                        <tr>
                            <th><i class="fas fa-user-graduate"></i> Élève</th>
                            <th><i class="fas fa-exclamation-triangle"></i> Type</th>
                            <th><i class="fas fa-envelope-open-text"></i> Message généré</th>
                            <th><i class="fas fa-address-book"></i> Contact parent</th>
                            <th><i class="fas fa-paper-plane"></i> Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${alertes}" var="alerte">
                            <tr>
                                <td><strong>${alerte.prenomEleve} ${alerte.nomEleve.toUpperCase()}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${alerte.typeAlerte == 'NOTE_INSUFFISANTE'}">
                                            <span class="badge-note"><i class="fas fa-chart-line-down"></i> Note insuffisante</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-absence"><i class="fas fa-user-clock"></i> Absence non justifiée</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="max-width: 350px; line-height: 1.4; color: #ecf0f1;">
                                        ${alerte.messageAuto}
                                </td>
                                <td>
                                    <div class="contact-parent-info">
                                        <span><i class="fas fa-envelope"></i> ${alerte.emailParent}</span>
                                        <span><i class="fas fa-phone-alt"></i> ${alerte.telephoneParent}</span>
                                    </div>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/communication/envoyer/${alerte.idAlerte}" class="btn-send">
                                        <i class="fas fa-paper-plane"></i> Envoyer l'alerte
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>