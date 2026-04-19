<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Alertes à traiter</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:hover { background-color: #f5f5f5; }
        .btn { background-color: #008CBA; color: white; padding: 8px 15px; text-decoration: none; border-radius: 5px; }
        .btn:hover { background-color: #005f7a; }
        .badge-note { background-color: #ff9800; padding: 3px 10px; border-radius: 5px; color: white; font-size: 12px; }
        .badge-absence { background-color: #f44336; padding: 3px 10px; border-radius: 5px; color: white; font-size: 12px; }
        .info-parent { font-size: 12px; color: #666; }
    </style>
</head>
<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>
    <div class="content">
<body>
    <div class="content">
        <h1>📢 Alertes en attente d'envoi</h1>

        <c:if test="${empty alertes}">
            <div style="text-align: center; padding: 50px; background: #e8f5e9; border-radius: 10px;">
                ✅ Aucune alerte en attente
            </div>
        </c:if>

        <c:if test="${not empty alertes}">
            <table>
                <thead>
                    <tr>
                        <th>Élève</th>
                        <th>Type</th>
                        <th>Message</th>
                        <th>Contact parent</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${alertes}" var="alerte">
                        <tr>
                            <td><strong>${alerte.prenomEleve} ${alerte.nomEleve}</strong></td>
                            <td>
                                <c:choose>
                                    <c:when test="${alerte.typeAlerte == 'NOTE_INSUFFISANTE'}">
                                        <span class="badge-note">📉 Note insuffisante</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-absence">🚫 Absence non justifiée</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="max-width: 400px;">${alerte.messageAuto}</td>
                            <td>
                                📧 ${alerte.emailParent}<br>
                                📱 ${alerte.telephoneParent}
                            </td>
                            <td>
                                <a href="/communication/envoyer/${alerte.idAlerte}" class="btn">✉️ Envoyer SMS/Email</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</body>
</html>