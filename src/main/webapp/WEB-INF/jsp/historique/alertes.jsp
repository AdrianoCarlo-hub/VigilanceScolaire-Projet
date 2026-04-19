<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Historique des alertes</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1400px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; vertical-align: top; }
        th { background-color: #4CAF50; color: white; }
        tr:hover { background-color: #f5f5f5; }
        .badge-note { background-color: #ff9800; padding: 3px 10px; border-radius: 5px; color: white; font-size: 12px; display: inline-block; }
        .badge-absence { background-color: #f44336; padding: 3px 10px; border-radius: 5px; color: white; font-size: 12px; display: inline-block; }
        .message-preview { max-width: 300px; white-space: pre-wrap; word-wrap: break-word; font-size: 12px; background: #f9f9f9; padding: 5px; border-radius: 3px; }
        .error-message { background-color: #f44336; color: white; padding: 10px; border-radius: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📜 Historique des alertes envoyées</h1>

        <c:if test="${not empty erreur}">
            <div class="error-message">
                ❌ Erreur: ${erreur}
            </div>
        </c:if>

        <c:if test="${empty historique}">
            <div style="text-align: center; padding: 50px; background: #e8f5e9; border-radius: 10px;">
                📭 Aucune alerte envoyée pour le moment
            </div>
        </c:if>

        <c:if test="${not empty historique}">
            <p><strong>Total:</strong> ${historique.size()} alerte(s) envoyée(s)</p>
            <table>
                <thead>
                    <tr>
                        <th>Date envoi</th>
                        <th>Élève</th>
                        <th>Matricule</th>
                        <th>Parent</th>
                        <th>Type</th>
                        <th>Message alerte</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${historique}" var="h">
                        <tr>
                            <td style="white-space: nowrap;">
                                ${h.dateEnvoi}
                            </td>
                            <td>
                                <strong>${h.prenomEleve} ${h.nomEleve}</strong>
                            </td>
                            <td>${h.matricule}</td>
                            <td>
                                ${h.prenomParent} ${h.nomParent}<br>
                                <small>📧 ${h.emailParent}<br>📱 ${h.telephoneParent}</small>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${h.typeAlerte == 'NOTE_INSUFFISANTE'}">
                                        <span class="badge-note">📉 Note insuffisante</span>
                                    </c:when>
                                    <c:when test="${h.typeAlerte == 'ABSENCE_NON_JUSTIFIEE'}">
                                        <span class="badge-absence">🚫 Absence</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-note">${h.typeAlerte}</span>
                                    </c:otherwise>
                                </c:choose>
                             </td>
                             <td class="message-preview">${h.messageAuto}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <div style="margin-top: 20px;">
            <a href="/communication/alertes" style="color: #008CBA;">← Retour aux alertes en attente</a>
        </div>
    </div>
</body>
</html>