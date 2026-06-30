<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="formulaire.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>

    <div class="content">
        <div class="communication-wrapper">

            <h1><i class="fas fa-paper-plane"></i> Envoyer une communication</h1>

            <div class="card">
                <div class="card-header">
                    <i class="fas fa-id-card"></i> Informations de l'élève et du tuteur
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <span class="label"><i class="fas fa-user-graduate"></i> Élève :</span>
                        <span>${alerte.prenomEleve} ${alerte.nomEleve.toUpperCase()}</span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-envelope"></i> Email parent :</span>
                        <span>${alerte.emailParent}</span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-phone-alt"></i> Téléphone :</span>
                        <span>${alerte.telephoneParent}</span>
                    </div>
                    <div class="info-row">
                        <span class="label"><i class="fas fa-exclamation-triangle"></i> Type d'alerte :</span>
                        <span>
                            <c:choose>
                                <c:when test="${alerte.typeAlerte == 'NOTE_INSUFFISANTE'}">📉 Note insuffisante</c:when>
                                <c:otherwise>🚫 Absence non justifiée</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="message-auto">
                        <strong><i class="fas fa-robot"></i> Contenu généré automatiquement par le système :</strong><br>
                        ${alerte.messageAuto}
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <i class="fas fa-pen-nib"></i> Personnaliser le message de notification
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/communication/envoyer" method="post">
                        <input type="hidden" name="idAlerte" value="${alerte.idAlerte}">

                        <label for="messagePersonnalise">
                            <i class="fas fa-comment-alt-lines"></i> Complément d'information ou directives pour le parent :
                        </label>
                        <textarea id="messagePersonnalise" name="messagePersonnalise" rows="5"
                                  placeholder="Exemple : Bonjour, l'établissement souhaite vous rencontrer suite à cet incident. Veuillez contacter le secrétariat..."
                                  required></textarea>

                        <div class="action-buttons">
                            <button type="submit">
                                <i class="fas fa-share-square"></i> Distribuer par SMS & Email
                            </button>
                            <a href="${pageContext.request.contextPath}/communication/alertes" class="btn-annuler">
                                <i class="fas fa-times-circle"></i> Annuler
                            </a>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
</body>
</html>