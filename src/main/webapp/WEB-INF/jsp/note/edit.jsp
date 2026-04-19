<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/note" class="btn-back">← Retour à la liste</a>
    <h2>Modifier la Note</h2>

    <form action="${pageContext.request.contextPath}/note/save" method="post">
        <input type="hidden" name="id_note" value="${note.id_note}">

        <div class="form-group"><label>Matière</label>
            <input type="text" name="matiere" value="${note.matiere}" class="form-control" required></div>

        <div class="form-group"><label>Valeur (Note)</label>
            <input type="number" step="0.01" name="valeur" value="${note.valeur}" class="form-control" required></div>

        <div class="form-group"><label>Coefficient</label>
            <input type="number" name="coefficient" value="${note.coefficient}" class="form-control" required></div>

        <button type="submit" class="btn-submit">Mettre à jour</button>
    </form>
</div>
</body>
</html>