<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../includes/header_form.jsp" />

<div class="form-container">
    <a href="${pageContext.request.contextPath}/classe" class="btn-back">← Retour à la liste</a>
    <h2>Modifier la Classe</h2>

    <form action="${pageContext.request.contextPath}/classe/save" method="post">
        <input type="hidden" name="id_classe" value="${classe.id_classe}">

        <div class="form-group"><label>Nom de la classe</label>
            <input type="text" name="nom" value="${classe.nom}" class="form-control" required></div>

        <div class="form-group"><label>Niveau</label>
            <input type="text" name="niveau" value="${classe.niveau}" class="form-control"></div>

        <div class="form-group"><label>Année Scolaire</label>
            <input type="text" name="annee_scolaire" value="${classe.annee_scolaire}" class="form-control"></div>

        <button type="submit" class="btn-submit">Mettre à jour</button>
    </form>
</div>
</body>
</html>