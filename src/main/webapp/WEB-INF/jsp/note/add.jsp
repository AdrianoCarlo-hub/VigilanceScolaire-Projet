<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="add.css" %>
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/note" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour au carnet
    </a>
    <h2><i class="fas fa-pen-alt"></i> Saisir une Note</h2>

    <form action="${pageContext.request.contextPath}/note/save" method="post">

        <div class="form-group">
            <label><i class="fas fa-id-badge"></i> ID Élève *</label>
            <input type="number" name="eleve.id_eleve" class="form-control" required placeholder="Ex: 104">
        </div>

        <div class="form-group">
            <label><i class="fas fa-book"></i> Matière *</label>
            <input type="text" name="matiere" class="form-control" required placeholder="Ex: Mathématiques">
        </div>

        <div class="form-group">
            <label><i class="fas fa-chart-bar"></i> Note / 20 *</label>
            <input type="number" step="0.25" min="0" max="20" name="valeur" class="form-control" required placeholder="Ex: 15.5">
        </div>

        <div class="form-group">
            <label><i class="fas fa-balance-scale"></i> Coefficient *</label>
            <input type="number" name="coefficient" class="form-control" required placeholder="Ex: 2">
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-save"></i> Enregistrer la note
        </button>
    </form>
</div>

</body>
</html>