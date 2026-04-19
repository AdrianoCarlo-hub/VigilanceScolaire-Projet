<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/classe" class="btn-back">← Retour aux classes</a>
    <h2>Ajouter une Classe</h2>

    <form action="${pageContext.request.contextPath}/classe/save" method="post">
        <div class="form-group">
            <label>Nom de la classe</label>
            <input type="text" name="nom" class="form-control" required placeholder="Ex: 6ème A">
        </div>

        <div class="form-group">
            <label>Niveau</label>
            <input type="text" name="niveau" class="form-control" placeholder="Ex: Collège">
        </div>

        <div class="form-group">
            <label>Année Scolaire</label>
            <input type="text" name="annee_scolaire" class="form-control" required placeholder="Ex: 2023-2024">
        </div>

        <button type="submit" class="btn-submit">Créer la classe</button>
    </form>
</div>

</body>
</html>