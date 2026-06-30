<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    <%@ include file="add.css" %>
</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/note" class="btn-back">
        <i class="fas fa-arrow-left"></i> Retour à la liste
    </a>
    <h2><i class="fas fa-edit"></i> Modifier la Note</h2>

    <form action="${pageContext.request.contextPath}/note/save" method="post">
        <input type="hidden" name="id_note" value="${note.id_note}">

        <div class="form-group">
            <label><i class="fas fa-book"></i> Matière *</label>
            <input type="text" name="matiere" value="${note.matiere}" class="form-control" required>
        </div>

        <div class="form-group">
            <label><i class="fas fa-chart-bar"></i> Valeur (Note) *</label>
            <input type="number" step="0.01" min="0" max="20" name="valeur" value="${note.valeur}" class="form-control" required>
        </div>

        <div class="form-group">
            <label><i class="fas fa-balance-scale"></i> Coefficient *</label>
            <input type="number" name="coefficient" value="${note.coefficient}" class="form-control" required>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fas fa-sync-alt"></i> Mettre à jour
        </button>
    </form>
</div>

</body>
</html>