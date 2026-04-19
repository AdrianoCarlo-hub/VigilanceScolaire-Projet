<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/note" class="btn-back">← Retour au carnet</a>
    <h2>Saisir une Note</h2>

    <form action="${pageContext.request.contextPath}/note/save" method="post">
        <div class="form-group">
            <label>Élève (ID)</label>
            <input type="number" name="eleve.id_eleve" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Matière</label>
            <input type="text" name="matiere" class="form-control" required placeholder="Ex: Mathématiques">
        </div>

        <div class="form-group">
            <label>Note /20 (utilisez '.' pour les décimales)</label>
            <input type="number" step="0.25" min="0" max="20" name="valeur" class="form-control" required placeholder="Ex: 15.5">
        </div>

        <div class="form-group">
            <label>Coefficient</label>
            <input type="number" name="coefficient" class="form-control" required placeholder="Ex: 2">
        </div>

        <button type="submit" class="btn-submit">Enregistrer la note</button>
    </form>
</div>

</body>
</html>