<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="add.css" %>
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/alerte" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour au journal
    </a>
    <h2><i class="fas fa-exclamation-triangle"></i> Créer une Alerte</h2>

    <form action="${pageContext.request.contextPath}/alerte/save" method="post">

        <div class="form-group">
            <label><i class="fas fa-id-badge"></i> Élève concerné (ID ou Matricule)</label>
            <input type="number" name="eleve.id_eleve" class="form-control" required placeholder="Ex: 1402">
        </div>

        <div class="form-group">
            <label><i class="fas fa-shield-exclamation"></i> Type d'alerte</label>
            <select name="type" class="form-control">
                <option value="ABSENCE">Absence non justifiée</option>
                <option value="RETARD">Retard répétitif</option>
                <option value="NOTE">Note insuffisante</option>
                <option value="DISCIPLINE">Incident de comportement</option>
            </select>
        </div>

        <div class="form-group">
            <label><i class="fas fa-sliders-h"></i> Canal de diffusion</label>
            <select name="canal" class="form-control">
                <option value="SMS">SMS (Alerte immédiate)</option>
                <option value="EMAIL">Email (Rapport de suivi)</option>
            </select>
        </div>

        <div class="form-group">
            <label><i class="fas fa-comment-alt-edit"></i> Corps du message</label>
            <textarea name="message" class="form-control" placeholder="Rédigez le texte de l'alerte à transmettre aux parents..."></textarea>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-paper-plane"></i> Transmettre l'alerte
        </button>
    </form>
</div>

</body>
</html>