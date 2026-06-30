<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="edit.css" %>
</style>

<div class="main-layout">
    <div class="sidebar-container"><jsp:include page="../includes/sidebar.jsp" /></div>

    <div class="content">
        <div class="form-container">
            <h2><i class="fas fa-bell-edit"></i> Modifier l'alerte</h2>

            <form action="${pageContext.request.contextPath}/alertes/update" method="post">
                <input type="hidden" name="id_alerte" value="${alerte.id_alerte}">

                <div class="form-group">
                    <label><i class="fas fa-id-badge"></i> Identifiant de l'élève</label>
                    <input type="number" name="id_eleve" value="${alerte.id_eleve}" class="form-control" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-sliders-h"></i> Canal de diffusion</label>
                    <select name="canal" class="form-control">
                        <option value="SMS" <c:if test="${alerte.canal == 'SMS'}">selected</c:if>>SMS</option>
                        <option value="EMAIL" <c:if test="${alerte.canal == 'EMAIL'}">selected</c:if>>Email</option>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-shield-exclamation"></i> Type d'alerte</label>
                    <select name="type" class="form-control">
                        <option value="ABSENCE" <c:if test="${alerte.type == 'ABSENCE'}">selected</c:if>>Absence</option>
                        <option value="RETARD" <c:if test="${alerte.type == 'RETARD'}">selected</c:if>>Retard</option>
                        <option value="NOTE" <c:if test="${alerte.type == 'NOTE'}">selected</c:if>>Note</option>
                        <option value="DISCIPLINE" <c:if test="${alerte.type == 'DISCIPLINE'}">selected</c:if>>Discipline</option>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-tasks"></i> Statut du traitement</label>
                    <select name="statut" class="form-control">
                        <option value="EN_ATTENTE" <c:if test="${alerte.statut == 'EN_ATTENTE'}">selected</c:if>>En attente</option>
                        <option value="ENVOYE" <c:if test="${alerte.statut == 'ENVOYE'}">selected</c:if>>Envoyé</option>
                        <option value="ERREUR" <c:if test="${alerte.statut == 'ERREUR'}">selected</c:if>>Erreur d'envoi</option>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> Date de l'événement</label>
                    <input type="datetime-local" name="date_alerte" value="${alerte.date_alerte}" class="form-control" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-comment-alt-edit"></i> Message de vigilance</label>
                    <textarea name="message" class="form-control" required>${alerte.message}</textarea>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-sync-alt"></i> Mettre à jour l'alerte
                </button>
            </form>
        </div>
    </div>
</div>

</body>
</html>